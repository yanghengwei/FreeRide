//
//  ResetPassWordController.m
//  FreeRide
//
//  Created by  on 2017/12/14.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "ResetPassWordController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "LoginViewController.h"
#import "PromptViewController.h"
#import "NetworkTool.h"
#import "AESCipher.h"
#import "SomeSupprt.h"
#import "UserDefaults.h"
#import "MainTableController.h"

@interface ResetPassWordController () <UIAlertViewDelegate>
{
    UIButton *VerificationBtn;
    int timeout;
}
@end

@implementation ResetPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UITextField *textField = [self.view viewWithTag:10000];
    if (_isLogin) {
        textField.text = aesDecryptString([UserDefaults getValueForKey:@"phone"], AESKEY);
    }
}
- (void)pushNextView:(NSString *)info {
    if ([info isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"点击了右侧按钮");
    }
}
- (void)createUI {
    //欢迎登录
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:_titleName andRightTitle:@""];
    [navi.rightBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    navi.block = ^(NSString *backInfo){
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    //创建输入框
    NSArray *imageName = @[@"telephone_icon",@"verification",@"Password",@"Password"];
    NSArray *placeholderName = @[@"请输入手机号",@"请输入验证码",@"请输入您的密码",@"请再次确认您的密码"];
    for (int i = 0; i < 4; i++) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(20), 82 + YMAKENEW(47)*i, XMAKENEW(20), YMAKENEW(20))];
        imageview.image = [UIImage imageNamed:imageName[i]];
        [self.view addSubview:imageview];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+XMAKENEW(5), CGRectGetMinY(imageview.frame), self.view.frame.size.width-CGRectGetMaxX(imageview.frame), imageview.frame.size.height)];
        textField.tag = 10000+i;
        [self setTextValue:textField andPlaceholderName:placeholderName[i]];
        [self.view addSubview:textField];
        if (i>1) {
            //小眼睛按钮
            UIButton *seeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-XMAKENEW(40), CGRectGetMinY(textField.frame)-XMAKENEW(7), XMAKENEW(30), XMAKENEW(30))];
            seeBtn.tag = 10010+i;
            [seeBtn setImage:[UIImage imageNamed:@"greyeyes"] forState:UIControlStateNormal];
            [seeBtn setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateSelected];
            [seeBtn addTarget:self action:@selector(targetEye:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:seeBtn];
        }
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(12), CGRectGetMaxY(imageview.frame)+YMAKENEW(10), self.view.frame.size.width-2*XMAKENEW(12), 0.5)];
        line.backgroundColor = COLOR_TEXT_LIGHT;
        [self.view addSubview:line];
    }
    //验证码按钮
    VerificationBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(280), 115, XMAKENEW(80), YMAKENEW(40))];
    [VerificationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [VerificationBtn addTarget:self action:@selector(getIDfromWeb) forControlEvents:UIControlEventTouchUpInside];
    [VerificationBtn setTitleColor:COLOR_ORANGE forState:UIControlStateNormal];
    VerificationBtn.titleLabel.font = [UIFont systemFontOfSize:FONT12];
    [self.view addSubview:VerificationBtn];
    //登录
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(12.5), YMAKENEW(320), XMAKENEW(350), YMAKENEW(40))];
    [loginBtn setTitle:@"确定" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(tagerLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = COLOR_ORANGE;
    loginBtn.layer.cornerRadius = 3.0;//2.0是圆角的弧度，根据需求自己更改
    loginBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    loginBtn.layer.borderWidth = 0.5f;//设置边框颜色
    [self.view addSubview:loginBtn];
}
- (void)setTextValue:(UITextField *)textField andPlaceholderName:(NSString *)nameString {
    NSString *holderText = nameString;
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:COLOR_TEXT_LIGHT
                        range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:FONT12]
                        range:NSMakeRange(0, holderText.length)];
    textField.attributedPlaceholder = placeholder;
}
//发送验证码
- (void)getIDfromWeb {
    UITextField *text1 = [self.view viewWithTag:10000];
    if (text1.text.length < 11) {
        [SomeSupprt createUIAlertWithMessage:@"请输入正确手机号" andDisappearTime:0.5];
        return;
    }
    [self getTestAndVerify:@{@"phone":text1.text}];
}
- (void)getTestAndVerify:(NSDictionary *)dic {
    [[NetworkTool sharedTool] requestWithURLString:WEB_GETTEST
                                        parameters:dic
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  [SomeSupprt createUIAlertWithMessage:@"发送成功" andDisappearTime:0.5];
                                                  [self startTimer];
                                              } else {
                                                  [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.5];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
}
- (void)startTimer {
    timeout = 59;
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [VerificationBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                VerificationBtn.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [VerificationBtn setTitle:[NSString stringWithFormat:@"%@″",strTime] forState:UIControlStateNormal];
                VerificationBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
- (void)netWorking:(NSDictionary *)dict andWebAdress:(NSString *)webAdress {
    [[NetworkTool sharedTool] requestWithURLString:webAdress
                                        parameters:dict
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  [self loginAndAction:[responseObject objectForKey:@"data"]];
                                              } else {
                                                  [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.8];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
}
- (void)loginAndAction:(NSDictionary *)dic {
    NSString *string;
    if (_isLogin) {
        string = @"修改成功";
    } else {
        string = @"设置成功，请重新登录";
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    alert.delegate = self;
    [alert show];
}
#pragma mark -- alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
        [self.navigationController popViewControllerAnimated:YES];
}
//登录
- (void)tagerLoginBtn {
    UITextField *text1 = [self.view viewWithTag:10000];
    UITextField *text2 = [self.view viewWithTag:10001];
    UITextField *text3 = [self.view viewWithTag:10002];
    UITextField *text4 = [self.view viewWithTag:10003];
    
    if (text1.text.length < 11) {
        [SomeSupprt createUIAlertWithMessage:@"请输入正确手机号" andDisappearTime:0.5];
        return;
    }
    if (text2.text.length < 1) {
        [SomeSupprt createUIAlertWithMessage:@"请输入正确手机号" andDisappearTime:0.5];
        return;
    }
    if ([text3.text isEqualToString:text4.text] && text4.text.length > 0) {
        if (_isLogin) {
            [self netWorking:@{@"phone":aesEncryptString(text1.text, AESKEY) ,@"code":text2.text,@"password":text4.text,@"flag":@"2",@"key":[UserDefaults getValueForKey:@"key"]} andWebAdress:WEB_SETPASSWORD];
        } else {
            [self netWorking:@{@"phone":aesEncryptString(text1.text, AESKEY) ,@"code":text2.text,@"password":text4.text} andWebAdress:WEB_FORGETPASSWORD];
        }
    } else {
        [SomeSupprt createUIAlertWithMessage:@"密码输入错误" andDisappearTime:0.8];
    }
}
- (void)targetEye:(UIButton *)button {
    button.selected = !button.selected;
    UITextField *textField1 = [self.view viewWithTag:10002];
    UITextField *textField2 = [self.view viewWithTag:10003];
    if (button.selected) {
        if (button.tag == 10012) {
            textField1.secureTextEntry = NO;
        } else {
            textField2.secureTextEntry = NO;
        }
    } else {
        if (button.tag == 10012) {
            textField1.secureTextEntry = YES;
        } else {
            textField2.secureTextEntry = YES;
        }
    }
}
//登录
//- (void)tagerLoginBtn {
//    PromptViewController *vc = [[PromptViewController alloc] init];
//    vc.promptStr = @"设置成功";
//    [self.navigationController pushViewController:vc animated:YES];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
