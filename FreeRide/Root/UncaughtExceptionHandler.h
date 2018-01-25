//
//  UncaughtExceptionHandler.h
//  FreeRide
//
//  Created by yang on 2018/1/24.
//  Copyright © 2018年 pc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UncaughtExceptionHandler : NSObject{
    BOOL dismissed;
}

@end
void HandleException(NSException *exception);
void SignalHandler(int signal);


void InstallUncaughtExceptionHandler(void);  
