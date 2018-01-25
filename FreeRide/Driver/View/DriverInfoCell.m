//
//  DriverInfoCell.m
//  FreeRide
//
//  Created by  on 2017/12/9.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "DriverInfoCell.h"

@implementation DriverInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.setIamgeBtn.bounds];
//    [self.setIamgeBtn setImage:[self drawLineByImageView:imageView] forState:UIControlStateNormal];
}
// 返回虚线image的方法
- (UIImage *)drawLineByImageView:(UIImageView *)imageView{
    UIGraphicsBeginImageContext(imageView.frame.size); //开始画线 划线的frame
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    //设置线条终点形状
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    // 5是每个虚线的长度 1是高度
    CGFloat lengths[] = {5,1};
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置颜色
    CGContextSetStrokeColorWithColor(line, [UIColor colorWithWhite:0.408 alpha:1.000].CGColor);
    CGContextSetLineDash(line, 0, lengths, 2); //画虚线
    CGContextMoveToPoint(line, 0.0, 2.0); //开始画线
    CGContextAddLineToPoint(line, 375 - 10, 2.0);
    
    CGContextStrokePath(line);
    // UIGraphicsGetImageFromCurrentImageContext()返回的就是image
    return UIGraphicsGetImageFromCurrentImageContext();
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)promptBtnTagert:(id)sender {
    self.block(@"btn",[NSString stringWithFormat:@"%@",self.cellID]);
}
- (IBAction)imageAction:(id)sender {
    self.block(@"image",[NSString stringWithFormat:@"%@",self.cellID]);
}

@end
