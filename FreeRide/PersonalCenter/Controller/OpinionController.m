//
//  OpinionController.m
//  FreeRide
//
//  Created by pc on 2017/11/23.
//  Copyright © 2017年 JNR All rights reserved.
//  意见反馈

#import "OpinionController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "PromptViewController.h"
#import "NetworkTool.h"
#import "SomeSupprt.h"
#import "UserDefaults.h"

@interface OpinionController () <UITextViewDelegate>
{
    UITextView *textView;
    UILabel *placeholderlab;
    UILabel *lastLabel;
}
@end

@implementation OpinionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"意见反馈" andRightTitle:@""];
    [navi.rightBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    self.view.backgroundColor = COLOR_background;
    [self creatUI];
}
- (void)pushNextView:(NSString *)info {
    if ([info isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"点击了右侧按钮");
    }
}
- (void)creatUI {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(15), 68, SCREEN_WIDTH, XMAKENEW(25))];
    titleLabel.text = @"您宝贵的意见，就是我们进步的源泉";
    titleLabel.textColor = COLOR_TEXT_NORMAL;
    titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:titleLabel];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), SCREEN_WIDTH, XMAKENEW(120))];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), XMAKENEW(5), SCREEN_WIDTH-2*CGRectGetMinX(titleLabel.frame), whiteView.frame.size.height-XMAKENEW(10))];
    textView.delegate=self;
    textView.font=[UIFont systemFontOfSize:13.0f];
    [whiteView addSubview:textView];
    
    lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(textView.frame.size.width-XMAKENEW(80), CGRectGetMaxY(textView.frame)-XMAKENEW(25), XMAKENEW(80), XMAKENEW(25))];
    lastLabel.text = @"0/200";
    lastLabel.textAlignment = NSTextAlignmentRight;
    lastLabel.textColor = COLOR_TEXT_LIGHT;
    [textView addSubview:lastLabel];
    
    placeholderlab=[[UILabel alloc]initWithFrame:CGRectMake(XMAKENEW(0), 5, SCREEN_WIDTH, 20)];
    placeholderlab.text=@"有什么想说的，尽管咆哮吧";
    placeholderlab.textColor=COLOR_TEXT_LIGHT;
    placeholderlab.textAlignment=NSTextAlignmentLeft;
    placeholderlab.font=[UIFont systemFontOfSize:13.0f];
    [textView addSubview:placeholderlab];
    
    
    UILabel *footTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(whiteView.frame), SCREEN_WIDTH, titleLabel.frame.size.height)];
    footTextLabel.text = @"请详细描述您的问题，有助于我们快速定位并解决问题";
    footTextLabel.textColor = COLOR_TEXT_NORMAL;
    footTextLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:footTextLabel];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(footTextLabel.frame)+YMAKENEW(80), SCREEN_WIDTH-2*CGRectGetMinX(titleLabel.frame), YMAKENEW(40))];
    [loginBtn setTitle:@"提交" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(tagerLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = COLOR_ORANGE;
    loginBtn.layer.cornerRadius = 3.0;//2.0是圆角的弧度，根据需求自己更改
    loginBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    loginBtn.layer.borderWidth = 0.5f;//设置边框颜色
    [self.view addSubview:loginBtn];
}
- (void)tagerLoginBtn {
    if (textView.text.length == 0) {
        [SomeSupprt createUIAlertWithMessage:@"请输入意见" andDisappearTime:0.5];
        return;
    }
    [self opinionNet:textView.text];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  textView

- (void)textViewDidBeginEditing:(UITextView *)textView{

    placeholderlab.hidden=YES;
    NSLog(@"开始");
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelKeybord:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tap];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"结束");
    if (textView.text.length==0) {
        placeholderlab.hidden=NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    // 键盘输入模式，此方法在官方不建议使用 可以用[[UIApplication sharedApplication]textInputMode].primaryLanguage代替
    NSString *lang = [[[UIApplication sharedApplication]textInputMode] primaryLanguage];
    NSLog(@"%@",lang);
    NSString *toBeString = textView.text;//操作之后的
    toBeString = [toBeString stringByReplacingOccurrencesOfString:@" " withString:@""];

//        toBeString = [toBeString stringByReplacingOccurrencesOfString:@" " withString:@""];//去处空格
    if ([lang isEqualToString:@"zh-Hans"]) {
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取输入文字中的高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {//高亮部分不存在则直接统计文字
            if (toBeString.length > 200) {
                toBeString = [toBeString substringToIndex:200];
            }
            lastLabel.text=[NSString stringWithFormat:@"%d/200",(int)textView.text.length];
        }else{
            // 有高亮选择的字符串，暂不对文字进行统计和限制
        }
    }else{
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > 200) {
            toBeString = [toBeString substringToIndex:200];
            
        }
        lastLabel.text=[NSString stringWithFormat:@"%d/200",(int)textView.text.length];
    }
    textView.text = toBeString;
}
-(BOOL)textViewShouldReturn:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}
- (void)opinionNet:(NSString *)opinion {
    [[NetworkTool sharedTool] requestWithURLString:WEB_OPINION
                                        parameters:@{@"key":[UserDefaults getValueForKey:@"key"],
                                                     @"feedbackPeople":[UserDefaults getValueForKey:@"id"],
                                                     @"feedbackContent":opinion
                                                     }
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  PromptViewController *vc = [[PromptViewController alloc] init];
                                                  vc.promptStr = @"提交成功！";
                                                  [self.navigationController pushViewController:vc animated:YES];
                                              } else {
                                                  [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.5];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
}
//收回键盘的点击手势
- (void)cancelKeybord:(UITapGestureRecognizer*)tap
{
    [textView resignFirstResponder];
}
@end
