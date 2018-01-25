//
//  DriverInfoCell.h
//  FreeRide
//
//  Created by  on 2017/12/9.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BloCell)(NSString *backInfo,NSString *cellID);

@interface DriverInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIButton *setIamgeBtn;
@property (nonatomic, copy) NSString *cellID;
@property (nonatomic, strong) BloCell block;
@end
