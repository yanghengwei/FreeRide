//
//  AESCipher.m
//  FreeRide
//
//  Created by  on 2017/11/21.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <Foundation/Foundation.h>

NSString * aesEncryptString(NSString *content, NSString *key);
NSString * aesDecryptString(NSString *content, NSString *key);

NSData * aesEncryptData(NSData *data, NSData *key);
NSData * aesDecryptData(NSData *data, NSData *key);
