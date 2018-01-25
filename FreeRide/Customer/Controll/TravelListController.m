//
//  TravelListController.m
//  FreeRide
//
//  Created by  on 2017/11/29.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "TravelListController.h"
#import "Header.h"
#import "PayInfoView.h"
#import "PersonalNaviView.h"
#import "DriverInfoView.h"
#import "DetailInfoController.h"
#import "PayInfoViewController.h"
#import "ChooseBtnView.h"
#import "CancelController.h"
#import "WebViewController.h"

@interface TravelListController ()

@end

@implementation TravelListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"订单详情" andRightTitle:@"+"];
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
        ChooseBtnView *view = [[ChooseBtnView alloc] initWithFrame:self.view.bounds];
        __weak typeof(self) weakSelf = self;
        view.block = ^(NSString *backInfo) {
            if ([backInfo isEqualToString:@"cancel"]) {
                CancelController *vc = [[CancelController alloc] init];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else if ([backInfo isEqualToString:@"计价规则"]) {
                WebViewController *webView = [[WebViewController alloc] init];
                webView.titleName = @"计价规则";
                webView.urlString = @"valuation_rules.html";
                [self.navigationController pushViewController:webView animated:YES];
            }
        };
        [self.view addSubview:view];
    }
}
- (void)createUI {
    
    DriverInfoView *headView = [[DriverInfoView alloc] initWithFrame:CGRectMake(0, YMAKENEW(90), self.view.frame.size.width, YMAKENEW(110))];
    [self.view addSubview:headView];
    
    //订单详情页面按钮
    UIButton *infoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame), self.view.frame.size.width, YMAKENEW(30))];
    [infoBtn setTitle:@"订单信息" forState:UIControlStateNormal];
    [infoBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    [infoBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    infoBtn.titleLabel.font = [UIFont systemFontOfSize:FONT12];
    [infoBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -infoBtn.imageView.frame.size.width+XMAKENEW(10), 0, infoBtn.imageView.frame.size.width)];
    [infoBtn setImageEdgeInsets:UIEdgeInsetsMake(0, infoBtn.titleLabel.bounds.size.width+XMAKENEW(20), 0, -infoBtn.titleLabel.bounds.size.width)];
    [infoBtn addTarget:self action:@selector(pushInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:infoBtn];
    //line
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(20), CGRectGetMaxY(infoBtn.frame)+YMAKENEW(10), self.view.frame.size.width-XMAKENEW(40), 2)];
    line.backgroundColor = COLOR_background;
    [self.view addSubview:line];
    
    UIView *view = [[PayInfoView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame)+XMAKENEW(10), self.view.frame.size.width, YMAKENEW(180)) andTyep:@"long"];
    [self.view addSubview:view];
    
    UILabel *lastSmallLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame)+XMAKENEW(50), self.view.frame.size.width, YMAKENEW(25))];
    lastSmallLabel.textColor = COLOR_TEXT_LIGHT;
    lastSmallLabel.text = @"司机赶到，确认您已上车点击【我已上车确认付款】";
    lastSmallLabel.font = [UIFont systemFontOfSize:FONT12];
    lastSmallLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lastSmallLabel];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(20), CGRectGetMaxY(lastSmallLabel.frame), XMAKENEW(335), YMAKENEW(40))];
    [loginBtn setTitle:@"确认我已上车" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(tagerLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = COLOR_ORANGE;
    loginBtn.layer.cornerRadius = 3.0;//2.0是圆角的弧度，根据需求自己更改
    loginBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    loginBtn.layer.borderWidth = 0.5f;//设置边框颜色
    [self.view addSubview:loginBtn];
}
- (void)pushInfo:(UIButton *)button {
    NSLog(@"点击订单详情");
    DetailInfoController *VC= [[DetailInfoController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)tagerLoginBtn {
    PayInfoViewController *VC = [[PayInfoViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
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
