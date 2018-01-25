//
//  CodeView.h
//  FreeRide
//
//  Created by  on 2018/1/4.
//  Copyright © 2018年 JNR All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Blo)(NSString *backInfo);

@interface CodeView : UIView

@property (nonatomic, copy) Blo block;
@property (nonatomic, strong) UIImageView *imageView;

@end
