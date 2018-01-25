//
//  MainViewController.m
//  FreeRide
//
//  Created by pc on 2017/11/6.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "MainViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface MainViewController () <MAMapViewDelegate,AMapSearchDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate,UISearchResultsUpdating>

@property (nonatomic,retain) AMapSearchAPI *search;

@property (nonatomic,retain) NSString *currentCity;

@property (nonatomic,retain) UILongPressGestureRecognizer *longPressGesture;//长按手势

@property (nonatomic,retain) NSArray *pathPolylines;

@end

@implementation MainViewController

- (MAMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        _mapView.delegate = self;
        _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
        
        [_mapView setUserTrackingMode: MAUserTrackingModeFollow animated:NO]; //地图跟着位置移动
        
        //自定义定位经度圈样式
        _mapView.customizeUserLocationAccuracyCircleRepresentation = NO;
        
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        
        //后台定位
        _mapView.pausesLocationUpdatesAutomatically = NO;
        
        _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
        
    }
    return _mapView;
}

#pragma  mark -- viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //配置用户Key
    [AMapServices sharedServices].apiKey = @"76bb9bc3718375ad03acba7c333694c4";
    
    
    [self.view insertSubview:self.mapView atIndex:0];
    
    
    
//    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    _searchController.searchResultsUpdater = self;
//    _searchController.searchBar.delegate = self;
//    //    _searchController.delegate = self;
//    _searchController.dimsBackgroundDuringPresentation = NO;
//    _searchController.hidesNavigationBarDuringPresentation = NO;
//    _searchController.searchBar.frame = CGRectMake(kWidth/2 - 100, 20, 200, 44.0);
//
//
//
//    self.navigationItem.titleView = _searchController.searchBar;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftAction)];
//
    
    
//    [self addGesture];
}




#pragma mark -- 大头针和遮盖

//自定义的经纬度和区域
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    /* 自定义定位精度对应的MACircleView. */
    if (overlay == mapView.userLocationAccuracyCircle)
    {
        MACircleRenderer *accuracyCircleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        accuracyCircleRenderer.lineWidth    = 2.f;
        accuracyCircleRenderer.strokeColor  = [UIColor lightGrayColor];
        accuracyCircleRenderer.fillColor    = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
        
        return accuracyCircleRenderer;
    }
    
    //画路线
    //    if ([overlay isKindOfClass:[MAPolygon class]])
    //    {
    //
    //        MAPolygonRenderer *polygonView = [[MAPolygonRenderer alloc] initWithPolygon:overlay];
    //
    //        polygonView.lineWidth = 5.f;
    //        polygonView.strokeColor = [UIColor colorWithRed:0.986 green:0.185 blue:0.019 alpha:1.000];
    //        polygonView.fillColor = [UIColor colorWithRed:0.940 green:0.771 blue:0.143 alpha:0.800];
    //        polygonView.lineJoinType = kMALineJoinMiter;//连接类型
    //
    //        return polygonView;
    //    }
    //画路线
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        
        MAPolylineRenderer *polygonView = [[MAPolylineRenderer alloc] initWithPolyline:overlay];
        
        polygonView.lineWidth = 8.f;
        polygonView.strokeColor = [UIColor colorWithRed:0.015 green:0.658 blue:0.986 alpha:1.000];
        polygonView.fillColor = [UIColor colorWithRed:0.940 green:0.771 blue:0.143 alpha:0.800];
        polygonView.lineJoinType = kMALineJoinRound;//连接类型
        
        return polygonView;
    }
    return nil;
    
}

//添加大头针
- (void)addAnnotation
{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = _currentLocation.coordinate;
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(_currentPOI.location.latitude, _currentPOI.location.longitude);
    pointAnnotation.title = _currentPOI.name;
    pointAnnotation.subtitle = @"阜通东大街6号";
    //    pointAnnotation.subtitle = _currentPOI.address;
    
    
    [_mapView addAnnotation:pointAnnotation];
    [_mapView selectAnnotation:pointAnnotation animated:YES];
}




//大头针的回调
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    
    /* 自定义userLocation对应的annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                          reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"userPosition"];
        
        return annotationView;
    }
    
    //大头针
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 功能

//地图样式切换
- (IBAction)SatelliteMapAction:(id)sender {
    _mapView.mapType = MAMapTypeSatellite;
}
- (IBAction)standardMapAction:(id)sender {
    _mapView.mapType = MAMapTypeStandard;
}
- (IBAction)nightMapAction:(id)sender {
    _mapView.mapType = MAMapTypeStandardNight;
}
//实时交通
- (IBAction)currentTrafficAction:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        _mapView.showTraffic= NO;
    }
    else
    {
        sender.selected = NO;
        _mapView.showTraffic= YES;
    }
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
