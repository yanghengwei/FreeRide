//
//  OrderInfoController.m
//  FreeRide
//
//  Created by pc on 2017/11/17.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "OrderInfoController.h"
#import "DriverInfoView.h"
#import "Header.h"
#import "PayInfoView.h"
#import "PersonalNaviView.h"
#import "DetailInfoController.h"
#import "EvaluationChooseView.h"
#import "WebViewController.h"


@interface OrderInfoController ()
{
    UIButton *loginBtn;
    UIButton *button;
    UILabel *lastSmallLabel;
}
@end

@implementation OrderInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
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
- (void)createUI {
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"订单详情" andRightTitle:@"计价规则"];
    [navi.rightBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    
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
    
    PayInfoView *payView = [[PayInfoView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame)+YMAKENEW(10), self.view.frame.size.width, 190) andTyep:@"short"];
    [self.view addSubview:payView];
    
    
    lastSmallLabel = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(20), CGRectGetMaxY(payView.frame)+YMAKENEW(25), XMAKENEW(335), YMAKENEW(25))];
    lastSmallLabel.textColor = COLOR_TEXT_LIGHT;
    lastSmallLabel.text = @"确认您已到达目的地点击【确认到达目的地】，以免影响您的下次行程";
    lastSmallLabel.adjustsFontSizeToFitWidth = YES;;
    lastSmallLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lastSmallLabel];
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(20), CGRectGetMaxY(payView.frame)+YMAKENEW(25), XMAKENEW(335), YMAKENEW(25))];
    [button setTitle:@"评价本次服务 >" forState:UIControlStateNormal];
    [button setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goToEvaluation) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:button];
    
    loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(lastSmallLabel.frame), CGRectGetMaxY(lastSmallLabel.frame), lastSmallLabel.frame.size.width, YMAKENEW(40))];
    [loginBtn setTitle:@"确认到达目的地" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(tagerLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = COLOR_ORANGE;
    loginBtn.layer.cornerRadius = 3.0;//2.0是圆角的弧度，根据需求自己更改
    loginBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    loginBtn.layer.borderWidth = 0.5f;//设置边框颜色
    [self.view addSubview:loginBtn];
}
- (void)goToEvaluation {
    EvaluationChooseView *view = [[EvaluationChooseView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (1) {
        button.hidden = YES;
    }
}
- (void)tagerLoginBtn {
    loginBtn.hidden = YES;
    lastSmallLabel.hidden = YES;
    button.hidden = NO;
    NSLog(@"确认到达目的地");
}
- (void)pushInfo:(UIButton *)button {
    NSLog(@"点击订单详情");
    DetailInfoController *VC= [[DetailInfoController alloc] init];
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
