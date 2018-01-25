//
//  PilotViewController.m
//  FreeRide
//
//  Created by yang on 2018/1/17.
//  Copyright © 2018年 pc. All rights reserved.
//

#import "PilotViewController.h"
#import "PersonalNaviView.h"
#import "Header.h"

@interface PilotViewController () <AMapNaviDriveViewDelegate,AMapNaviDriveManagerDelegate>
@property (strong ,nonatomic)AMapNaviDriveView *driveView;       //导航界面
@property (strong ,nonatomic)AMapNaviDriveManager *driveManager; //导航管理者

@end

@implementation PilotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"导航" andRightTitle:@""];
    [navi.rightBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self initDriveView];
    [self initDriveManager];
}
- (void)pushNextView:(NSString *)backinfo {
    if ([backinfo isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)initDriveView
{
    if (!self.driveView){
        //初始化导航界面
        self.driveView = [[AMapNaviDriveView alloc] initWithFrame:CGRectMake(0,64,SCREEN_WIDTH,SCREEN_HEGHT-64)];
        self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.driveView.showTrafficButton = YES;
        [self.driveView setDelegate:self];
        [self.view addSubview:self.driveView];
    }
}

- (void)initDriveManager
{
    if (!self.driveManager){
        
        //初始化导航管理者
        self.driveManager = [[AMapNaviDriveManager alloc] init];
        [self.driveManager setDelegate:self];
        
//        LatLonPoint(37.8180648538, 112.5320255756);//起点，万国城moma
//        private LatLonPoint mEndPoint = new LatLonPoint(37.8599805998, 112.5872039795);//太原站
        //设置驾车出行路线规划
        AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:37.8180648538 longitude:112.5320255756];//昌平区
        AMapNaviPoint *endPoint   = [AMapNaviPoint locationWithLatitude:37.8199805998 longitude:112.5372039795];//丰台区
        [self.driveManager calculateDriveRouteWithStartPoints:@[startPoint]
                                                    endPoints:@[endPoint]
                                                    wayPoints:nil
                                              drivingStrategy:17];
        //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
        [self.driveManager addDataRepresentative:self.driveView];
    }
}

#pragma mark -  AMapNaviDriveViewDelegate
/**
 *  导航界面关闭按钮点击时的回调函数
 */
- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView{
    NSLog(@"%s",__func__);
}

/**
 *  导航界面更多按钮点击时的回调函数
 */
- (void)driveViewMoreButtonClicked:(AMapNaviDriveView *)driveView{
    NSLog(@"%s",__func__);
}

/**
 *  导航界面转向指示View点击时的回调函数
 */
- (void)driveViewTrunIndicatorViewTapped:(AMapNaviDriveView *)driveView{
    NSLog(@"%s",__func__);
}

/**
 *  导航界面显示模式改变后的回调函数
 *
 *  @param showMode 显示模式
 */
- (void)driveView:(AMapNaviDriveView *)driveView didChangeShowMode:(AMapNaviDriveViewShowMode)showMode{
    NSLog(@"%s",__func__);
}

/**
 *  获取导航界面上路线显示样式的回调函数
 *
 *  @param naviRoute 当前界面的路线信息
 *  @return AMapNaviRoutePolylineOption 路线显示样式
 */
- (AMapNaviRoutePolylineOption *)driveView:(AMapNaviDriveView *)driveView needUpdatePolylineOptionForRoute:(AMapNaviRoute *)naviRoute{
    return nil;
}

#pragma mark - AMapNaviDriveManagerDelegate
//驾车路径规划成功后的回调函数
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
{
    NSLog(@"onCalculateRouteSuccess");
    
    //算路成功后开始GPS导航
    [self.driveManager startGPSNavi];
    
    //算路成功后进行模拟导航
//    [self.driveManager startEmulatorNavi];
//    [self.driveManager setEmulatorNaviSpeed:80];
}

@end
