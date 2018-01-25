//
//  CommentsController.m
//  FreeRide
//
//  Created by  on 2017/11/30.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "CommentsController.h"
#import "Header.h"
#import "PersonalNaviView.h"

@interface CommentsController () <UITextViewDelegate>
{
    UITextView *textView;
    UILabel *placeholderlab;
    UILabel *lastLabel;
}
@end

@implementation CommentsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_background;
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"行程备注" andRightTitle:@""];
    navi.block = ^(NSString *backInfo){
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self createTextView];
    [self createBtnFrame];
}
- (void)createTextView {
    textView = [[UITextView alloc] initWithFrame:CGRectMake(XMAKENEW(15), 68+XMAKENEW(10), SCREEN_WIDTH-XMAKENEW(30), XMAKENEW(100))];
    
    textView.delegate=self;
    textView.font=[UIFont systemFontOfSize:13.0f];
    textView.backgroundColor = COLOR_background;
    textView.layer.borderColor = COLOR_TEXT_LIGHT.CGColor;
    textView.layer.borderWidth = 1;
    textView.layer.cornerRadius = 2.0;
    [self.view addSubview:textView];
    
    placeholderlab=[[UILabel alloc]initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH, 20)];
    placeholderlab.text=@"请输入您要对司机说的话";
    placeholderlab.textColor=COLOR_TEXT_LIGHT;
    placeholderlab.textAlignment=NSTextAlignmentLeft;
    placeholderlab.font=[UIFont systemFontOfSize:13.0f];
    [textView addSubview:placeholderlab];
    
    if (_selectInfo.length>0) {
        textView.text = _selectInfo;
        placeholderlab.hidden = YES;
    }
    
    lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(textView.frame.size.width-XMAKENEW(80), CGRectGetMaxY(textView.frame)-XMAKENEW(25), XMAKENEW(80), XMAKENEW(25))];
    lastLabel.text = [NSString stringWithFormat:@"%lu/80",(unsigned long)textView.text.length];
    lastLabel.textColor = COLOR_TEXT_LIGHT;
    lastLabel.font = [UIFont systemFontOfSize:FONT12];
    lastLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:lastLabel];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(textView.frame), self.view.frame.size.height-XMAKENEW(65), SCREEN_WIDTH-2*CGRectGetMinX(textView.frame), YMAKENEW(40))];
    [loginBtn setTitle:@"提交" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(tagerLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = COLOR_ORANGE;
    loginBtn.layer.cornerRadius = 3.0;//2.0是圆角的弧度，根据需求自己更改
    loginBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    loginBtn.layer.borderWidth = 0.5f;//设置边框颜色
    [self.view addSubview:loginBtn];
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
    [self changeBtnSelect];
    // 键盘输入模式，此方法在官方不建议使用 可以用[[UIApplication sharedApplication]textInputMode].primaryLanguage代替
    NSString *lang = [[[UIApplication sharedApplication]textInputMode] primaryLanguage];
    NSLog(@"%@",lang);
    NSString *toBeString = textView.text;//操作之后的
    //    toBeString = [toBeString stringByReplacingOccurrencesOfString:@" " withString:@""];//去处空格
    if ([lang isEqualToString:@"zh-Hans"]) {
        // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取输入文字中的高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {//高亮部分不存在则直接统计文字
            if (toBeString.length > 80) {
                textView.text = [toBeString substringToIndex:80];
            }
            lastLabel.text=[NSString stringWithFormat:@"%d/80",(int)textView.text.length];
        }else{
            // 有高亮选择的字符串，暂不对文字进行统计和限制
        }
    }else{
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > 80) {
            textView.text = [toBeString substringToIndex:80];
            
        }
        lastLabel.text=[NSString stringWithFormat:@"%d/80",(int)textView.text.length];
    }
    
}
-(BOOL)textViewShouldReturn:(UITextView *)textView{
    [textView resignFirstResponder];
    return YES;
}

