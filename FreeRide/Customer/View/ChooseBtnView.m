//
//  ChooseBtnView.m
//  FreeRide
//
//  Created by  on 2017/12/15.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "ChooseBtnView.h"
#import "Header.h"

@interface ChooseBtnView () <UIAlertViewDelegate>

@end

@implementation ChooseBtnView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTapToCityDetail:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:tap];
    [self addSubview:view];
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(XMAKENEW(270), 57, XMAKENEW(85), XMAKENEW(70))];
    btnView.backgroundColor = [UIColor whiteColor];
    [self addSubview:btnView];
    
    NSArray *arr = @[@{@"image":@"valuation",@"title":@"计价规则"},@{@"image":@"cancel",@"title":@"取消订单"}];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, i*btnView.frame.size.height/2, btnView.frame.size.width,  btnView.frame.size.height/2)];
        [button setTitle:[arr[i] objectForKey:@"title"] forState:UIControlStateNormal];
        [button setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.layer.borderColor = [COLOR_background CGColor];
        //设置边框宽度
        button.layer.borderWidth = 1.0f;
        [button setImage:[UIImage imageNamed:[arr[i] objectForKey:@"image"]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectorBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:button];
    }
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, btnView.frame.size.height/2, btnView.frame.size.width, 1)];
    line.backgroundColor = COLOR_background;
    [btnView addSubview:line];
}
- (void)chooseTapToCityDetail:(UITapGestureRecognizer *)tap {
    [self removeFromSuperview];
}
- (void)selectorBtn:(UIButton *)button {
    if ([button.titleLabel.text isEqualToString:@"计价规则"]) {
        self.block(@"计价规则");
        [self removeFromSuperview];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定取消订单" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确定", nil];
        alert.tag = 1111;
        [alert show];
        return;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1111 && buttonIndex == 1){
        self.block(@"cancel");
    }
    [self removeFromSuperview];
}
@end
