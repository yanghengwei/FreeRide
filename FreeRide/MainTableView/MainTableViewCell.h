//
//  MainTableViewCell.h
//  FreeRide
//
//  Created by  on 2017/11/15.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BloBtn)(NSString *backInfo);

@interface MainTableViewCell : UITableViewCell

@property (nonatomic, copy) BloBtn blockBtn;

@end
