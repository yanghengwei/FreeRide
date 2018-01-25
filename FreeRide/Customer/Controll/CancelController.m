//
//  CancelController.m
//  FreeRide
//
//  Created by  on 2017/12/5.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "CancelController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "FRCancelTableViewCell.h"

@interface CancelController () <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
{
    UITextView *textView;
    UILabel *placeholderlab;
    UITapGestureRecognizer *tap;
}
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CancelController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNoticeForKeyboard];
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"订单详情" andRightTitle:@""];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"FRCancelTableViewCell" bundle:nil] forCellReuseIdentifier:@"FRCancelTableViewCell"];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(15), self.view.frame.size.height-XMAKENEW(60), SCREEN_WIDTH-2*XMAKENEW(15), YMAKENEW(40))];
    [loginBtn setTitle:@"提交" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(tagerLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = COLOR_ORANGE;
    loginBtn.layer.cornerRadius = 3.0;//2.0是圆角的弧度，根据需求自己更改
    loginBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    loginBtn.layer.borderWidth = 0.5f;//设置边框颜色
    [self.view addSubview:loginBtn];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self dataSource];
    [_tableView reloadData];
}
- (void)tagerLoginBtn {
    NSLog(@"点击提交");
}
- (void)pushNextView:(NSString *)info {
        [self.navigationController popViewControllerAnimated:YES];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 72, SCREEN_WIDTH, self.view.frame.size.height-72) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = [self setTableViewHeadView];
        _tableView.tableFooterView = [self setTableViewFootView];
        self.tableView.scrollEnabled =NO; //设置tableview 不能滚动
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 12)];
            [self.tableView setSeparatorColor:COLOR_background];
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        [_dataSource addObjectsFromArray:@[@"我的行程改变了，暂时不需要用车",@"我需要等待的时间太长",@"司机找不到上车地点",@"司机服务态度恶劣",@"司机迟到",@"司机各种理由不来接我",@"其他"]];
    }
    return _dataSource;
}
- (UIView *)setTableViewHeadView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, XMAKENEW(60))];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, XMAKENEW(5), SCREEN_WIDTH, XMAKENEW(30))];
    titleLabel.text = @"您的行程已取消，请告诉我们原因";
    titleLabel.textColor = COLOR_TEXT_DARK;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)-XMAKENEW(5), SCREEN_WIDTH, XMAKENEW(25))];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.text = @"我们会努力改进，为您提供更好的服务";
    detailLabel.textColor = COLOR_ORANGE;
    detailLabel.font = [UIFont systemFontOfSize:FONT12];
    [headView addSubview:detailLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, headView.frame.size.height-1, SCREEN_WIDTH, 1)];
    line.backgroundColor = COLOR_background;
    [headView addSubview:line];
    return headView;
}
- (UIView *)setTableViewFootView {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, XMAKENEW(100))];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(XMAKENEW(12), 0, SCREEN_WIDTH-XMAKENEW(24), footView.frame.size.height)];
    textView.delegate =self;
    textView.backgroundColor = COLOR_background;
    textView.hidden = YES;
    [footView addSubview:textView];
    
    placeholderlab=[[UILabel alloc]initWithFrame:CGRectMake(8, 3, SCREEN_WIDTH, 20)];
    placeholderlab.text=@"请输入您要对司机说的话";
    placeholderlab.textColor=COLOR_TEXT_LIGHT;
    placeholderlab.textAlignment=NSTextAlignmentLeft;
    placeholderlab.font=[UIFont systemFontOfSize:13.0f];
    [textView addSubview:placeholderlab];
    
    return footView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FRCancelTableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"FRCancelTableViewCell"];
    if (!cell) {
        cell = [[FRCancelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FRCancelTableViewCell"];
    }
    cell.titleLabel.text = _dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 6) {
        textView.hidden = NO;
    } else {
        textView.hidden = YES;
    }
}
#pragma mark  textView

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    placeholderlab.hidden=YES;
    NSLog(@"开始");
    if (!tap) {
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelKeybord:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_tableView addGestureRecognizer:tap];
    }
    tap.enabled = YES;
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
        }else{
            // 有高亮选择的字符串，暂不对文字进行统计和限制
        }
    }else{
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        if (toBeString.length > 80) {
            textView.text = [toBeString substringToIndex:80];
            
        }
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
    tap.enabled = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    CGFloat offset = (textView.frame.origin.y+textView.frame.size.height+500) - (self.view.frame.size.height - kbHeight);
    
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //将视图上移计算好的偏移
    if(offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            self.tableView.contentOffset = CGPointMake(0, offset);
        }];
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{
        self.tableView.contentOffset = CGPointMake(0, 0);
    }];
}

@end
