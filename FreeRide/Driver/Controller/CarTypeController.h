//
//  CarTypeController.h
//  FreeRide
//
//  Created by mac on 2017/12/29.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Block)(NSDictionary *backInfo);

@interface CarTypeController : UIViewController
@property (nonatomic, copy) Block block;
@end

