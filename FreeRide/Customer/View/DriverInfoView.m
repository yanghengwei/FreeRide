//
//  DriverInfoView.m
//  FreeRide
//
//  Created by pc on 2017/11/16.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "DriverInfoView.h"
#import "Header.h"

@implementation DriverInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}
- (void)creatUI {
    //司机头像
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(25), XMAKENEW(5), XMAKENEW(32), XMAKENEW(32))];
    imageView.image = [UIImage imageNamed:@"bg_certification"];
    [imageView.layer setCornerRadius:imageView.frame.size.width/2];
    [imageView.layer setMasksToBounds:YES];
    [self addSubview:imageView];
    //打电话按钮
    UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+XMAKENEW(230), CGRectGetMinY(imageView.frame), XMAKENEW(60), imageView.frame.size.height)];
    [phoneBtn setImage:[UIImage imageNamed:@"telephone"] forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(payPhone:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:phoneBtn];
    //订单状态
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+XMAKENEW(150), CGRectGetMaxY(phoneBtn.frame)+XMAKENEW(23), XMAKENEW(150), phoneBtn.frame.size.height)];
    stateLabel.textColor = COLOR_ORANGE;
    stateLabel.text = @"行驶结束，待评价";
    stateLabel.textAlignment = NSTextAlignmentRight;
    stateLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:stateLabel];
    //司机姓名
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+XMAKENEW(5), CGRectGetMinY(imageView.frame)-1, XMAKENEW(45), 20)];
    nameLabel.text = @"吴师傅";
    nameLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:nameLabel];
    //司机性别
    UIImageView *maleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), CGRectGetMinY(nameLabel.frame), nameLabel.frame.size.height, nameLabel.frame.size.height)];
    maleImageView.image = [UIImage imageNamed:@"female"];
    [self addSubview:maleImageView];
    //司机车牌
    UILabel *carIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maleImageView.frame), CGRectGetMinY(maleImageView.frame)+2, XMAKENEW(60), maleImageView.frame.size.height-4)];
    carIdLabel.text = @"晋A66666";
    carIdLabel.backgroundColor = COLOR_TEXT_LIGHT;
    carIdLabel.textColor = COLOR_TEXT_DARK;
    carIdLabel.font = [UIFont systemFontOfSize:FONT12];
    [self addSubview:carIdLabel];
    //汽车信息
    UILabel *carInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame)-XMAKENEW(3), self.frame.size.width, nameLabel.frame.size.height)];
    carInfoLabel.text = @"上汽大通G10    白色";
    carInfoLabel.textColor = COLOR_TEXT_NORMAL;
    carInfoLabel.font = [UIFont systemFontOfSize:FONT12];
    [self addSubview:carInfoLabel];
    //线
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(12), CGRectGetMaxY(imageView.frame)+XMAKENEW(5), self.frame.size.width-XMAKENEW(24), 1)];
    line.backgroundColor = COLOR_background;
    [self addSubview:line];
    
    //行程信息
    NSArray *imageNameArr = @[@"time",@"start_eidt",@"end_eidt"];
    NSArray *labelText = @[@"今天10:00-10:30  4人拼座",@"太原市万国城MOMA",@"朔州市市政府"];
    for (int i = 0; i < 3; i++) {
        //图标
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame), CGRectGetMaxY(line.frame)+XMAKENEW(10)+i*XMAKENEW(20), XMAKENEW(10), XMAKENEW(10))];
        imageView1.image = [UIImage imageNamed:imageNameArr[i]];
        [self addSubview:imageView1];
        //文本
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView1.frame)+XMAKENEW(5), CGRectGetMinY(imageView1.frame), XMAKENEW(200), imageView1.frame.size.height)];
        label.text = labelText[i];
        label.textColor = COLOR_TEXT_DARK;
        label.font = [UIFont systemFontOfSize:13];
        [self addSubview:label];
    }
}
- (void)payPhone:(UIButton *)button {
    NSLog(@"拨打司机电话");
}
@end
