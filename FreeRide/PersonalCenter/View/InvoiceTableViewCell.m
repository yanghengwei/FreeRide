//
//  InvoiceTableViewCell.m
//  FreeRide
//
//  Created by pc on 2017/11/28.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "InvoiceTableViewCell.h"

@interface InvoiceTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *isselectedImgeView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation InvoiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        _isselectedImgeView.image = [UIImage imageNamed:@"Selected"];
    } else {
        _isselectedImgeView.image = [UIImage imageNamed:@"Unchecked"];
    }
}

@end
