//
//  MapView.h
//  FreeRide
//
//  Created by pc on 2017/11/24.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface MapView : UIView<AMapLocationManagerDelegate,AMapLocationManagerDelegate,MAMapViewDelegate,AMapSearchDelegate,UIAlertViewDelegate>

/*附近的位置信息*/
@property(nonatomic,strong)NSMutableArray* fujinArr;

/**
 *  开始进入刷新状态就会调用
 */
@property (nonatomic, copy) void (^AlertViewAction)(void);


/**
 *  AMapLocationManager类
 *
 *  初始化之前请设置 AMapLocationServices 中的APIKey，否则将无法正常使用服务.
 */
@property(nonatomic,strong)AMapLocationManager *locationManager;

/**
 *  AMapLocatingCompletionBlock 单次定位返回Block
 *
 *  @param location 定位信息
 *  @param regeocode 逆地理信息
 *  @param error 错误信息，参考 AMapLocationErrorCode
 */
@property (nonatomic, strong) AMapLocatingCompletionBlock completionBlock;

/**
 *地理反编码初始类
 */
@property (nonatomic, strong) CLGeocoder* geocoder;

/**
 *地图
 */
@property(nonatomic,strong)MAMapView *mapView;

/**
 *搜索类
 */
@property (nonatomic, strong) AMapSearchAPI *search;

/**
 *返回包括附近的位置信息  第一条是当前位置信息
 */
@property(nonatomic,copy)void(^getadAata)(NSArray*);

/**
 *检测定位是否打开  addres是具体位置信息  当为nil时定位当前位置
 */
-(id)initWithFrame:(CGRect)rect addres:(NSString*)addres;

/**
 * 得到大头针
 */
- (MAPointAnnotation*)getlocationcCoordinate;
/**
 * 传入字典添加大头
 */
-(void)setLocation:(NSDictionary*)addressLocaton;
@end

