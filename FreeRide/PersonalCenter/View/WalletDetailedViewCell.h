//
//  WalletDetailedViewCell.h
//  FreeRide
//
//  Created by pc on 2017/11/25.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WalletDetailedViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end
