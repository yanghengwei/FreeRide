//
//  PersonalNaviView.h
//  FreeRide
//
//  Created by pc on 2017/11/25.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Blo)(NSString *backInfo);

@interface PersonalNaviView : UIView

@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, copy) Blo block;
- (instancetype)initWithFrame:(CGRect)frame andName:(NSString *)title andRightTitle:(NSString *)rigthTitle;

@end
