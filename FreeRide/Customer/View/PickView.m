//
//  PickView.m
//  FreeRide
//
//  Created by  on 2017/12/2.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "PickView.h"
#import "Header.h"

@interface PickView () <UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIView *whithView;
}
@property (strong, nonatomic)  UIPickerView *pickerView;


@end

@implementation PickView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self pickerData];
        [self setPickView];
    }
    return self;
}
- (NSArray *)pickerData {
    if (!_pickerData) {
        _pickerData = @[@"1人",@"2人",@"3人",@"4人",@"5人",@"6人"];
    }
    return _pickerData;
}
- (void)changePickSelected {
    for (int i = 0; i < _pickerData.count; i++) {
        if ([_selectInfo isEqualToString:_pickerData[i]]) {
            [_pickerView selectRow:i inComponent:0 animated:NO];
            break;
        }
    }
}
- (void)setPickView {
    UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backgroudView.backgroundColor = [UIColor blackColor];
    backgroudView.alpha = 0.7;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTapToCityDetail:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [backgroudView addGestureRecognizer:tap];
    [self addSubview:backgroudView];
    
    whithView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, XMAKENEW(260))];
    whithView.backgroundColor = [UIColor whiteColor];
    NSArray *btnInfoArr = @[@{@"title":@"取消",@"titleColor":@"COLOR_TEXT_NORMAL"},@{@"title":@"确定",@"titleColor":@"COLOR_ORANGE"}];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*XMAKENEW(300)+XMAKENEW(10), 10, XMAKENEW(50), XMAKENEW(25))];
        [button setTitle:[btnInfoArr[i] objectForKey:@"title"] forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
        } else {
            [button setTitleColor:COLOR_ORANGE forState:UIControlStateNormal];
        }
        button.tag = 990+i;
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [whithView addSubview:button];
    }
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, XMAKENEW(25))];
    _titleLabel.text = @"选择乘车人数";
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = COLOR_TEXT_DARK;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [whithView addSubview:_titleLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame)+10, self.frame.size.width, 1)];
    line.backgroundColor = COLOR_background;
    [whithView addSubview:line];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), line.frame.size.width, whithView.frame.size.height-20-_titleLabel.frame.size.height)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [whithView addSubview:_pickerView];
    [self addSubview:whithView];
    [UIView animateWithDuration:0.2 animations:^{
        whithView.frame = CGRectMake(0, self.frame.size.height-XMAKENEW(260), self.frame.size.width, XMAKENEW(260));
    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
    }];
}
#pragma mark - pickerView数据源协议方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1; //拨盘数量
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _pickerData.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}
#pragma mark - pickerView代理协议方法
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_pickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _selectInfo = [_pickerData objectAtIndex:row];
}
- (void)btnAction:(UIButton *)button {
    if (button.tag == 990) {
        NSLog(@"点击取消");
//        self.pickBlock(@"");
    } else {
        if (_selectInfo.length == 0) {
            _selectInfo = _pickerData[0];
        }
        self.pickBlock(_selectInfo);
    }
    [self chooseTapToCityDetail:nil];
}
- (void)chooseTapToCityDetail:(UITapGestureRecognizer*)tap {
    [UIView animateWithDuration:0.2 animations:^{
        whithView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
@end
