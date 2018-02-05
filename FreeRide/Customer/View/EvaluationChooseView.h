//
//  EvaluationChooseView.h
//  FreeRide
//
//  Created by  on 2017/12/7.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Block)(NSDictionary *backInfo);

@interface EvaluationChooseView : UIView
- (instancetype)initWithFrame:(CGRect)frame andData:(NSDictionary *)data;

@property (nonatomic, copy) Block blockInfo;

@end
