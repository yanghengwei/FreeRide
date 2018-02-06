//
//  LoginViewController.m
//  FreeRide
//
//  Created by  on 2017/11/9.
//  Copyright © 2017年 JNR All rights reserved.
//




#import "LoginViewController.h"
#import "RegistViewController.h"
#import "MainTableController.h"
#import "Header.h"
#import "ResetPassWordController.h"
#import "NetworkTool.h"
#import "AESCipher.h"
#import "SomeSupprt.h"
#import "UserDefaults.h"
#import "SetPassWordViewController.h"
#import <UIImageView+WebCache.h>
#import "CompressImage.h"
#import "WebViewController.h"


@interface LoginViewController ()
{
    UIButton *swichBtn;
    UIButton *forgetBtn;
    UIButton *agreeBtn;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
}
- (void)createUI {
    //欢迎登录
    UILabel *welcomeLbl = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(20), YMAKENEW(40), XMAKENEW(200), YMAKENEW(60))];
    welcomeLbl.text = @"欢迎登录";
    welcomeLbl.font = [UIFont systemFontOfSize:20];
    welcomeLbl.textColor = COLOR_ORANGE;
    [self.view addSubview:welcomeLbl];
    //验证码登录
    swichBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(285), YMAKENEW(40), XMAKENEW(80), YMAKENEW(50))];
    [swichBtn setTitle:@"验证码登录" forState:UIControlStateNormal];
    [swichBtn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [swichBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    swichBtn.titleLabel.font = [UIFont systemFontOfSize:FONT12];
    [self.view addSubview:swichBtn];
    //创建输入框
    NSArray *imageName = @[@"telephone_icon",@"Password"];
    NSArray *placeholderName = @[@"请输入手机号码",@"请输入密码"];
    for (int i = 0; i < 2; i++) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(20), YMAKENEW(125) + YMAKENEW(47)*i, XMAKENEW(20), YMAKENEW(20))];
        imageview.image = [UIImage imageNamed:imageName[i]];
        [self.view addSubview:imageview];

        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+XMAKENEW(5), CGRectGetMinY(imageview.frame), self.view.frame.size.width-CGRectGetMaxX(imageview.frame), imageview.frame.size.height)];
        textField.tag = 10000+i;
        [self setTextValue:textField andPlaceholderName:placeholderName[i]];
        [self.view addSubview:textField];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(12), CGRectGetMaxY(imageview.frame)+YMAKENEW(10), self.view.frame.size.width-2*XMAKENEW(12), 0.5)];
        line.backgroundColor = COLOR_TEXT_LIGHT;
        [self.view addSubview:line];
    }
    //忘记密码
    forgetBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(135), YMAKENEW(205), XMAKENEW(75), YMAKENEW(40))];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(forgetPassWord) forControlEvents:UIControlEventTouchUpInside];
    [forgetBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    [forgetBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -forgetBtn.imageView.frame.size.width, 0, forgetBtn.imageView.frame.size.width)];
    [forgetBtn setImageEdgeInsets:UIEdgeInsetsMake(0, forgetBtn.titleLabel.bounds.size.width, 0, -forgetBtn.titleLabel.bounds.size.width)];
    [forgetBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:FONT12];
    [self.view addSubview:forgetBtn];
    
    //登录
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(12.5), YMAKENEW(265), XMAKENEW(350), YMAKENEW(40))];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(tagerLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = COLOR_ORANGE;
    loginBtn.layer.cornerRadius = 3.0;//2.0是圆角的弧度，根据需求自己更改
    loginBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    loginBtn.layer.borderWidth = 0.5f;//设置边框颜色
    [self.view addSubview:loginBtn];
    
    agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(120), YMAKENEW(305), XMAKENEW(60), YMAKENEW(40))];
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(agreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [agreeBtn setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateNormal];
    [agreeBtn setImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    [agreeBtn setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:FONT12];
    agreeBtn.selected = YES;
    [self.view addSubview:agreeBtn];
    
    UIButton *agreementBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(agreeBtn.frame), CGRectGetMinY(agreeBtn.frame), XMAKENEW(90), YMAKENEW(40))];
    [agreementBtn setTitle:@"《用户协议》" forState:UIControlStateNormal];
    [agreementBtn addTarget:self action:@selector(agreementBtn) forControlEvents:UIControlEventTouchUpInside];
    [agreementBtn setTitleColor:COLOR_ORANGE forState:UIControlStateNormal];
    agreementBtn.titleLabel.font = [UIFont systemFontOfSize:FONT12];
    [self.view addSubview:agreementBtn];
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
//忘记密码
- (void)forgetPassWord {
    ResetPassWordController *vc = [[ResetPassWordController alloc] init];
    vc.titleName = @"重置登录密码";
    [self.navigationController pushViewController:vc animated:YES];
}
//登录
- (void)tagerLoginBtn {
    UITextField *text1 = [self.view viewWithTag:10000];
    UITextField *text2 = [self.view viewWithTag:10001];
    if (!agreeBtn.selected) {
        [SomeSupprt createUIAlertWithMessage:@"请查看用户协议并同意" andDisappearTime:0.8];
        return;
    }
    if (text1.text.length > 0 && text2.text.length > 0) {
#warning NONet
//        [self loginAndAction:@{@"key":@"1",@"phone":@"1",@"id":@"1"}];
        [self netWorking:@{@"phone":text1.text,@"password":text2.text}];
    } else {
        [SomeSupprt createUIAlertWithMessage:@"手机号或者密码为空" andDisappearTime:0.8];
    }
}
- (void)netWorking:(NSDictionary *)dict {
    [[NetworkTool sharedTool] requestWithURLString:WEB_LOGIN_PASSWORD
                                        parameters:dict
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  [self loginAndAction:[responseObject objectForKey:@"data"]];
                                                  [self downPersonInfo];
                                              } else {
                                                  [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.8];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
}
- (void)downPersonInfo {
    [[NetworkTool sharedTool] requestWithURLString:WEB_DOWNPERSONINFO
                                        parameters:@{@"phone":[UserDefaults getValueForKey:@"phone"],
                                                     @"key":[UserDefaults getValueForKey:@"key"]}
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  [self savePersonInfo:[responseObject objectForKey:@"data"]];
                                              } else {
                                                  [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.8];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
}
- (void)savePersonInfo:(NSDictionary *)personDic {
    NSArray *arr = [personDic allKeys];
    for (NSString *key in arr) {
        if ([key isEqualToString:@"phone"]) {
            continue;
        }
        [UserDefaults saveValue:[personDic objectForKey:key] forKey:key];
    }
    [self downImageFromWeb];
}
- (void)downImageFromWeb {
    UIImageView *headImageView = [[UIImageView alloc] init];
    NSString *imageString = [NSString stringWithFormat:@"http://%@/%@",FRHEAD,[UserDefaults getValueForKey:@"head_portrait"]];
    NSURL *imageUrl = [NSURL URLWithString:imageString];
    [headImageView sd_setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       [UserDefaults saveValue:compressImage(headImageView.image , 10) forKey:@"headImage"];
    }];
}
- (void)loginAndAction:(NSDictionary *)dic {
    [UserDefaults saveValue:[dic objectForKey:@"key"] forKey:@"key"];
    [UserDefaults saveValue:[dic objectForKey:@"id"] forKey:@"id"];
    [UserDefaults saveValue:[dic objectForKey:@"phone"] forKey:@"phone"];
    if ([[dic objectForKey:@"isNewUser"] boolValue]) {
        SetPassWordViewController *vc = [[SetPassWordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if (_isBack) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            UIWindow * window = [[UIApplication sharedApplication] keyWindow];
            window.rootViewController  = [[UINavigationController alloc] initWithRootViewController:[[MainTableController alloc] init]];
        }
    }
}
//用户协议
- (void)agreementBtn {
    WebViewController *webView = [[WebViewController alloc] init];
    webView.titleName = @"用户协议";
    webView.urlString = @"user_agreement.html";
    [self.navigationController pushViewController:webView animated:YES];
}
//同意用户协议
- (void)agreeBtn:(UIButton *)button {
    button.selected=!button.selected;
}
//验证码、密码切换
- (void)changeBtn:(UIButton *)button {
    RegistViewController *vc = [[RegistViewController alloc] init];
    vc.isBack = self.isBack;
    [self.navigationController pushViewController:vc animated:YES];
}
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
