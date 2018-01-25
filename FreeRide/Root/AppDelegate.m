//
//  AppDelegate.m
//  FreeRide
//
//  Created by pc on 2017/10/30.
//  Copyright © 2017年 JNR All rights reserved.
//
#import "UncaughtExceptionHandler.h"
#import "UserDefaults.h"
#import "GuideController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "APIKye.h"
#import "PayInfoViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "OrderInfoController.h"
#import "LoginViewController.h"
#import "MainTableController.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate () <JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (void)configureAPIKey
{
    
//    [AMapLocationServices sharedServices].apiKey = APIKEY;
    [AMapServices sharedServices].apiKey = APIKEY;
    
    _MAMapV = [[MAMapView alloc]init];
    _MAMapV.showsUserLocation=YES; //YES 为打开定位，NO为关闭定位
    
}
static NSString *JPushAppKey = @"6abc87b33b23d35b9c3b86e0";
static NSString *JPushChannel = @"Publish channel";
// static BOOL JPushIsProduction = NO;
#ifdef DEBUG
// 开发 极光FALSE为开发环境
static BOOL const JPushIsProduction = FALSE;
#else
// 生产 极光TRUE为生产环境
static BOOL const JPushIsProduction = TRUE;
#endif
//[objc] view plain copy 在CODE上查看代码片派生到我的代码片
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    InstallUncaughtExceptionHandler();// 拦截崩溃.
    [self configureAPIKey];
    
//    self.viewController = [[UINavigationController alloc] initWithRootViewController:[[MainTableController alloc] init]];
    
//    self.window.rootViewController  = self.viewController;
    [self createRootController];
    self.window.backgroundColor     = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //高德地图key
    [AMapServices sharedServices].apiKey = @"a1c2b82d3e3abc509ae942ed8e5cad70";
//    [AMapServices sharedServices].apiKey = @"a1c2b82d3e3abc509ae942ed8e5cad70";
    
    
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
//        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
//        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
//        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
//    }
//    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        //可以添加自定义categories
//        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                          UIUserNotificationTypeSound |
//                                                          UIUserNotificationTypeAlert)
//                                              categories:nil];
//    }
//    else {
//        //categories 必须为nil
//        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                          UIRemoteNotificationTypeSound |
//                                                          UIRemoteNotificationTypeAlert)
//                                              categories:nil];
//    }
//    [JPUSHService setupWithOption:launchOptions appKey:appKey
//                          channel:channel
//                 apsForProduction:isProduction
//            advertisingIdentifier:nil];  // 这里是没有advertisingIdentifier的情况，有的话，大家在自行添加
    //注册远端消息通知获取device token
    [application registerForRemoteNotifications];
//    [NSThread sleepForTimeInterval:1.0];
    return YES;
}
#pragma mark -- 跳转根页面
- (void)createRootController
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        //第一次启动,进入引导页
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [UserDefaults saveValue:@"yes" forKey:@"isFirstLogin"]; //为了给后面新手第一次进入 ,介绍流程页
        
        GuideController *guide = [[GuideController alloc] init];
        
        //GovermentDController *guide = [[GovermentDController alloc]init];
        [UserDefaults saveValue:@"" forKey:@"key"];
        [UserDefaults saveValue:@"" forKey:@"phone"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:guide];
        self.window.rootViewController = nav;
        
        
    }else{
        //不是第一次登录
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[MainTableController alloc] init]];
        //        self.window.rootViewController = [[GovermentDController alloc] init];
    }
}
// 获取deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"2-1 didReceiveRemoteNotification remoteNotification = %@", userInfo);
    // apn 内容获取：
//    [JPUSHService handleRemoteNotification:dict];
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"2-2 didReceiveRemoteNotification remoteNotification = %@", userInfo);
    if ([userInfo isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = userInfo[@"aps"];
        NSString *content = dict[@"alert"];
        NSLog(@"content = %@", content);
    }
    if (application.applicationState == UIApplicationStateActive)
    {
        // 程序当前正处于前台
    }
    else if (application.applicationState == UIApplicationStateInactive)
    {
        // 程序处于后台
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
