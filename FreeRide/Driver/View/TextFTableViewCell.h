//
//  TextFTableViewCell.h
//  text
//
//  Created by niujiangkuo on 16/1/19.
//  Copyright © 2016年 pillar‘s. All rights reserved.
//

#import <UIKit/UIKit.h>

/*输入框*/

@interface TextFTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
//内容
@property (weak, nonatomic) IBOutlet UILabel *downLabel;
@property(nonatomic,strong)NSArray *nameArray;

@end
