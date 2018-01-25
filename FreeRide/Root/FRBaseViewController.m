//
//  FRBaseViewController.m
//  FreeRide
//
//  Created by pc on 2017/10/30.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "FRBaseViewController.h"

#import <JPUSHService.h>
#import <AFNetworking.h>
//#import <MJExtension.h>

@interface FRBaseViewController ()

@end


@implementation FRBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
+ (UIViewController *)presentingVC{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
//    if ([result isKindOfClass:[RootTabViewController class]]) {
//        result = [(RootTabViewController *)result selectedViewController];
//    }
//    if ([result isKindOfClass:[UINavigationController class]]) {
//        result = [(UINavigationController *)result topViewController];
//    }
    return result;
}

+ (void)presentVC:(UIViewController *)viewController{
    if (!viewController) {
        return;
    }
//    UINavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:viewController];
//    if (!viewController.navigationItem.leftBarButtonItem) {
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:viewController action:@selector(dismissModalVC)];
//    }
//    [[self presentingVC] presentViewController:nav animated:YES completion:nil];
}
+ (void)goToVC:(UIViewController *)viewController{
    if (!viewController) {
        return;
    }
    UINavigationController *nav = [self presentingVC].navigationController;
    if (nav) {
        [nav pushViewController:viewController animated:YES];
    }
}

#pragma mark Login
- (void)loginOutToLoginVC{
//    [Login doLogout];
//    [((AppDelegate *)[UIApplication sharedApplication].delegate) setupLoginViewController];
}


@end
