//
//  MapView.m
//  FreeRide
//
//  Created by pc on 2017/11/24.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "MapView.h"
//#import "SomeSupport.h"
#import "Header.h"

@implementation MapView{
    
    NSMutableDictionary*_addressLocatons;//当前位置信息
    NSString*address;//详细地址
    CLLocationDegrees latitude;//纬度
    CLLocationDegrees longitude;//经度
    MAPointAnnotation *annotatio;
    BOOL isLoad;//是否搜索附近的位置
    
}
-(id)initWithFrame:(CGRect)rect addres:(NSString*)addres{
    
    self = [super initWithFrame:rect];
    if (self)
    {
        if ([CLLocationManager locationServicesEnabled] &&
            ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)) {
            //定位功能可用，开始定位
            [self MapView];
            if (addres) {
                address=addres;
                [self geocoder];
                [self geocoderData];
            }else{
                isLoad=YES;
                [self initCompleteBlock];
                [self configLocationManager];
                [self reGeocodeAction];
            }
            
        }
        else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
            [self alertAction];
        }
    }
    return self;
    
}
//懒加载
-(void)MapView{
    
    //APIKEY赋值
    [AMapServices sharedServices].apiKey = APIKEY;
    _mapView = [[MAMapView alloc]init];
    _mapView.showsUserLocation=YES; //YES 为打开定位，NO为关闭定位
    _mapView.frame=self.bounds;
    _mapView.delegate=self;
    _mapView.showsCompass= YES;//不显示指南针
    _mapView.showsScale= YES;//不显示比例尺
    _mapView.userTrackingMode = MAUserTrackingModeNone; //跟踪用户位置和方向
    _mapView.centerCoordinate = _mapView.userLocation.location.coordinate;
    [self addSubview:_mapView];
    
}
#pragma mark-懒加载
-(CLGeocoder *)geocoder
{
    if (_geocoder==nil) { _geocoder=[[CLGeocoder alloc]init];}
    return _geocoder;
}

#pragma mark - 定位的方法
- (void)configLocationManager
{
    _locationManager = [[AMapLocationManager alloc] init];
    [_locationManager setDelegate:self];
    //定位精度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //指定定位是否会被系统自动暂停。默认为YES。
    //    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    //是否允许后台定位。默认为NO
    [_locationManager setAllowsBackgroundLocationUpdates:NO];
    //单次定位超时时间
    [_locationManager setLocationTimeout:5.0f];
    //单次定位逆地理超时时间
    [_locationManager setReGeocodeTimeout:6.0f];
}

#pragma mark - 定位回调
- (void)reGeocodeAction
{
    [_mapView removeAnnotations:_mapView.annotations];
    [_locationManager requestLocationWithReGeocode:YES completionBlock:_completionBlock];
}
- (void)initCompleteBlock
{
    
    _completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
    {
        if (error){
            if (error.code == AMapLocationErrorLocateFailed)
            {[self alertAction];return;}
        }
        if (location)
        {
            annotatio = [[MAPointAnnotation alloc] init];
            [annotatio setCoordinate:location.coordinate];
            [annotatio setTitle:[NSString stringWithFormat:@"%@", regeocode.formattedAddress]];
            
            [annotatio setSubtitle:[NSString stringWithFormat:@"距离当前位置:%.2fm", location.horizontalAccuracy]];
            
            [self getlocationcCoordinate];
            if (regeocode)
            {     //获得当前位置信息
                _addressLocatons=[[NSMutableDictionary alloc]init];
                if (_addressLocatons.count==0) {
                    _addressLocatons=   [[NSMutableDictionary alloc]init];
                    [_addressLocatons setObject:[NSString stringWithFormat:@"%@", regeocode.formattedAddress] forKey:@"addressName"];
                    [_addressLocatons setObject:[NSString stringWithFormat:@"距离当前位置:%.2fm", location.horizontalAccuracy] forKey:@"address"];
                    [_addressLocatons setObject:[NSString stringWithFormat:@"%.2f", location.horizontalAccuracy] forKey:@"distance"];
                    [_addressLocatons setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"latitude"];
                    [_addressLocatons setObject:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"longitude"];
                }
                
            }
            /*添加打头阵  设置地图中心位置*/
            [self addAnnotationToMapView:annotatio];
        }
    };
}

- (MAPointAnnotation*)getlocationcCoordinate{
    return annotatio;
}
#pragma mark - MAMapView Delegate
#pragma mark  添加大头针
- (void)addAnnotationToMapView:(id<MAAnnotation>)annotation
{
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView addAnnotation:annotation];
    //    [mapView selectAnnotation:annotation animated:YES];
    [_mapView setCenterCoordinate:annotation.coordinate];
    [_mapView setZoomLevel:15.1 animated:YES];
    [_mapView setCenterCoordinate:annotation.coordinate animated:YES];
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        annotationView.canShowCallout   = YES;
        annotationView.animatesDrop     = YES;
        annotationView.draggable        = YES;
        annotationView.pinColor         = MAPinAnnotationColorPurple;
        if (isLoad == YES) {
            [self myLocationAround];
        }
        return annotationView;
    }
    return nil;
}

