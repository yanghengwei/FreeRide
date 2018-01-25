//
//  PromptViewController.m
//  FreeRide
//
//  Created by  on 2017/11/10.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "PromptViewController.h"
#import "Header.h"
#import "NaviView.h"
#import "MainTableController.h"
#import "OrderInfoController.h"

@interface PromptViewController ()

@end

@implementation PromptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NaviView *naviView = [[NaviView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, YMAKENEW(50)) andName:@"提示" andTyep:@"normal"];
    naviView.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:naviView];
    [self createUI];

}
- (void)createUI {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(172), YMAKENEW(100), self.view.frame.size.width-2*XMAKENEW(172), XMAKENEW(31))];
    imageView.image = [UIImage imageNamed:@"complete"];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), SCREEN_WIDTH, YMAKENEW(40))];
    if (_promptStr) {
        label.text = _promptStr;
    } else {
        label.text = @"设置成功！";
    }
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = COLOR_TEXT_DARK;
    [self.view addSubview:label];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)-XMAKENEW(20), SCREEN_WIDTH, YMAKENEW(40))];
    if (_detailPromptStr) {
        detailLabel.text = _detailPromptStr;
    } else {
        detailLabel.text = @"";
    }
    detailLabel.font = [UIFont systemFontOfSize:FONT12];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.textColor = COLOR_TEXT_NORMAL;
    [self.view addSubview:detailLabel];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(80), CGRectGetMaxY(label.frame)+YMAKENEW(25), self.view.frame.size.width-2*XMAKENEW(80), YMAKENEW(40))];
    [btn setTitle:@"我知道了" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(tagerLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = COLOR_ORANGE;
    btn.layer.cornerRadius = 3.0;//2.0是圆角的弧度，根据需求自己更改
    btn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    btn.layer.borderWidth = 0.5f;//设置边框颜色
    [self.view addSubview:btn];
    
    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame)+YMAKENEW(50), self.view.frame.size.width, self.view.frame.size.height)];
    backLabel.backgroundColor = COLOR_background;
    [self.view addSubview:backLabel];
}
- (void)tagerLoginBtn {
    if ([self.titleName isEqualToString:@"设置登录密码"]) {
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        window.rootViewController  = [[UINavigationController alloc] initWithRootViewController:[[MainTableController alloc] init]];
    } else if ([self.titleName isEqualToString:@"paySuccess"]){
        OrderInfoController *vc = [[OrderInfoController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        UIViewController *viewCtl = self.navigationController.viewControllers[2];
        [self.navigationController popToViewController:viewCtl animated:YES];
    }
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
