//
//  DiscountCell.h
//  FreeRide
//
//  Created by pc on 2017/11/21.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Blo)(NSString *reload);

@interface DiscountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (nonatomic, copy) Blo reloadBlock;
- (void)setInfoToCell;
@property (nonatomic, copy) NSDictionary *data;
@end
