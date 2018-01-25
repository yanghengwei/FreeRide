//
//  ChooseBtnView.h
//  FreeRide
//
//  Created by  on 2017/12/15.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Blo)(NSString *backInfo);

@interface ChooseBtnView : UIView

@property (nonatomic, copy) Blo block;

@end
