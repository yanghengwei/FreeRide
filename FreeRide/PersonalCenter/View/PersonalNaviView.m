//
//  PersonalNaviView.m
//  FreeRide
//
//  Created by pc on 2017/11/25.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "PersonalNaviView.h"
#import "Header.h"

@implementation PersonalNaviView

- (instancetype)initWithFrame:(CGRect)frame andName:(NSString *)title andRightTitle:(NSString *)rightTitle {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI:title andRightTitle:rightTitle];
    }
    return self;
}
- (void)creatUI:(NSString *)title andRightTitle:(NSString *)rightTiitle {
    self.backgroundColor=[UIColor whiteColor];
    //左侧按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 30, 30)];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    
    //title
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(XMAKENEW(20), CGRectGetMinY(backBtn.frame), XMAKENEW(335), backBtn.frame.size.height)];
    nameLabel.text = title;
    nameLabel.textColor=COLOR_TEXT_DARK;
    nameLabel.font=[UIFont systemFontOfSize:14];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLabel];
    //右侧按钮
    _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(270), 30, XMAKENEW(92), 30)];
    [_rightBtn setTitle:rightTiitle forState:UIControlStateNormal];
    [_rightBtn setTitleColor:COLOR_ORANGE forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_rightBtn addTarget:self action:@selector(infoAction) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self addSubview:_rightBtn];
    //线
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
    line.backgroundColor = COLOR_background;
    [self addSubview:line];
}
- (void)infoAction {
    self.block(@"right");
}
- (void)backAction {
    self.block(@"back");
}
@end
