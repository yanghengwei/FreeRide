//
//  PassengerController.h
//  FreeRide
//
//  Created by  on 2017/12/4.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^PickDicBlock)(NSDictionary *backInfo);

@interface PassengerController : UIViewController

@property (nonatomic, copy) NSDictionary *selectInfo;
@property (nonatomic, copy) PickDicBlock pickBlock;

@end
