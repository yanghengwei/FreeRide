//
//  MainViewController.h
//  FreeRide
//
//  Created by pc on 2017/11/6.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "FRBaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface MainViewController : FRBaseViewController

@property (nonatomic,retain) MAMapView *mapView;

@property (nonatomic,retain) MAUserLocation *currentLocation;
@property (nonatomic,retain) AMapPOI *currentPOI;

@property (nonatomic,retain) MAPointAnnotation *destinationPoint;//目标点


@end
