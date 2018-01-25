//
//  ChooseCarColorView.h
//  FreeRide
//
//  Created by  on 2017/12/11.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BloInfo)(NSString *backInfo);

@interface ChooseCarColorView : UIView

@property (nonatomic, copy) NSString *chooseInfoStr;
@property (nonatomic, strong) BloInfo block;

@end
