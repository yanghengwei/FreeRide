//
//  EvaluationChooseView.m
//  FreeRide
//
//  Created by  on 2017/12/7.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "EvaluationChooseView.h"
#import "EvaluationView.h"
#import "Header.h"

@interface EvaluationChooseView () <UITextViewDelegate>
{
    EvaluationView *evaView;
    UIView *mainView;
    UIView *footView;
    UIView *headView;
    UIView *blackView;
    UITextView *textView;
    UILabel *placeholderlab;
    UIButton *rightBtn;
}
@property (nonatomic, strong) NSMutableDictionary *upDic;
@end

@implementation EvaluationChooseView

- (instancetype)initWithFrame:(CGRect)frame andData:(NSDictionary *)data {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI:data];
        [self addNoticeForKeyboard];
    }
    return self;
}
- (void)createUI:(NSDictionary *)data {
    _upDic = [[NSMutableDictionary alloc] initWithDictionary:data];
    blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.7;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTapToCityDetail:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [blackView addGestureRecognizer:tap];
    [self addSubview:blackView];
    
    mainView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, XMAKENEW(439))];
    mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:mainView];
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainView.frame.size.width, XMAKENEW(44))];
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, XMAKENEW(2), XMAKENEW(60), XMAKENEW(40))];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:FONT12];
    [leftBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    leftBtn.tag = 1314;
    [leftBtn addTarget:self action:@selector(btnTarget:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:leftBtn];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(leftBtn.frame), headView.frame.size.width, XMAKENEW(40))];
    titleLabel.text = @"评价";
    titleLabel.textColor = COLOR_TEXT_DARK;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:titleLabel];
    [mainView addSubview:headView];
    
    rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(315), CGRectGetMinY(leftBtn.frame), XMAKENEW(60), XMAKENEW(40))];
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:FONT12];
    [rightBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    rightBtn.tag = 1413;
    [rightBtn addTarget:self action:@selector(btnTarget:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:rightBtn];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, headView.frame.size.height-1, self.frame.size.width, 1)];
    line.backgroundColor = COLOR_background;
    [headView addSubview:line];
    
    NSString *string;
    if ([data objectForKey:@"buttonString"]) {
        string = [data objectForKey:@"buttonString"];
    } else {
        string = @"";
    }
    evaView= [[EvaluationView alloc] initWithFrame:CGRectMake(0, headView.frame.size.height, headView.frame.size.width, XMAKENEW(220)) andString:string];
    __weak typeof(self) weakSelf = self;
    evaView.block = ^(NSString *backInfo) {
        [weakSelf changeView:backInfo];
        [weakSelf cancelKeybord:nil];
    };
    [mainView addSubview:evaView];
    
    footView = [[UIView alloc] initWithFrame:CGRectMake(0, headView.frame.size.height+evaView.frame.size.height, headView.frame.size.width, XMAKENEW(155))];
    [mainView addSubview:footView];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(XMAKENEW(50), XMAKENEW(10), XMAKENEW(275), XMAKENEW(70))];
    textView.backgroundColor = COLOR_background;
    textView.delegate = self;
    placeholderlab=[[UILabel alloc]initWithFrame:CGRectMake(XMAKENEW(5), 5, self.frame.size.width, 20)];
    placeholderlab.text=@"其他意见或建议（您的评论将匿名提交）";
    placeholderlab.textColor=COLOR_TEXT_LIGHT;
    placeholderlab.textAlignment=NSTextAlignmentLeft;
    placeholderlab.font=[UIFont systemFontOfSize:12];
    [textView addSubview:placeholderlab];
    [footView addSubview:textView];
    
    UIView *footHelpView = [[UIView alloc] initWithFrame:CGRectMake(XMAKENEW(150), CGRectGetMaxY(textView.frame), XMAKENEW(75), XMAKENEW(75))];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(customerervice:)];
    [footHelpView addGestureRecognizer:tap1];
    [footView addSubview:footHelpView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(20), XMAKENEW(15), XMAKENEW(35), XMAKENEW(35))];
    imageView.image = [UIImage imageNamed:@"customerservice"];
    [footHelpView addSubview:imageView];
    
    UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), footHelpView.frame.size.width, XMAKENEW(25))];
    footLabel.textColor = COLOR_TEXT_NORMAL;
    footLabel.text = @"需要帮助";
    footLabel.font = [UIFont systemFontOfSize:FONT12];
    footLabel.textAlignment = NSTextAlignmentCenter;
    [footHelpView addSubview:footLabel];
    if ([data objectForKey:@"buttonString"]) {
        rightBtn.hidden = YES;
        evaView.userInteractionEnabled = NO;
        textView.userInteractionEnabled = NO;
        placeholderlab.hidden = YES;
    }
    if ([data objectForKey:@"opinion"]) {
        textView.text = [data objectForKey:@"opinion"];
    }
    [UIView animateWithDuration:0.3 animations:^{
        if ([[[data objectForKey:@"buttonString"] substringToIndex:3] isEqualToString:@"994"]) {
            evaView.frame = CGRectMake(0, headView.frame.size.height, headView.frame.size.width, XMAKENEW(190));
        }
        footView.frame = CGRectMake(0, headView.frame.size.height+evaView.frame.size.height, headView.frame.size.width, XMAKENEW(175));
        mainView.frame = CGRectMake(0, self.frame.size.height-(headView.frame.size.height+evaView.frame.size.height+footView.frame.size.height), self.frame.size.width, headView.frame.size.height+evaView.frame.size.height+footView.frame.size.height);
    }];
}
- (void)customerervice:(UITapGestureRecognizer*)tap {
    UIWebView * callWebview = [[UIWebView alloc]init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:96508"]]];
    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
}
- (void)btnTarget:(UIButton *)button {
    if (button.tag == 1314) {
        [self chooseTapToCityDetail:nil];
    } else {
        if ([button.titleLabel.textColor isEqual:COLOR_ORANGE]) {
            NSLog(@"提交");
            [_upDic setObject:textView.text forKey:@"opinion"];
            self.blockInfo(_upDic);
            [self chooseTapToCityDetail:nil];
        }
    }
}
- (void)changeView:(NSString *)backInfo {
    [rightBtn setTitleColor:COLOR_ORANGE forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        if ([[backInfo substringToIndex:3] isEqualToString:@"994"]) {
            evaView.frame = CGRectMake(0, headView.frame.size.height, headView.frame.size.width, XMAKENEW(190));
        } else/* if (backInfo.length == 1)*/{
            evaView.frame = CGRectMake(0, headView.frame.size.height, headView.frame.size.width, XMAKENEW(220));
//        } else {
//            NSLog(@"%@",backInfo);
        }
        [_upDic setObject:backInfo forKey:@"buttonString"];
        footView.frame = CGRectMake(0, headView.frame.size.height+evaView.frame.size.height, headView.frame.size.width, XMAKENEW(175));
        mainView.frame = CGRectMake(0, self.frame.size.height-(headView.frame.size.height+evaView.frame.size.height+footView.frame.size.height), self.frame.size.width, headView.frame.size.height+evaView.frame.size.height+footView.frame.size.height);
    }];
}
- (void)chooseTapToCityDetail:(UITapGestureRecognizer*)tap {
    [UIView animateWithDuration:0.3 animations:^{
        mainView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, XMAKENEW(439));
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
-(BOOL)textViewShouldReturn:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

//收回键盘的点击手势
- (void)cancelKeybord:(UITapGestureRecognizer*)tap
{
    [textView resignFirstResponder];
    tap.enabled = NO;
}

#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    //获取键盘高度，在不同设备上，以及中英文下是不同的
    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    //计算出键盘顶端到inputTextView panel底端的距离(加上自定义的缓冲距离INTERVAL_KEYBOARD)
    CGFloat offset = (textView.frame.origin.y+textView.frame.size.height+500) - (self.frame.size.height - kbHeight);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.frame = CGRectMake(0, -offset, self.frame.size.width, self.frame.size.height);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    placeholderlab.hidden=YES;
    NSLog(@"开始");
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelKeybord:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"结束");
    if (textView.text.length==0) {
        placeholderlab.hidden=NO;
    }
}
@end
