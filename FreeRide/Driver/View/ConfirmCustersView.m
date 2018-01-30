//
//  ConfirmCustersView.m
//  FreeRide
//
//  Created by iOS on 2018/1/26.
//  Copyright © 2018年 pc. All rights reserved.
//

#import "ConfirmCustersView.h"
#import "Header.h"
#import "CustmerInfoView.h"

@interface ConfirmCustersView ()

@end

@implementation ConfirmCustersView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTapToCityDetail:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [backView addGestureRecognizer:tap];
    [self addSubview:backView];
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-XMAKENEW(95), XMAKENEW(450))];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.center = self.center;
    [self addSubview:mainView];
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainView.frame.size.width, XMAKENEW(40))];
    [mainView addSubview:toolView];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(40), XMAKENEW(40))];
    [leftBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(chooseTapToCityDetail:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:leftBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, toolView.frame.size.width, toolView.frame.size.height)];
    label.text = @"确认同行订单";
    label.textColor = COLOR_TEXT_DARK;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    [toolView addSubview:label];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, toolView.frame.size.height-1, toolView.frame.size.width, 1)];
    line.backgroundColor = COLOR_background;
    [toolView addSubview:line];
    
    UIView *custem = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(toolView.frame)+XMAKENEW(15), mainView.frame.size.width, XMAKENEW(300))];
    [mainView addSubview:custem];
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 2; j++) {
            CustmerInfoView *subView = [[CustmerInfoView alloc] initWithFrame:CGRectMake(mainView.frame.size.width/2*j, XMAKENEW(105)*i, mainView.frame.size.width/2, XMAKENEW(100))];
            subView.tag = 666+i*10+j;
            [custem addSubview:subView];
        }
    }
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(custem.frame)+XMAKENEW(20), mainView.frame.size.width, XMAKENEW(60))];
    [mainView addSubview:footView];
    UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mainView.frame.size.width, XMAKENEW(30))];
    footLabel.textAlignment = NSTextAlignmentCenter;
    footLabel.text = @"合计¥230元";
    footLabel.font = [UIFont systemFontOfSize:14];
    [footView addSubview:footLabel];
    
    NSArray *arr = @[@{@"name":@"取消",@"color":COLOR_ORANGE},@{@"name":@"取消",@"color":COLOR_ORANGE}];
    for (int i = 0; i < 2; i++) {
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mainView.frame.size.width/3, XMAKENEW(30))];
        [leftBtn setTitle:[arr[i] objectForKey:@"name"] forState:UIControlStateNormal];
        [leftBtn setBackgroundColor:[arr[i] objectForKey:@"color"]];
        leftBtn.center = CGPointMake(mainView.frame.size.width/4*(1+2*i), CGRectGetMaxY(footLabel.frame)+XMAKENEW(15));
        [footView addSubview:leftBtn];
    }
}
- (void)chooseTapToCityDetail:(UITapGestureRecognizer*)tap {
    [self removeFromSuperview];
}

@end
