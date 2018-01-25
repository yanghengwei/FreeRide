//
//  CodeView.m
//  FreeRide
//
//  Created by  on 2018/1/4.
//  Copyright © 2018年 JNR All rights reserved.
//

#import "CodeView.h"
#import "Header.h"

@implementation CodeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    UIView *backgroudView = [[UIView alloc] initWithFrame:self.bounds];
    backgroudView.backgroundColor = [UIColor blackColor];
    backgroudView.alpha = 0.7;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTapToCityDetail:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [backgroudView addGestureRecognizer:tap];
    [self addSubview:backgroudView];
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-40, XMAKENEW(160))];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.center = self.center;
    [self addSubview:mainView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(25), XMAKENEW(15), mainView.frame.size.width-XMAKENEW(50), XMAKENEW(40))];
    label.text = @"请输入图形验证码";
    [mainView addSubview:label];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame)-XMAKENEW(7), label.frame.size.width-XMAKENEW(80), XMAKENEW(40))];
    textField.placeholder = @"不区分大小写";
    textField.tag = 1104;
    [mainView addSubview:textField];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(textField.frame), CGRectGetMaxY(textField.frame)-XMAKENEW(2), textField.frame.size.width, 1)];
    line.backgroundColor = COLOR_ORANGE;
    [mainView addSubview:line];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(textField.frame)+XMAKENEW(7), CGRectGetMinY(textField.frame), label.frame.size.width-textField.frame.size.width-XMAKENEW(10), textField.frame.size.height)];
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapTager = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImage:)];
    [_imageView addGestureRecognizer:tapTager];
    [mainView addSubview:_imageView];
    
    NSArray *titleArr = @[@"取消",@"提交"];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(80), XMAKENEW(30))];
        button.center = CGPointMake(mainView.frame.size.width/3*(1+i), XMAKENEW(120));
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tagerLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = COLOR_ORANGE;
        button.layer.cornerRadius = 3.0;//2.0是圆角的弧度，根据需求自己更改
        button.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
        button.layer.borderWidth = 0.5f;//设置边框颜色
        [mainView addSubview:button];
    }
}
- (void)tagerLoginBtn:(UIButton *)button {
    UITextField *field = [self viewWithTag:1104];
    if ([button.titleLabel.text isEqualToString:@"提交"]) {
        self.block(field.text);
    } else {
        [self removeFromSuperview];
    }
}
- (void)changeImage:(UITapGestureRecognizer*)tap {
    self.block(@"changeImage");
}
- (void)chooseTapToCityDetail:(UITapGestureRecognizer*)tap {
    [self removeFromSuperview];
}

@end