#pragma mark  搜索附近的位置供自定义选择
//搜索附近的地址
-(void)myLocationAround{
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
    
    request.location = [AMapGeoPoint locationWithLatitude:_mapView.centerCoordinate.latitude   longitude:_mapView.centerCoordinate.longitude];
    request.radius = 500;
    request.types = @"汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    request.sortrule = 0;
    request.requireExtension = YES;
    
    //发起周边搜索
    [_search AMapPOIAroundSearch: request];
    
}
//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0){ return;}
    _fujinArr=[[NSMutableArray alloc]init];
    
    if (_addressLocatons) {
        [_fujinArr addObject:_addressLocatons];
    }
    
    for (AMapPOI *p in response.pois) {
        NSDictionary *d1 = @{@"addressName":p.name,@"addressLocation":p.location,@"address":p.address,@"distance":[NSString stringWithFormat:@"%d",(int)p.distance]};
        if (_addressLocatons&&[p.name isEqualToString:_addressLocatons[@"addressName"]]) {
            NSLog(@"重复");
        }else{
            [_fujinArr addObject:d1];
        }
    }
    self.getadAata(_fujinArr);
}

//让地图回到当前定位位置
-(void)signAgainAction{
    _mapView.centerCoordinate = _mapView.userLocation.location.coordinate;
}
-(void)setLocation:(NSDictionary*)addressLocaton{
    NSString * name=addressLocaton[@"addressName"];
    if (![name isEqualToString:@"(null)"]) {
        if (addressLocaton.count==0) {
//            [SomeSupport createUIAlertWithMessege:@"定位失败,请到系统设置中查看是否开启定位服务!" andTag:1];
        }else{
            [_mapView removeAnnotations:_mapView.annotations];
            MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
            [annotation setTitle:[NSString stringWithFormat:@"%@", VerifyValue(addressLocaton[@"addressName"])]];
            [annotation setSubtitle:[NSString stringWithFormat:@"%@", VerifyValue(addressLocaton[@"address"])]];
            latitude=[_addressLocatons[@"latitude"]floatValue];
            longitude=[_addressLocatons[@"longitude"]floatValue];
            /*设置地图经纬度信息*/
            CLLocationCoordinate2D coordinate =CLLocationCoordinate2DMake(latitude,longitude);
            annotation.coordinate=coordinate;
            _mapView.centerCoordinate = coordinate;
            [self addAnnotationToMapView:annotation];
        }
    }else{
        //定位功能
        [self initCompleteBlock];
        [self configLocationManager];
        [self reGeocodeAction];
    }
}

-(void)geocoderData{
    [_geocoder geocodeAddressString:address completionHandler:^(NSArray* placemarks,NSError* error){
        //如果有错误信息，或者是数组中获取的地名元素数量为0，那么说明没有找到
        if (error || placemarks.count==0) {NSLog(@"你输入的地址没找到，可能在月球上");
        }else//  编码成功，找到了具体的位置信息
        {
            //打印查看找到的所有的位置信息
            /*
             name:名称 locality:城市 country:国家 postalCode:邮政编码
             */
            //            for (CLPlacemark *placemark in placemarks) {
            //                 NSLog(@"name=%@ locality=%@ country=%@ postalCode=%@",placemark.name,placemark.locality,placemark.country,placemark.postalCode);
            //            }
            //取出获取的地理信息数组中的第一个显示在界面上
            CLPlacemark *firstPlacemark=[placemarks firstObject];
            //详细地址名称
            // self.detailAddressLabel.text=firstPlacemark.name;
            
            NSString * coordinate= [NSString stringWithFormat:@"%@",firstPlacemark.location];
            NSArray* arr=  [coordinate componentsSeparatedByString:@">"];
            NSString* str1=  [[arr objectAtIndex:0] stringByReplacingOccurrencesOfString:@"<+" withString:@""];
            NSArray* arr1=  [str1 componentsSeparatedByString:@","];
            //纬度
            latitude=[[arr1 objectAtIndex:0]doubleValue];
            //经度
            longitude=[[arr1 objectAtIndex:1]doubleValue];
            _addressLocatons=[[NSMutableDictionary alloc]init];
            /*电影院定位*/
//            latitude=19.9436750000;
//            longitude=110.1287040000;
            if (_addressLocatons.count==0) {
                
                [_addressLocatons setObject:[NSString stringWithFormat:@"%@",firstPlacemark.name] forKey:@"addressName"];
                [_addressLocatons setObject:[NSString stringWithFormat:@"%@",address] forKey:@"address"];
                [_addressLocatons setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
                [_addressLocatons setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
            }
            _fujinArr=[[NSMutableArray alloc]init];
            [_fujinArr addObject:_addressLocatons];
            
            annotatio = [[MAPointAnnotation alloc] init];
            /*设置地图经纬度信息*/
            CLLocationCoordinate2D CLLocationCoordi=CLLocationCoordinate2DMake(latitude, longitude);
            [annotatio setCoordinate:CLLocationCoordi];
            _mapView.centerCoordinate = CLLocationCoordi;
            [self addAnnotationToMapView:annotatio];
//            self.getadAata(_fujinArr);
            
        }
    }];
}
-(void)alertAction{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"您屏蔽了定位服务权限,请去系统设置->隐私->定位服务->对本APP授权" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = 1;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    self.AlertViewAction();
}
@end
