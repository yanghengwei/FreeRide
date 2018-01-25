//
//  MainTableViewCell.m
//  FreeRide
//
//  Created by  on 2017/11/15.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "MainTableViewCell.h"

@implementation MainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)goNextVC:(id)sender {
    self.blockBtn(@"next");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
