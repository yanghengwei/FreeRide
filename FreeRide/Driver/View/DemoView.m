//
//  DemoView.m
//  FreeRide
//
//  Created by  on 2017/12/11.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "DemoView.h"
#import "Header.h"

@implementation DemoView

- (instancetype)initWithFrame:(CGRect)frame andType:(NSString *)type {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI:type];
    }
    return self;
}
- (void)createUI:(NSString *)type {
    NSDictionary *dic;
    if ([type isEqualToString:@"2"]) {
        dic = @{@"image":@"driver'slicense",@"info":@"注意：\n1、请严格按照示例图上传;\n2、四角对齐，信息完整。如模糊、反光、太暗、有遮挡等导致信息不完整，将不予认证;"};
    } else if ([type isEqualToString:@"3"]) {
        dic = @{@"image":@"drivinglicense",@"info":@"注意：\n1、请严格按照示例图上传;\n2、四角对齐，信息完整。如模糊、反光、太暗、有遮挡等导致信息不完整，将不予认证;"};
    } else {
        dic = @{@"image":@"img_vehicle",@"info":@"注意：\n1、请严格按照示例图上传;\n2、请横屏拍摄实车，清晰显示车头车尾且带有完整车牌，车身周围适当留空;\n翻拍行驶证上的车身照片，不予认证;"};
    }
    UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-XMAKENEW(400))];
    backgroudView.backgroundColor = [UIColor blackColor];
    backgroudView.alpha = 0.7;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTapToCityDetail:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [backgroudView addGestureRecognizer:tap];
    [self addSubview:backgroudView];
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, backgroudView.frame.size.height, self.frame.size.width, self.frame.size.height-backgroudView.frame.size.height)];
    mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:mainView];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainView.frame.size.width, XMAKENEW(44))];
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, XMAKENEW(2), XMAKENEW(60), XMAKENEW(40))];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(leftBtn.frame), headView.frame.size.width, XMAKENEW(40))];
    titleLabel.text = @"示例图";
    titleLabel.textColor = COLOR_TEXT_DARK;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:titleLabel];
    [mainView addSubview:headView];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(315), CGRectGetMinY(leftBtn.frame), XMAKENEW(60), XMAKENEW(40))];
    [rightBtn setTitle:@"×" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:FONT12];
    [rightBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    rightBtn.tag = 1413;
    [rightBtn addTarget:self action:@selector(btnTarget:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:rightBtn];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, headView.frame.size.height-1, self.frame.size.width, 1)];
    line.backgroundColor = COLOR_background;
    [headView addSubview:line];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(15), CGRectGetMaxY(line.frame)+XMAKENEW(10), XMAKENEW(345), XMAKENEW(238))];
    imageView.image = [UIImage imageNamed:[dic objectForKey:@"image"]];
    [mainView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(20), CGRectGetMaxY(imageView.frame)+XMAKENEW(10), XMAKENEW(335), XMAKENEW(80))];
    label.attributedText = [self setLabelRichInfo:[dic objectForKey:@"info"]];
    label.numberOfLines = 0;
    [mainView addSubview:label];
}
- (NSMutableAttributedString *)setLabelRichInfo:(NSString *)string {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:13]
                    range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttribute:NSKernAttributeName
                    value:@(0)
                    range:NSMakeRange(0, attrStr.length)];
    
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:COLOR_TEXT_NORMAL
                    range:NSMakeRange(0, attrStr.length)];
    return attrStr;
}
- (void)btnTarget:(UIButton *)button {
    [self removeFromSuperview];
}
- (void)chooseTapToCityDetail:(UITapGestureRecognizer*)tap {
    [self removeFromSuperview];
}
@end
