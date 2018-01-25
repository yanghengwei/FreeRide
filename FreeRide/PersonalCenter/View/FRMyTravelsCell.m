//
//  FRMyTravelsCell.m
//  FreeRide
//
//  Created by  on 2017/12/7.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "FRMyTravelsCell.h"

@interface FRMyTravelsCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

@implementation FRMyTravelsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _timeLabel.text = @"ssdfgsfgs";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
