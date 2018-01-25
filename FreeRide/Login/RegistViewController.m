//
//  RegistViewController.m
//  FreeRide
//
//  Created by  on 2017/11/9.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "RegistViewController.h"
#import "Header.h"
#import "LoginViewController.h"
#import "SetPassWordViewController.h"
#import "NetworkTool.h"
#import "AESCipher.h"
#import "SomeSupprt.h"
#import "UserDefaults.h"
#import "MainTableController.h"
#import "CompressImage.h"
#import <UIImageView+WebCache.h>
#import "CompressImage.h"
#import "WebViewController.h"
#import "CodeView.h"

@interface RegistViewController ()
{
    UIButton *swichBtn;
    UIButton *VerificationBtn;
    UIButton *agreeBtn;
    int timeout;
    NSDictionary *backDic;
    CodeView *codeView;
    NSInteger numTarger;
}
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    numTarger = 0;
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
    [swichBtn setTitle:@"密码登录" forState:UIControlStateNormal];
    [swichBtn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [swichBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    swichBtn.titleLabel.font = [UIFont systemFontOfSize:FONT12];
    [self.view addSubview:swichBtn];
    //创建输入框
    NSArray *imageName = @[@"telephone_icon",@"Password"];
    NSArray *placeholderName = @[@"请输入手机号登录/注册",@"请输入验证码"];
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
    //验证码按钮
    VerificationBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(280), YMAKENEW(160), XMAKENEW(80), YMAKENEW(40))];
    [VerificationBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [VerificationBtn addTarget:self action:@selector(getIDfromWeb) forControlEvents:UIControlEventTouchUpInside];
    [VerificationBtn setTitleColor:COLOR_ORANGE forState:UIControlStateNormal];
    VerificationBtn.titleLabel.font = [UIFont systemFontOfSize:FONT12];
    [self.view addSubview:VerificationBtn];
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
    
    agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(120), YMAKENEW(305), XMAKENEW(45), YMAKENEW(40))];
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(agreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [agreeBtn setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateNormal];
    [agreeBtn setImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    [agreeBtn setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:FONT12];
    agreeBtn.selected = YES;
    [self.view addSubview:agreeBtn];
    
    UIButton *agreementBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(agreeBtn.frame), CGRectGetMinY(agreeBtn.frame), XMAKENEW(75), YMAKENEW(40))];
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
//发送验证码
- (void)getIDfromWeb {
    UITextField *text1 = [self.view viewWithTag:10000];
    if (text1.text.length < 1) {
        [SomeSupprt createUIAlertWithMessage:@"请输入正确手机号" andDisappearTime:0.5];
        return;
    }
    codeView = [[CodeView alloc] initWithFrame:self.view.bounds];
    __weak typeof(self) weakSelf = self;
    codeView.block = ^(NSString *backInfo) {
        if ([backInfo isEqualToString:@"changeImage"]) {
            [weakSelf getCodeImage];
        } else {
            [weakSelf getTestAndVerify:@{@"phone":text1.text,@"code":backInfo}];
        }
    };
    [self.view addSubview:codeView];
    [self getCodeImage];

//    [self getTestAndVerify:@{@"phone":text1.text}];
}
- (void)getCodeImage {
    UITextField *text1 = [self.view viewWithTag:10000];NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimeInterval a=[dat timeIntervalSince1970];
//    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    NSString *imageString = [NSString stringWithFormat:@"http://%@/kaptcha/getKaptchaImage.htm?phone=%@&timestamp=%ld",FRHEAD,text1.text,numTarger++];
    NSURL *imageUrl = [NSURL URLWithString:imageString];
    [codeView.imageView sd_setImageWithURL:imageUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
}
- (void)getTestAndVerify:(NSDictionary *)dic {
    [[NetworkTool sharedTool] requestWithURLString:WEB_GETTEST
                                        parameters:dic
                                            method:@"POST"
                                          callBack:^(id responseObject) {
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
            [SomeSupprt createUIAlertWithMessage:@"发送成功" andDisappearTime:0.5];
            [codeView removeFromSuperview];
            [self startTimer];
        } else {
            [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.5];
        }
        NSLog(@"%@",responseObject);
    }];
    
//    NSData *imageData = compressImage([UIImage imageNamed:@"WechatIMG1186.jpeg"], 10);
//    NSLog(@"%lukkb",imageData.length/1024);
//    NSString *_encodedImageStr = [imageData base64Encoding];
//    NSDictionary *mydic = @{@"type":@"1",@"phone":[UserDefaults getValueForKey:@"phone"],@"key":[UserDefaults getValueForKey:@"key"],@"object":_encodedImageStr};
////    NSLog(@"%@",imageData);
//    [[NetworkTool sharedTool] requestWithURLString:@"http://192.168.0.103:8080/admin/uploadImg.htm" parameters:mydic method:@"POST" callBack:^(id responseObject) {
//        if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
//            [SomeSupprt createUIAlertWithMessage:@"发送成功" andDisappearTime:0.5];
//        } else {
//            [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.5];
//        }
//        NSLog(@"%@",responseObject);
//    }];
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
- (void)netWorking:(NSDictionary *)dict {
    [[NetworkTool sharedTool] requestWithURLString:WEB_LOGIN_TEST
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
//登录
- (void)tagerLoginBtn {
    UITextField *text1 = [self.view viewWithTag:10000];
    UITextField *text2 = [self.view viewWithTag:10001];
    if (!agreeBtn.selected) {
        [SomeSupprt createUIAlertWithMessage:@"请查看用户协议并同意" andDisappearTime:0.8];
        return;
    }
    if (text1.text.length > 0 && text2.text.length > 0) {
        [self netWorking:@{@"phone":text1.text,@"code":text2.text}];
    } else {
        [SomeSupprt createUIAlertWithMessage:@"手机号或者验证码为空" andDisappearTime:0.8];
    }
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
}//用户协议
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
    [self.navigationController popViewControllerAnimated:YES];
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
