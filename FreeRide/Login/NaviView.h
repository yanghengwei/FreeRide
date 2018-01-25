//
//  NaviView.h
//  FreeRide
//
//  Created by  on 2017/11/10.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Blo)(NSString *backInfo);

@interface NaviView : UIView

@property (nonatomic, copy) Blo block;
- (instancetype)initWithFrame:(CGRect)frame andName:(NSString *)string andTyep:(NSString *)type;
@end

