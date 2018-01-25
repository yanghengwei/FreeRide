//
//  CompressImage.h
//  FreeRide
//
//  Created by  on 2017/12/27.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CompressImage : NSObject

NSData * compressImage(UIImage *image, CGFloat maxlength);

@end
