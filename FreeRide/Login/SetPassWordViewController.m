//
//  SetPassWordViewController.m
//  FreeRide
//
//  Created by  on 2017/11/10.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "SetPassWordViewController.h"
#import "PromptViewController.h"
#import "Header.h"
#import "NaviView.h"
#import "UserDefaults.h"
#import "NetworkTool.h"
#import "SomeSupprt.h"

@interface SetPassWordViewController ()

@end

@implementation SetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NaviView *naviView = [[NaviView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, YMAKENEW(50)) andName:_titleName andTyep:@"normal"];
    naviView.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:naviView];
    [self createUI];
}
- (void)createUI {
    NSArray *placeholderName = @[@"请输入您的密码",@"请再次确认您的密码"];
    for (int i = 0; i < 2; i++) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(20), YMAKENEW(84) + YMAKENEW(47)*i, XMAKENEW(20), YMAKENEW(20))];
        imageview.image = [UIImage imageNamed:@"Password"];
        [self.view addSubview:imageview];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+XMAKENEW(5), CGRectGetMinY(imageview.frame), self.view.frame.size.width-CGRectGetMaxX(imageview.frame), imageview.frame.size.height)];
        textField.tag = 10000+i;
        textField.secureTextEntry = YES;
        [self setTextValue:textField andPlaceholderName:placeholderName[i]];
        [self.view addSubview:textField];
        //小眼睛按钮
        UIButton *seeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-XMAKENEW(40), CGRectGetMinY(textField.frame), XMAKENEW(30), XMAKENEW(30))];
        seeBtn.tag = 10010+i;
        [seeBtn setImage:[UIImage imageNamed:@"Greyeyes"] forState:UIControlStateNormal];
        [seeBtn setImage:[UIImage imageNamed:@"Eye"] forState:UIControlStateSelected];
        [seeBtn addTarget:self action:@selector(targetEye:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:seeBtn];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(12), CGRectGetMaxY(imageview.frame)+YMAKENEW(10), self.view.frame.size.width-2*XMAKENEW(12), 0.5)];
        line.backgroundColor = COLOR_TEXT_LIGHT;
        [self.view addSubview:line];
    }
    
    //确定
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(12.5), YMAKENEW(200), XMAKENEW(350), YMAKENEW(40))];
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
- (void)targetEye:(UIButton *)button {
    button.selected = !button.selected;
    UITextField *textField1 = [self.view viewWithTag:10000];
    UITextField *textField2 = [self.view viewWithTag:10001];
    if (button.selected) {
        if (button.tag == 10010) {
            textField1.secureTextEntry = NO;
        } else {
            textField2.secureTextEntry = NO;
        }
    } else {
        if (button.tag == 10010) {
            textField1.secureTextEntry = YES;
        } else {
            textField2.secureTextEntry = YES;
        }
    }
}
- (void)tagerLoginBtn {
    UITextField *text1 = [self.view viewWithTag:10000];
    UITextField *text2 = [self.view viewWithTag:10001];
    if ([text2.text isEqualToString:text1.text]) {
        [self netWorking:@{@"key":[UserDefaults getValueForKey:@"key"],@"phone":[UserDefaults getValueForKey:@"phone"],@"password":text2.text,@"flag":@"1"}];
    } else {
        [SomeSupprt createUIAlertWithMessage:@"两次密码输入不同" andDisappearTime:0.8];
    }
}
- (void)netWorking:(NSDictionary *)dict {
    [[NetworkTool sharedTool] requestWithURLString:WEB_SETPASSWORD
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
    PromptViewController *vc = [[PromptViewController alloc] init];
    vc.titleName = self.titleName;
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
