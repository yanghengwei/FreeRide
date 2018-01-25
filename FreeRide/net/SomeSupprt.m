//
//  SomeSupprt.m
//  FreeRide
//
//  Created by  on 2017/12/25.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "SomeSupprt.h"

@implementation SomeSupprt

#pragma ===========
//alert提示框
+ (UIAlertView *)createUIAlertWithMessege:(NSString *)messege andTag:(NSInteger)teger
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:messege delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
    alert.tag = teger;
    
    [alert show];
    
    alert = nil;
    return alert;
}

//alert提示框  0.5秒自动消失
+ (UIAlertView *)createUIAlertWithMessage:(NSString *)message andDisappearTime:(NSInteger)time
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time*1.5 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
    
    alert = nil;
    return alert;
}



@end
