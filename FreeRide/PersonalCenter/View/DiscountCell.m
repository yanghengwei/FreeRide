//
//  DiscountCell.m
//  FreeRide
//
//  Created by pc on 2017/11/21.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "DiscountCell.h"

@interface DiscountCell ()

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIView *hiddenView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation DiscountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setInfoToCell:(NSDictionary *)data {
    
}
- (IBAction)moreBtnAction:(id)sender {
    _nextBtn.selected = !_nextBtn.selected;
    [self reloadCellBtn];
}
- (void)reloadCellBtn {
    if (_nextBtn.selected) {
        _leftLabel.text = @"太原市区→朔州市区\n小店区箭头→朔州市区\n小店区→朔州市区";
//        [_data objectForKey:@"info"];
        _rightLabel.text = [_data objectForKey:@"info"];
    } else {
        _leftLabel.text = @"";
        _rightLabel.text = @"";
    }
    self.reloadBlock(@"reload");
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
