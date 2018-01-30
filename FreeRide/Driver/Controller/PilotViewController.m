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

#import <MAMapKit/MAMapKit.h>
#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>

@interface PilotViewController () <MAMapViewDelegate, AMapLocationManagerDelegate, AMapNaviDriveManagerDelegate, AMapNaviDriveViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) AMapNaviDriveManager *driveManager;
@property (nonatomic, strong) AMapNaviDriveView *driveView;
@property (nonatomic, strong) AMapNaviPoint *startPoint;
@property (nonatomic, strong) AMapNaviPoint *endPoint;

@end

@implementation PilotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self.view addSubview:self.mapView];
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];    // 带逆地理信息的一次定位（返回坐标和地址信息）
    self.locationManager.locationTimeout =2;    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;    //   逆地理请求超时时间，最低2s，此处设置为2s
    
    self.btn = [[UIButton alloc] init];
    self.btn.frame = CGRectMake(20, 50, 90, 40);
    [self.btn setTitle:@"导航" forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(beginRouting) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    
    //    [self showMap];
    //    [self controlEx];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //    [self clipOneAnnnotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMap {
    self.mapView.showTraffic = NO;
    self.mapView.mapType = MAMapTypeStandard;
    
}

- (void)controlEx {
    self.mapView.logoCenter = CGPointMake(50, 450);
    
    self.mapView.showsCompass = NO;
    self.mapView.compassOrigin = CGPointMake(self.mapView.compassOrigin.x, 22);
    
    self.mapView.showsScale = NO;
    self.mapView.scaleOrigin = CGPointMake(self.mapView.compassOrigin.x, 22);
}

- (void)clipOneAnnnotation {
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);
    pointAnnotation.title = @"方恒国际";
    pointAnnotation.subtitle = @"阜通东大街6号";
    
    [self.mapView addAnnotation:pointAnnotation];
}

- (void)beginRouting {
    self.startPoint = [AMapNaviPoint locationWithLatitude:39.993135 longitude:116.474175];
    self.endPoint   = [AMapNaviPoint locationWithLatitude:39.908791 longitude:116.321257];
    
    self.driveManager = [[AMapNaviDriveManager alloc] init];
    self.driveManager.delegate = self;
    
    self.driveView = [[AMapNaviDriveView alloc] init];
    self.driveView.frame = self.view.frame;
    self.driveView.delegate = self;
    [self.view addSubview:self.driveView];
    
    [self.driveManager addDataRepresentative:self.driveView];
    
    [self.driveManager calculateDriveRouteWithStartPoints:@[self.startPoint] endPoints:@[self.endPoint] wayPoints:nil drivingStrategy:AMapNaviDrivingStrategyDefault];
}


#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation {
    
}

#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    
}

#pragma mark - AMapNaviDriveManagerDelegate
- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager {
    [driveManager startEmulatorNavi];//开始模拟导航
}

#pragma mark - AMapNaviDriveViewDelegate

@end



//@interface PilotViewController () <AMapNaviDriveViewDelegate,AMapNaviDriveManagerDelegate>
//@property (strong ,nonatomic)AMapNaviDriveView *driveView;       //导航界面
//@property (strong ,nonatomic)AMapNaviDriveManager *driveManager; //导航管理者
//
//@end
//
//@implementation PilotViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"导航" andRightTitle:@""];
//    [navi.rightBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
//    navi.block = ^(NSString *backInfo){
//        NSLog(@"%@",backInfo);
//        [self pushNextView:backInfo];
//    };
//    [self.view addSubview:navi];
//    [self initDriveView];
//    [self initDriveManager];
//}
//- (void)pushNextView:(NSString *)backinfo {
//    if ([backinfo isEqualToString:@"back"]) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}
//- (void)initDriveView
//{
//    if (!self.driveView){
//        //初始化导航界面
//        self.driveView = [[AMapNaviDriveView alloc] initWithFrame:CGRectMake(0,64,SCREEN_WIDTH,SCREEN_HEGHT-64)];
//        self.driveView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//        self.driveView.showTrafficButton = YES;
//        [self.driveView setDelegate:self];
//        [self.view addSubview:self.driveView];
//    }
//}
//
//- (void)initDriveManager
//{
//    if (!self.driveManager){
//
//        //初始化导航管理者
//        self.driveManager = [[AMapNaviDriveManager alloc] init];
//        [self.driveManager setDelegate:self];
//
////        LatLonPoint(37.8180648538, 112.5320255756);//起点，万国城moma
////        private LatLonPoint mEndPoint = new LatLonPoint(37.8599805998, 112.5872039795);//太原站
//        //设置驾车出行路线规划
//        AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:37.8180648538 longitude:112.5320255756];//昌平区
//        AMapNaviPoint *endPoint   = [AMapNaviPoint locationWithLatitude:37.8199805998 longitude:112.5372039795];//丰台区
//        [self.driveManager calculateDriveRouteWithStartPoints:@[startPoint]
//                                                    endPoints:@[endPoint]
//                                                    wayPoints:nil
//                                              drivingStrategy:17];
//        //将driveView添加为导航数据的Representative，使其可以接收到导航诱导数据
//        [self.driveManager addDataRepresentative:self.driveView];
//    }
//}
//
//#pragma mark -  AMapNaviDriveViewDelegate
///**
// *  导航界面关闭按钮点击时的回调函数
// */
//- (void)driveViewCloseButtonClicked:(AMapNaviDriveView *)driveView{
//    NSLog(@"%s",__func__);
//}
//
///**
// *  导航界面更多按钮点击时的回调函数
// */
//- (void)driveViewMoreButtonClicked:(AMapNaviDriveView *)driveView{
//    NSLog(@"%s",__func__);
//}
//
///**
// *  导航界面转向指示View点击时的回调函数
// */
//- (void)driveViewTrunIndicatorViewTapped:(AMapNaviDriveView *)driveView{
//    NSLog(@"%s",__func__);
//}
//
///**
// *  导航界面显示模式改变后的回调函数
// *
// *  @param showMode 显示模式
// */
//- (void)driveView:(AMapNaviDriveView *)driveView didChangeShowMode:(AMapNaviDriveViewShowMode)showMode{
//    NSLog(@"%s",__func__);
//}
//
///**
// *  获取导航界面上路线显示样式的回调函数
// *
// *  @param naviRoute 当前界面的路线信息
// *  @return AMapNaviRoutePolylineOption 路线显示样式
// */
//- (AMapNaviRoutePolylineOption *)driveView:(AMapNaviDriveView *)driveView needUpdatePolylineOptionForRoute:(AMapNaviRoute *)naviRoute{
//    return nil;
//}
//
//#pragma mark - AMapNaviDriveManagerDelegate
////驾车路径规划成功后的回调函数
//- (void)driveManagerOnCalculateRouteSuccess:(AMapNaviDriveManager *)driveManager
//{
//    NSLog(@"onCalculateRouteSuccess");
//
//    //算路成功后开始GPS导航
//    [self.driveManager startGPSNavi];
//
//    //算路成功后进行模拟导航
////    [self.driveManager startEmulatorNavi];
////    [self.driveManager setEmulatorNaviSpeed:80];
//}

//@end

