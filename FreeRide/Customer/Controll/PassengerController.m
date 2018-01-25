//
//  PassengerController.m
//  FreeRide
//
//  Created by  on 2017/12/4.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "PassengerController.h"
#import "Header.h"
#import "PersonalNaviView.h"

@interface PassengerController () <UITextFieldDelegate>
{
    PersonalNaviView *navi;
}
@end

@implementation PassengerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_background;
     navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"乘车人" andRightTitle:@"提交"];
    [navi.rightBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [weakSelf pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self createUI];
}
- (void)pushNextView:(NSString *)info {
    UITextField *textField1 = [self.view viewWithTag:4340];
    UITextField *textField2 = [self.view viewWithTag:4341];
    if ([info isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if ([navi.rightBtn.titleLabel.textColor isEqual:COLOR_ORANGE]) {
            self.pickBlock(@{@"name":textField1.text,@"phoneNum":textField2.text});
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"点击了右侧按钮但不可提交");
        }
    }
}
- (void)createUI {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 72, SCREEN_WIDTH, XMAKENEW(80))];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    NSArray *leftNameArr = @[@"姓名",@"手机号"];
    NSArray *textFieldPlaceArr = @[@"输入乘车人姓名",@"输入乘车人手机号"];
    NSArray *dicKeyArr = @[@"name",@"phoneNum"];
    for (int i = 0; i < 2; i++) {
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(12), i*XMAKENEW(40), SCREEN_WIDTH, XMAKENEW(40))];
        leftLabel.textColor = COLOR_TEXT_DARK;
        leftLabel.text = leftNameArr[i];
        leftLabel.font = [UIFont systemFontOfSize:13];
        [headView addSubview:leftLabel];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(XMAKENEW(80), CGRectGetMinY(leftLabel.frame), SCREEN_WIDTH-XMAKENEW(160), XMAKENEW(40))];
        textField.font = [UIFont systemFontOfSize:13];
        textField.textColor = COLOR_TEXT_DARK;
        textField.placeholder = textFieldPlaceArr[i];
        textField.tag = 4340+i;
        if (_selectInfo) {
            textField.text = [_selectInfo objectForKey:dicKeyArr[i]];
        }
        [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [headView addSubview:textField];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(leftLabel.frame), CGRectGetMaxY(leftLabel.frame), SCREEN_WIDTH-2*CGRectGetMinX(leftLabel.frame), 1)];
        line.backgroundColor = COLOR_background;
        [headView addSubview:line];
        
        if (i == 1) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-XMAKENEW(92), CGRectGetMinY(leftLabel.frame), XMAKENEW(80), leftLabel.frame.size.height)];
            [btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
            [btn setTitle:@"短信通知" forState:UIControlStateNormal];
            [btn setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateNormal];
            [btn setTitleColor:COLOR_TEXT_DARK forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(changeSelected:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:FONT12];
            btn.tag = 555;
            [headView addSubview:btn];
        }
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(140), XMAKENEW(30))];
    [button setTitle:@"设为常用乘车人" forState:UIControlStateNormal];
    [button setTitleColor:COLOR_TEXT_DARK forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed: @"unchecked"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed: @"Selected"] forState:UIControlStateSelected];
    //设置圆角的半径
    [button.layer setCornerRadius:2];
    //切割超出圆角范围的子视图
    button.layer.masksToBounds = YES;
    //设置边框的颜色
    [button.layer setBorderColor:COLOR_TEXT_LIGHT.CGColor];
    //设置边框的粗细
    [button.layer setBorderWidth:1.0];
    button.tag = 666;
    [button addTarget:self action:@selector(changeSelected:) forControlEvents:UIControlEventTouchUpInside];
    button.center = CGPointMake(SCREEN_WIDTH/2, CGRectGetMaxY(headView.frame)+XMAKENEW(35));
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:button];
}
- (void)changeSelected:(UIButton *)button {
    button.selected = !button.selected;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"开始");
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelKeybord:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    
}
- (void)cancelKeybord:(UITapGestureRecognizer*)tap
{
    UITextField *textField1 = [self.view viewWithTag:4340];
    UITextField *textField2 = [self.view viewWithTag:4341];
    [textField1 resignFirstResponder];
    [textField2 resignFirstResponder];
}
- (void)changeRightBtn {
    UITextField *textField1 = [self.view viewWithTag:4340];
    UITextField *textField2 = [self.view viewWithTag:4341];
    if (textField1.text.length>0 && textField2.text.length>0) {
        [navi.rightBtn setTitleColor:COLOR_ORANGE forState:UIControlStateNormal];
    } else {
        [navi.rightBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    }
}
- (void)textFieldChanged:(UITextField *)textField{
    [self changeRightBtn];
    // 键盘输入模式，此方法在官方不建议使用 可以用[[UIApplication sharedApplication]textInputMode].primaryLanguage代替
    NSString *lang = [[[UIApplication sharedApplication]textInputMode] primaryLanguage];
    NSLog(@"%@",lang);
    NSString *toBeString = textField.text;//操作之后的
    //    toBeString = [toBeString stringByReplacingOccurrencesOfString:@" " withString:@""];//去处空格
    if ([lang isEqualToString:@"zh-Hans"]) {
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取输入文字中的高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {//高亮部分不存在则直接统计文字
            if (toBeString.length > 80) {
                textField.text = [toBeString substringToIndex:80];
            }
        }else{
            // 有高亮选择的字符串，暂不对文字进行统计和限制
        }
    }else{
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > 80) {
            textField.text = [toBeString substringToIndex:80];
            
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
