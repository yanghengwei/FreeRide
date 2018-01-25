//
//  CarsInfoTableView.h
//  FreeRide
//
//  Created by mac on 2017/12/29.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Block)(NSDictionary *backInfo);

@interface CarsInfoTableView : UIView

@property (nonatomic, copy) Block block;

- (instancetype)initWithFrame:(CGRect)frame andType:(NSArray *)dataArr;

@end

