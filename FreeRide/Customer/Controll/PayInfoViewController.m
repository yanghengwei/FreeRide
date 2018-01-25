//
//  PayInfoViewController.m
//  FreeRide
//
//  Created by pc on 2017/11/16.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "PayInfoViewController.h"
#import "Header.h"
#import "PayInfoView.h"
#import "PersonalNaviView.h"
#import "PasswordAlertView.h"
#import "PromptViewController.h"
#import "WebViewController.h"

@interface PayInfoViewController ()

@end

@implementation PayInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"订单详情" andRightTitle:@"计价规则"];
    [navi.rightBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self createUI];
}
- (void)pushNextView:(NSString *)info {
    if ([info isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        WebViewController *webView = [[WebViewController alloc] init];
        webView.titleName = @"计价规则";
        webView.urlString = @"valuation_rules.html";
        [self.navigationController pushViewController:webView animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createUI {
    UIView *view = [[PayInfoView alloc] initWithFrame:CGRectMake(0, YMAKENEW(80), self.view.frame.size.width, YMAKENEW(350)) andTyep:@"long"];
    [self.view addSubview:view];
    
    UILabel *lastSmallLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, YMAKENEW(410), self.view.frame.size.width, YMAKENEW(25))];
    lastSmallLabel.textColor = COLOR_TEXT_LIGHT;
    lastSmallLabel.text = @"司机赶到，确认您已上车点击【我已上车确认付款】";
    lastSmallLabel.font = [UIFont systemFontOfSize:FONT12];
    lastSmallLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lastSmallLabel];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(20), CGRectGetMaxY(lastSmallLabel.frame), XMAKENEW(335), YMAKENEW(40))];
    [loginBtn setTitle:@"确认付款" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(tagerLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = COLOR_ORANGE;
    loginBtn.layer.cornerRadius = 3.0;//2.0是圆角的弧度，根据需求自己更改
    loginBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    loginBtn.layer.borderWidth = 0.5f;//设置边框颜色
    [self.view addSubview:loginBtn];
}
- (void)tagerLoginBtn {
    PromptViewController *vc = [[PromptViewController alloc] init];
    vc.titleName = @"paySuccess";
    vc.promptStr = @"支付成功";
    [self.navigationController pushViewController:vc animated:YES];
//    PasswordAlertView *passView = [[PasswordAlertView alloc]initSingleBtnView];
//    passView.passWordTextConfirm =^(NSString *text){//点击确定按钮输出密码
//        NSLog(@"%@",text);
//        NSLog(@"点击了确定按钮");
//    };
//    [passView show];
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
