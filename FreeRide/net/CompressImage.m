//
//  CompressImage.m
//  FreeRide
//
//  Created by  on 2017/12/27.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "CompressImage.h"

@implementation CompressImage

NSData * compressImage(UIImage *image, CGFloat maxlength){
    CGFloat compression = 1;
    CGFloat maxLength = maxlength*1024;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length > maxLength) {
        CGFloat max = 1;
        CGFloat min = 0;
        for (int i = 0; i < 6; i++) {
            compression = (max + min) / 2;
            data = UIImageJPEGRepresentation(image, compression);
            if (data.length < maxLength * 0.9) {
                min = compression;
            } else if (data.length > maxLength) {
                max = compression;
            } else {
                break;
            }
        }
        NSLog(@"%lukb",data.length/1024);
        UIImage *resultImage = [UIImage imageWithData:data];
        if (data.length < maxLength) { return data; }
        
        // Compress by size
        long lastDataLength = 0;
        while (data.length > maxLength && data.length != lastDataLength) {
            lastDataLength = data.length;
            CGFloat ratio = maxLength / data.length;
            CGSize size = CGSizeMake(resultImage.size.width * sqrt(ratio),resultImage.size.height * sqrt(ratio));
            UIGraphicsBeginImageContext(size);
            [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
            resultImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            data = UIImageJPEGRepresentation(resultImage, compression);
            NSLog(@"%lukb",data.length/1024);
        }
        return data;
    } else {
        return data;
    }
}
@end
