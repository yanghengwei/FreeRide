//
//  FRCancelTableViewCell.m
//  FreeRide
//
//  Created by  on 2017/12/5.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "FRCancelTableViewCell.h"

@interface FRCancelTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@end

@implementation FRCancelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        _checkImageView.image = [UIImage imageNamed:@"Selected"];
    } else {
        _checkImageView.image = [UIImage imageNamed:@"unchecked"];
    }
}

@end
