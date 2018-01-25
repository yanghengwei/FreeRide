//
//  PayInfoView.m
//  FreeRide
//
//  Created by pc on 2017/11/16.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "PayInfoView.h"
#import "Header.h"

@implementation PayInfoView

- (instancetype)initWithFrame:(CGRect)frame andTyep:(NSString *)type
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI:type];
    }
    return self;
}

- (void)creatUI:(NSString *)type {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:view];
    
    UIColor *color = COLOR_TEXT_DARK;
    if ([type isEqualToString:@"long"]) {
        color = COLOR_ORANGE;
    }
    
    NSArray *textArr = @[@"——— 车费详情 ———",@"——— 付款方式 ———"];
    NSArray *nameArr = @[@"动态折扣",@"实际应付"];
    NSArray *moneyArr = @[@"-¥143.3",@"¥256.6"];
    NSArray *arr = @[@"行程总费用",@"¥400"];
    NSArray *imageName = @[@"balance",@"WeChat"];
    NSArray *infoArr = @[@"账户余额支付",@"微信支付"];
    for (int i = 0; i < 2; i++) {
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, XMAKENEW(0)+i*XMAKENEW(185), self.frame.size.width, XMAKENEW(30))];
        titleLbl.text = textArr[i];
        titleLbl.textColor = COLOR_TEXT_NORMAL;
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.font = [UIFont systemFontOfSize:FONT12];
        [view addSubview:titleLbl];
        
        UILabel *infoLbl = [[UILabel alloc] initWithFrame:CGRectMake(i*XMAKENEW(157)+XMAKENEW(60), XMAKENEW(82), XMAKENEW(150), XMAKENEW(30))];
        infoLbl.text = arr[i];
        infoLbl.textColor = COLOR_TEXT_DARK;
        if (i == 0) {
            infoLbl.textAlignment = NSTextAlignmentLeft;
        } else {
            infoLbl.textAlignment = NSTextAlignmentCenter;
        }
        infoLbl.font = [UIFont systemFontOfSize:FONT12];
        [view addSubview:infoLbl];
        
        UILabel *snLbl = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(60), XMAKENEW(117)+i*XMAKENEW(35), XMAKENEW(150), XMAKENEW(30))];
        snLbl.text = nameArr[i];
        snLbl.textColor = color;
        snLbl.textAlignment = NSTextAlignmentLeft;
        snLbl.font = [UIFont systemFontOfSize:FONT12];
        [view addSubview:snLbl];
        
        UILabel *thLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(snLbl.frame)+XMAKENEW(30), CGRectGetMinY(snLbl.frame), XMAKENEW(100), XMAKENEW(30))];
        thLbl.text = moneyArr[i];
        thLbl.textColor = color;
        thLbl.textAlignment = NSTextAlignmentCenter;
        thLbl.font = [UIFont systemFontOfSize:FONT12];
        [view addSubview:thLbl];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(snLbl.frame), XMAKENEW(225)+i*XMAKENEW(40), XMAKENEW(30), XMAKENEW(30))];
        imageView.image = [UIImage imageNamed:imageName[i]];
        [view addSubview:imageView];
        
        UILabel *lastLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+XMAKENEW(10), CGRectGetMinY(imageView.frame), XMAKENEW(150), imageView.frame.size.height)];
        lastLbl.tag = 10000+i;
        lastLbl.text = infoArr[i];
        lastLbl.font = [UIFont systemFontOfSize:14];
        lastLbl.textColor = COLOR_TEXT_DARK;
        [view addSubview:lastLbl];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+XMAKENEW(200), CGRectGetMinY(imageView.frame), imageView.frame.size.width, imageView.frame.size.height)];
        btn.tag = 1000+i;
        [btn setImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(chooseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
    if (/*[_moneyDic objectForKey:@"vacancies"]<[_moneyDic objectForKey:@"money"]*/1) {
        UILabel *labl = [self viewWithTag:10000];
        labl.center = CGPointMake(XMAKENEW(175), XMAKENEW(232));
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(labl.frame), CGRectGetMaxY(labl.frame)-XMAKENEW(12), XMAKENEW(200), labl.frame.size.height)];
        infoLabel.text = @"余额不足，请选择其他支付方式";
        infoLabel.textColor = COLOR_TEXT_LIGHT;
        infoLabel.font = [UIFont systemFontOfSize:FONT12];
        [view addSubview:infoLabel];
    }
    
    UILabel *moneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, XMAKENEW(25), self.frame.size.width, XMAKENEW(45))];
    moneyLbl.text = @"¥256.6";
    moneyLbl.textColor = COLOR_TEXT_DARK;
    moneyLbl.textAlignment = NSTextAlignmentCenter;
    moneyLbl.font = [UIFont systemFontOfSize:30];
    [view addSubview:moneyLbl];
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height, self.frame.size.width, XMAKENEW(300))];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
}
- (void)chooseBtn:(UIButton *)button {
    UIButton *btn1 = [self viewWithTag:1000];
    UIButton *btn2 = [self viewWithTag:1001];
    if (button.tag == 1000) {
        btn1.selected = YES;
        btn2.selected = NO;
    } else {
        btn2.selected = YES;
        btn1.selected = NO;
    }
}
@end
