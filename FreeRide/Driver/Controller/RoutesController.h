//
//  RoutesController.h
//  FreeRide
//
//  Created by  on 2017/12/11.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BlockDic)(NSDictionary *backInfo);

@interface RoutesController : UIViewController

@property (nonatomic, copy) NSString *chooseInfoStr;
@property (nonatomic, strong) BlockDic block;

@end
