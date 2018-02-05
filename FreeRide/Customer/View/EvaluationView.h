//
//  EvaluationView.h
//  FreeRide
//
//  Created by  on 2017/11/29.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Blo)(NSString *backInfo);

@interface EvaluationView : UIView
- (instancetype)initWithFrame:(CGRect)frame andString:(NSString *)data;
@property (nonatomic, copy) Blo block;

@end
