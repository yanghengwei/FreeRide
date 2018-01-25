//
//  SomeSupprt.h
//  FreeRide
//
//  Created by  on 2017/12/25.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SomeSupprt : NSObject

#pragma ======================
/***alert 只有确定提示框***/
+ (UIAlertView *)createUIAlertWithMessege:(NSString *)messege andTag:(NSInteger)teger; //
/***alert 自动消失的***/
+ (UIAlertView *)createUIAlertWithMessage:(NSString *)message andDisappearTime:(NSInteger)time; //
/***alert 提示前往登录页 ***/
+ (UIAlertView *)gotoLoginPageAlertViewWithTarget:(id)target andTag:(NSInteger)teger;

@end
