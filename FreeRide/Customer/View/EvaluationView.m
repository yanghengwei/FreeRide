//
//  EvaluationView.m
//  FreeRide
//
//  Created by  on 2017/11/29.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "EvaluationView.h"
#import "Header.h"
#define BtnWidth 30

@interface EvaluationView ()
{
    NSInteger selecteBtnTag;
    UIView *longView;
    UIView *shortView;
    UILabel *labeb;
}
@property (nonatomic, copy) NSString *btnStings;
@property (nonatomic, copy) NSString *bestString;

@end

@implementation EvaluationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    _btnStings = [[NSMutableString alloc] init];
    _bestString = [[NSMutableString alloc] init];
    for (int i = 0; i < 5; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2+(i-2.5)*BtnWidth, 10, BtnWidth, BtnWidth)];
        [button setImage:[UIImage imageNamed:@"star_nor"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"star_sel"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(setBtnSelected:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 990+i;
        [self addSubview:button];
    }
    labeb = [[UILabel alloc] initWithFrame:CGRectMake(0, 8+BtnWidth, self.frame.size.width, XMAKENEW(25))];
    labeb.text = @"请先选择星级";
    labeb.textAlignment = NSTextAlignmentCenter;
    labeb.tag = 10001;
    labeb.font = [UIFont systemFontOfSize:FONT12];
    labeb.textColor = COLOR_TEXT_NORMAL;
    [self addSubview:labeb];
    [self setLongView];
    [self cgreateShortView];
}
- (void)setLongView {
    UILabel *label = [self viewWithTag:10001];
    longView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+XMAKENEW(10), self.frame.size.width, XMAKENEW(150))];
    [self addSubview:longView];
    NSArray *btnName = @[@[@"危险驾驶",@"路况不熟"],@[@"服务态度恶劣",@"车内有异味"],@[@"打电话玩手机",@"过路口不减速"],@[@"没坐好就开车",@"未提醒系安全带"]];
    for (int i=0; i<4; i++) {
        for (int j=0; j<2; j++) {
            UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(XMAKENEW(50)+XMAKENEW(155)*j, XMAKENEW(37)*i, XMAKENEW(120), XMAKENEW(27))];
            btn.layer.cornerRadius = 2.0;//2.0是圆角的弧度，根据需求自己更改
            [btn.layer setBorderColor:COLOR_TEXT_LIGHT.CGColor];
            btn.layer.borderWidth = 1.0f;//设置边框颜色
            [btn setTitle:btnName[i][j] forState:UIControlStateNormal];
            [btn setTitleColor:COLOR_ORANGE forState:UIControlStateSelected];
            [btn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:FONT12];
//            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
//            [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height+XMAKENEW(17) ,-btn.imageView.frame.size.width-XMAKENEW(8), 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
//            [btn setImageEdgeInsets:UIEdgeInsetsMake(-XMAKENEW(17), 0.0,0.0, -btn.titleLabel.bounds.size.width-XMAKENEW(8))];//图片距离右边框距离减少图片的宽度，其它不边
//            [btn setImage:[UIImage imageNamed:[btnName[i] objectForKey:@"image"]]  forState:UIControlStateNormal];
//            [btn setImage:[UIImage imageNamed:[btnName[i] objectForKey:@"selectImage"]]  forState:UIControlStateSelected];
//            btn.adjustsImageWhenHighlighted = NO;
            btn.tag = 230+i;
            [btn addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
            [longView addSubview:btn];
        }
    }
}
- (void)cgreateShortView {
    shortView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(longView.frame), self.frame.size.width, XMAKENEW(100))];
    [self addSubview:shortView];
    NSArray *btnName = @[@[@"准时专业",@"拾金不昧"],@[@"服务好态度棒",@"车内整洁"],@[@"活地图认路准",@"等候耐心"]];
    for (int i=0; i<3; i++) {
        for (int j=0; j<2; j++) {
            UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(XMAKENEW(50)+XMAKENEW(155)*j, XMAKENEW(37)*i, XMAKENEW(120), XMAKENEW(27))];
            [btn setTitle:btnName[i][j] forState:UIControlStateNormal];
            [btn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
            [btn setTitleColor:COLOR_ORANGE forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:FONT12];
            btn.layer.cornerRadius = 2.0;//2.0是圆角的弧度，根据需求自己更改
            [btn.layer setBorderColor:COLOR_TEXT_LIGHT.CGColor];
            btn.layer.borderWidth = 1.0f;//设置边框颜色
            btn.adjustsImageWhenHighlighted = NO;
            btn.tag = 330+i;
            [btn addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
            [shortView addSubview:btn];
        }
    }
    shortView.hidden = YES;
}
- (void)btnSelected:(UIButton *)button {
    UIButton *btn = [self viewWithTag:990];
    UIButton *bestBtn = [self viewWithTag:994];
    if (!btn.selected) {
        labeb.textColor = [UIColor redColor];
        return;
    }
    button.selected = !button.selected;
    if (button.selected) {
        [button.layer setBorderColor:COLOR_ORANGE.CGColor];
        if (button.tag > 300) {
            _bestString = [NSString stringWithFormat:@"%@%@,",_bestString,button.titleLabel.text];
        } else {
            _btnStings = [NSString stringWithFormat:@"%@%@,",_btnStings,button.titleLabel.text];
        }
    } else {
        [button.layer setBorderColor:COLOR_TEXT_LIGHT.CGColor];
        if (button.tag > 300) {
            _bestString = [_bestString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,", button.titleLabel.text] withString:@""];
        } else {
            _btnStings = [_btnStings stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@,", button.titleLabel.text] withString:@""];
        }
    }
    if (bestBtn.selected) {
        self.block(_bestString);
    } else {
        self.block(_btnStings);
    }
}
- (void)setBtnSelected:(UIButton *)button {
    self.block([NSString stringWithFormat:@"%ld",button.tag-990]);
    NSArray *labelText = @[@"非常不满意，各方面都差",@"不满意，比较差",@"一般，仍需改善",@"比较满意，再接再厉",@"非常满意，无可挑剔"];
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [self viewWithTag:990+i];
        if (button.tag >= btn.tag) {
            btn.selected = YES;
            labeb.text = labelText[i];
        } else {
            btn.selected = NO;
        }
    }
    labeb.textColor = COLOR_ORANGE;
    if (button.tag == 994 && selecteBtnTag!=994) {
        longView.hidden = YES;
        shortView.hidden = NO;
        self.block(_bestString);
    } else if (selecteBtnTag==994&&button.tag!=994) {
        longView.hidden = NO;
        shortView.hidden = YES;
        self.block(_btnStings);
    } else {
        self.block(_btnStings);
    }
    selecteBtnTag = button.tag;
}
@end
