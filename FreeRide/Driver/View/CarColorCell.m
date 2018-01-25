//
//  CarColorCell.m
//  FreeRide
//
//  Created by  on 2017/12/11.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "CarColorCell.h"

@interface CarColorCell ()

@property (weak, nonatomic) IBOutlet UIImageView *isselectedImageView;

@end

@implementation CarColorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        _isselectedImageView.image = [UIImage imageNamed:@"choose"];
    } else {
        _isselectedImageView.image = nil;
    }
}

@end