//收回键盘的点击手势
- (void)cancelKeybord:(UITapGestureRecognizer*)tap
{
    [textView resignFirstResponder];
}
- (void)tagerLoginBtn {
    self.pickBlock(textView.text);
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"点击提交");
}
- (void)pushNextView:(NSString *)info {
    if ([info isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)changeBtnSelect {
    NSArray *arr = @[@"有小孩，请照顾、",@"有老人，请照顾、",@"着急走，赶火车、",@"车内不抽烟，不进食、",@"有行李，需要后备箱、",@"只限同性乘车、",@"带萌宠，会管好的、",@"着急走，赶火车、",@"有点累，需要休息、",@"需中途上下人、"];
    for (int i = 0; i < arr.count; i++) {
        UIButton *button = [self.view viewWithTag:1000+i];
        if ([textView.text containsString:arr[i]]) {
            button.selected = YES;
            [button.layer setBorderColor:COLOR_ORANGE.CGColor];
        } else {
            button.selected = NO;
            [button.layer setBorderColor:COLOR_TEXT_LIGHT.CGColor];
        }
    }
}
- (void)createBtnFrame {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(12), XMAKENEW(200), XMAKENEW(6), XMAKENEW(6))];
    imageView.image = [UIImage imageNamed:@"asterisk"];
    [self.view addSubview:imageView];
    UILabel *subInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+XMAKENEW(3), XMAKENEW(188), SCREEN_WIDTH, XMAKENEW(30))];
    subInfoLabel.text = @"可选留言";
    subInfoLabel.textColor = COLOR_TEXT_NORMAL;
    subInfoLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:subInfoLabel];
    
    NSArray *arr = @[@"有小孩，请照顾、",@"有老人，请照顾、",@"着急走，赶火车、",@"车内不抽烟，不进食、",@"有行李，需要后备箱、",@"只限同性乘车、",@"带萌宠，会管好的、",@"着急走，赶火车、",@"有点累，需要休息、",@"需中途上下人、"];
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    CGFloat h = XMAKENEW(220);//用来控制button距离父视图的高
    for (int i = 0; i < arr.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = 1000 + i;
        [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:COLOR_ORANGE forState:UIControlStateSelected];
        [button setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
        //设置圆角的半径
        [button.layer setCornerRadius:3];
        //切割超出圆角范围的子视图
        button.layer.masksToBounds = YES;
        //设置边框的颜色
        [button.layer setBorderColor:COLOR_TEXT_LIGHT.CGColor];
        //设置边框的粗细
        [button.layer setBorderWidth:1.0];
        //根据计算文字的大小
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        CGFloat length = [arr[i] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //为button赋值
        [button setTitle:arr[i] forState:UIControlStateNormal];
        //设置button的frame
        button.frame = CGRectMake(10 + w, h, length + 15 , 30);
        //当button的位置超出屏幕边缘时换行 SCREEN_WIDTH 只是button所在父视图的宽度
        if(10 + w + length + 15 > SCREEN_WIDTH){
            w = 0; //换行时将w置为0
            h = h + button.frame.size.height + 10;//距离父视图也变化
            button.frame = CGRectMake(10 + w, h, length + 15, 30);//重设button的frame
        }
        w = button.frame.size.width + button.frame.origin.x;
        if ([_selectInfo containsString:arr[i]]) {
            button.selected = YES;
            [button.layer setBorderColor:COLOR_ORANGE.CGColor];
        }
        [self.view addSubview:button];
    }
}
//点击事件
- (void)handleClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [btn.layer setBorderColor:COLOR_ORANGE.CGColor];
        textView.text = [NSString stringWithFormat:@"%@%@",textView.text, btn.titleLabel.text];
    } else {
        [btn.layer setBorderColor:COLOR_TEXT_LIGHT.CGColor];
        textView.text = [textView.text stringByReplacingOccurrencesOfString:btn.titleLabel.text withString:@""];
    }
    if (textView.text.length > 80) {
        textView.text = [textView.text substringToIndex:80];
    }
    lastLabel.text=[NSString stringWithFormat:@"%d/80",(int)textView.text.length];
    if ([textView.text isEqualToString:@""]) {
        placeholderlab.hidden = NO;
    } else {
        placeholderlab.hidden = YES;
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
