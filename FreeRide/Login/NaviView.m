//
//  NaviView.m
//  FreeRide
//
//  Created by  on 2017/11/10.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "NaviView.h"
#import "Header.h"

@implementation NaviView

- (instancetype)initWithFrame:(CGRect)frame andName:(NSString *)string andTyep:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI:string andType:type];
    }
    return self;
}

- (void)creatUI:(NSString *)string andType:(NSString *)type
{
    self.backgroundColor=[UIColor whiteColor];
    //左侧按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(10), YMAKENEW(10), XMAKENEW(30), XMAKENEW(30))];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    
    //中间按钮
    UIButton *middleBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(150), YMAKENEW(15), XMAKENEW(75), YMAKENEW(22))];
    [middleBtn setTitle:string forState:UIControlStateNormal];
    [middleBtn addTarget:self action:@selector(chooseUser) forControlEvents:UIControlEventTouchUpInside];
    [middleBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    [middleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -middleBtn.imageView.frame.size.width-XMAKENEW(26), 0, middleBtn.imageView.frame.size.width)];
    [middleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, middleBtn.titleLabel.bounds.size.width-XMAKENEW(8), 0, -middleBtn.titleLabel.bounds.size.width)];
    [middleBtn setImage:[UIImage imageNamed:@"home_open"] forState:UIControlStateNormal];
    middleBtn.layer.cornerRadius = 13.0;//2.0是圆角的弧度，根据需求自己更改
    middleBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    [middleBtn.layer setBorderColor:COLOR_TEXT_LIGHT.CGColor];
    middleBtn.layer.borderWidth = 1.0f;//设置边框颜色
    middleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    //title
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(XMAKENEW(20), CGRectGetMinY(backBtn.frame), XMAKENEW(335), backBtn.frame.size.height)];
    nameLabel.text = string;
    nameLabel.textColor=COLOR_TEXT_DARK;
    nameLabel.font=[UIFont systemFontOfSize:14];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    //右侧按钮
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(340), YMAKENEW(10), XMAKENEW(30), XMAKENEW(30))];
    [rightBtn addTarget:self action:@selector(infoAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"newnews"] forState:UIControlStateNormal];
    
    //判断类型
    if ([type isEqualToString:@"normal"]) {
        [backBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
        [self addSubview:nameLabel];
    } else if ([type isEqualToString:@"personalCenter"]) {
        [backBtn setImage:[UIImage imageNamed:@"profile"] forState:UIControlStateNormal];
        [self addSubview:middleBtn];
        [self addSubview:rightBtn];
    }
    
    //线
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backBtn.frame)+YMAKENEW(8), self.frame.size.width, 0.5)];
    line.backgroundColor = COLOR_background;
    [self addSubview:line];
}
- (void)infoAction {
    self.block(@"right");
}
- (void)backAction {
    self.block(@"back");
}
- (void)chooseUser {
    self.block(@"choose");
}
@end

