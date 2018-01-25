//
//  TextFTableViewCell.m
//  text
//
//  Created by niujiangkuo on 16/1/19.
//  Copyright © 2016年 pillar‘s. All rights reserved.
//

#import "TextFTableViewCell.h"
#define XMAKENEW(x) [[UIScreen mainScreen] bounds].size.width / 375.0*x
#define YMAKENEW(y) [[UIScreen mainScreen] bounds].size.height / 667.0*y

@implementation TextFTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setNameArray:(NSArray *)nameArray
{
    _nameArray=nameArray;
    [self createUI];
}
-(void)createUI
{

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
