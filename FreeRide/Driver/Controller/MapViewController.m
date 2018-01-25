//
//  MapViewController.m
//  FreeRide
//
//  Created by pc on 2017/11/24.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "MapViewController.h"
#import "PersonalNaviView.h"
#import "MapView.h"
#import "ComAddressController.h"

@interface MapViewController ()<MAMapViewDelegate>
{
    MapView *_mapview;
}
@end

@implementation MapViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"意见反馈" andRightTitle:@""];
    [navi.rightBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self returnAction];
    };
    [self.view addSubview:navi];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    _mapview = [[MapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) addres:@"37.8180648538,112.5320255756"];
//    _mapview.delegate = self;
    [self.view addSubview:_mapview];
    
    [self setBtnToMap];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(returnAction)];
}
- (void)setBtnToMap {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(15), 68+XMAKENEW(15), XMAKENEW(60), XMAKENEW(60))];
    btn.titleLabel.numberOfLines = 0;
    [btn setTitle:@"常用\n地址" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(tagerLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = COLOR_ORANGE;
    btn.layer.cornerRadius = 30.0;//2.0是圆角的弧度，根据需求自己更改
    btn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    btn.layer.borderWidth = 0.5f;//设置边框颜色
    [self.view addSubview:btn];
}
- (void)tagerLoginBtn {
    ComAddressController *vc = [[ComAddressController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _mapview.frame = CGRectMake(0, 68, self.view.bounds.size.width, self.view.bounds.size.height-68);
   
}

#pragma mark - action handling
- (void)returnAction
{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

@end
