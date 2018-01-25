//
//  CommentsController.h
//  FreeRide
//
//  Created by  on 2017/11/30.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PickBlock)(NSString *backInfo);

@interface CommentsController : UIViewController

@property (nonatomic, copy) NSString *selectInfo;
@property (nonatomic, copy) PickBlock pickBlock;

@end
