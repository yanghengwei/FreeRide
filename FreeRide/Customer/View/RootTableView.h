//
//  RootTableView.h
//  FreeRide
//
//  Created by  on 2017/11/30.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BloBtn)(NSString *backInfo);

@interface RootTableView : UIView
@property (nonatomic, copy) BloBtn blockBtn;
//- (instancetype)initWithFrame:(CGRect)frame;
@end
