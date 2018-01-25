//
//  NetworkTool.m
//  XHH_networkTool
//
//  Created by xiaohuihui on 2016/11/26.
//  Copyright © 2016年 30-陈辉华. All rights reserved.
//

#import "NetworkTool.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UserDefaults.h"

@implementation NetworkTool

+ (instancetype)sharedTool {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithBaseURL:nil];
    });
    
    return instance;
}

- (void)requestWithURLString: (NSString *)URLString
                  parameters: (NSDictionary *)parameters
                      method: (NSString *)method
                    callBack: (void (^)(id))callBack {
    if ([[parameters objectForKey:@"key"] isEqualToString:@""]) {
        [self presentLoginView];
        return;
    }
    if ([method isEqualToString:@"GET"]) {
        [self GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            callBack(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
    
    if ([method isEqualToString:@"POST"]) {
        [self POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([[responseObject objectForKey:@"status"] isEqualToString:@"10"]) {
                [self presentLoginView];
                return;
            }
            callBack(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
    }
}
- (void)presentLoginView {
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%f", (double)[datenow timeIntervalSince1970]];
    if ([UserDefaults getValueForKey:@"relog"] && [[UserDefaults getValueForKey:@"relog"] doubleValue] - (double)[datenow timeIntervalSince1970] > -10) {
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"登录失效，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    alert.delegate = self;
    [alert show];
    [UserDefaults saveValue:timeSp forKey:@"relog"];
}
#pragma mark -- alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIWindow *window = ((AppDelegate*)([UIApplication sharedApplication].delegate)).window;
    LoginViewController *vc = [[LoginViewController alloc] init];
    vc.isBack = YES;
    [window.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:vc]  animated:YES completion:nil];
}
@end
