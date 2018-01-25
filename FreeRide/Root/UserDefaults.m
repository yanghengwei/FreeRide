//
//  UserDefaults.m
//  text
//
//  Created by pillar‘s on 15/12/3.
//  Copyright © 2015年 pillar‘s. All rights reserved.
//

#import "UserDefaults.h"

@implementation UserDefaults

static id _instace; //存储单利对象

+ (void)saveValue:(id)value forKey:(NSString *)key
{
    //使用NSUserDefaults存储数据
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (id)getValueForKey:(NSString *)key
{
    //使用NSUserDefaults取出数据
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+ (void)removeValueForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



//单利创建
+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

+ (instancetype)sharedDataTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc] init];
    });
    return _instace;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instace;
}

@end
