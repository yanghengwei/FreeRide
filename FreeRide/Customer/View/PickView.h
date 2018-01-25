//
//  PickView.h
//  FreeRide
//
//  Created by  on 2017/12/2.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PickBlock)(NSString *backInfo);

@interface PickView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) NSArray *pickerData;
@property (nonatomic, copy) NSString *selectInfo;
@property (nonatomic, copy) PickBlock pickBlock;
- (void)changePickSelected;
@end
