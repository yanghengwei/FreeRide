//
//  InvoiceController.m
//  FreeRide
//
//  Created by pc on 2017/11/22.
//  Copyright © 2017年 JNR All rights reserved.
//  发票

#import "InvoiceController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "NetworkTool.h"
#import "SomeSupprt.h"
#import "UserDefaults.h"

@interface InvoiceController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    BOOL isScend;
    UITapGestureRecognizer *tap;
}
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *placeHold;
@property (nonatomic, strong) NSMutableArray *textInfo;
@end

@implementation InvoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    _invoiceDic = @{@"id":@"123",@"money":@"256"};
    // Do any additional setup after loading the view.
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"开具发票" andRightTitle:@"开票说明"];
    [navi.rightBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self tableView];
    isScend = YES;
    _placeHold = @[@"请输入发票抬头",@"请输入领取发票人名称",@"请输入领取发票人联系方式"];
    _textInfo = [[NSMutableArray alloc] initWithArray:@[@"",@"",@"",@""]];
    [self tableData];
}
- (void)pushNextView:(NSString *)info {
    if ([info isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"点击了右侧按钮");
    }
}
- (void)createUI {
    
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, self.view.frame.size.height-68) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        _tableView.tableHeaderView = [self createHeadView];
        _tableView.tableFooterView = [self creatFootView];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (UIView *)creatFootView {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, XMAKENEW(70))];
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(20), XMAKENEW(30), XMAKENEW(335), XMAKENEW(40))];
    [nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(tagerLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.backgroundColor = COLOR_ORANGE;
    nextBtn.layer.cornerRadius = 3.0;//2.0是圆角的弧度，根据需求自己更改
    nextBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    nextBtn.layer.borderWidth = 0.5f;//设置边框颜色
    [footView addSubview:nextBtn];
    return footView;
}
- (void)tagerLoginBtn {
    [self cheakDataAndSetDataToDic];
    NSLog(@"点击提交");
}
- (void)cheakDataAndSetDataToDic {
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:[UserDefaults getValueForKey:@"key"] forKey:@"key"];
    [dataDic setObject:[UserDefaults getValueForKey:@"phone"] forKey:@"phone"];
    [dataDic setObject:[_invoiceDic objectForKey:@"money"] forKey:@"revoiceMoney"];
    [dataDic setObject:[_invoiceDic objectForKey:@"id"] forKey:@"relationOrder"];

    UITextField *text1 = (UITextField*)[self.view viewWithTag:995];
    UITextField *text2 = (UITextField*)[self.view viewWithTag:996];
    UITextField *text3 = (UITextField*)[self.view viewWithTag:997];
    UITextField *text4 = (UITextField*)[self.view viewWithTag:998];
    if (_tableData.count == 9) {
        if (text1.text.length == 0) {
            [SomeSupprt createUIAlertWithMessage:@"请填写完整信息" andDisappearTime:0.5];
            return;
        }
        [dataDic setObject:WEB_POSTINVOICEMAC forKey:@"address"];
        [dataDic setObject:@"3" forKey:@"revoiceType"];
        [dataDic setObject:text1.text forKey:@"taxpayerIdent"];
    } else if ([_tableData[0] length] > 5) {
        if (text1.text.length == 0) {
            [SomeSupprt createUIAlertWithMessage:@"请填写完整信息" andDisappearTime:0.5];
            return;
        }
        [dataDic setObject:text1.text forKey:@"taxpayerIdent"];
        [dataDic setObject:WEB_POSTINVOICEELE forKey:@"address"];
        [dataDic setObject:@"1" forKey:@"revoiceType"];
        [dataDic setObject:text4.text forKey:@"email"];
    } else {
        [dataDic setObject:WEB_POSTINVOICEQUO forKey:@"address"];
        [dataDic setObject:@"2" forKey:@"revoiceType"];
    }
    if (text2.text.length == 0 || text3.text.length == 0 || text4.text.length == 0) {
        [SomeSupprt createUIAlertWithMessage:@"请填写完整信息" andDisappearTime:0.5];
        return;
    }
    [dataDic setObject:text2.text forKey:@"invoiceTitle"];
    [dataDic setObject:text3.text forKey:@"ticketBearer"];
    [dataDic setObject:text4.text forKey:@"vontactInfo"];
    [self netWorkToWeb:dataDic];
}
- (void)netWorkToWeb:(NSDictionary *)dic {
    [[NetworkTool sharedTool] requestWithURLString:[dic objectForKey:@"address"]
                                        parameters:dic
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  [SomeSupprt createUIAlertWithMessage:@"提交成功" andDisappearTime:0.5];
                                                  [self.navigationController popViewControllerAnimated:YES];
                                              } else {
                                                  [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.5];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
}
- (NSMutableArray *)tableData {
    if (!_tableData) {
        _tableData = [[NSMutableArray alloc] init];
        NSArray *arr = @[@"发票内容",@"服务费（机打发票）",@"服务费（定额发票）",@"发票金额",@"纳税人识别号",@"",@"发票抬头",@"领票人",@"联系方式"];
        [_tableData addObjectsFromArray:arr];
        [_tableView reloadData];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    return _tableData;
}
- (UIView *)createHeadView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, XMAKENEW(85))];
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(12), XMAKENEW(5), SCREEN_WIDTH, XMAKENEW(30))];
    titleLable.text = @"发票类型";
    titleLable.textColor = COLOR_TEXT_NORMAL;
    titleLable.font = [UIFont systemFontOfSize:13];
    [headView addSubview:titleLable];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLable.frame)+XMAKENEW(5), SCREEN_WIDTH, 1)];
    line.backgroundColor = COLOR_background;
    [headView addSubview:line];
    
    NSArray *arr = @[@"纸质发票",@"电子发票"];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(15)+XMAKENEW(120)*i, CGRectGetMaxY(line.frame)+XMAKENEW(8), XMAKENEW(100), XMAKENEW(30))];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        button.tag = 1104+i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button setTitleColor:COLOR_ORANGE forState:UIControlStateSelected];
        [button setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseInvoice:) forControlEvents:UIControlEventTouchUpInside];
        //设置圆角的半径
        [button.layer setCornerRadius:3];
        //切割超出圆角范围的子视图
        button.layer.masksToBounds = YES;
        //设置边框的颜色
        [button.layer setBorderColor:COLOR_TEXT_LIGHT.CGColor];
        //设置边框的粗细
        [button.layer setBorderWidth:1.0];
        [headView addSubview:button];
        if (i == 0) {
            button.selected = YES;
            [button.layer setBorderColor:COLOR_ORANGE.CGColor];
        }
    }
    UILabel *lines = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame)+XMAKENEW(46), SCREEN_WIDTH, 5)];
    lines.backgroundColor = COLOR_background;
    [headView addSubview:lines];
    return headView;
}
- (void)chooseInvoice:(UIButton *)button {
    UIButton *btn1 = [self.view viewWithTag:1104];
    UIButton *btn2 = [self.view viewWithTag:1105];
    if (button.tag == 1104 && !btn1.selected) {
        if (isScend) {
            [self changeTableDate:@"type1"];
        } else {
            [self changeTableDate:@"type2"];
        }
        btn1.selected = YES;
        [btn1.layer setBorderColor:COLOR_ORANGE.CGColor];
        btn2.selected = NO;
        [btn2.layer setBorderColor:COLOR_TEXT_LIGHT.CGColor];
    } else if (button.tag == 1105 && !btn2.selected) {
        [self changeTableDate:@"type3"];
        btn2.selected = YES;
        [btn2.layer setBorderColor:COLOR_ORANGE.CGColor];
        btn1.selected = NO;
        [btn1.layer setBorderColor:COLOR_TEXT_LIGHT.CGColor];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIButton *btn2 = [self.view viewWithTag:1105];
    NSString *type;
    if ((indexPath.row == 5 && _tableData.count == 9)||(indexPath.row == 3 && btn2.selected)) {
        type = @"taxTextField";
    } else if (indexPath.row > _tableData.count-4) {
        type = @"textField";
    } else {
        type = @"nomal";
    }
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:type];
    
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:type];
            if ((indexPath.row == 5 && _tableData.count == 9)||(indexPath.row == 3 && btn2.selected)) {
                UITextField *textField1 = [[UITextField alloc] initWithFrame:CGRectMake(XMAKENEW(12), 0, SCREEN_WIDTH-XMAKENEW(24), cell.frame.size.height)];
                textField1.placeholder = @"请输入纳税人识别号或者统一社会信用代码";
                [textField1 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
                textField1.tag = 990+indexPath.row;
                textField1.delegate =self;
                [cell addSubview:textField1];
            } else if ((indexPath.row > 5 && _tableData.count == 9)||(indexPath.row > 3 && _tableData.count == 7)) {
                UITextField *textField1 = [[UITextField alloc] initWithFrame:CGRectMake(XMAKENEW(100), 0, SCREEN_WIDTH-XMAKENEW(100), cell.frame.size.height)];
                if (_tableData.count == 9) {
                    textField1.placeholder = _placeHold[indexPath.row-6];
                } else {
                    textField1.placeholder = _placeHold[indexPath.row-4];
                }
                textField1.delegate =self;
                textField1.tag = 990+indexPath.row;
                [textField1 setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
                [cell addSubview:textField1];
            }
        }
    
        cell.textLabel.text = _tableData[indexPath.row];
        cell.textLabel.textColor = COLOR_TEXT_DARK;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        if (indexPath.row == 0) {
            cell.textLabel.textColor = COLOR_TEXT_NORMAL;
            cell.textLabel.font = [UIFont systemFontOfSize:13];
        }
        if ((indexPath.row == 1 || indexPath.row ==2)&&!btn2.selected) {
            if (isScend && indexPath.row == 1) {
                cell.imageView.image = [UIImage imageNamed:@"Selected"];
            } else if (!isScend && indexPath.row == 2) {
                cell.imageView.image = [UIImage imageNamed:@"Selected"];
            } else {
                cell.imageView.image = [UIImage imageNamed:@"Unchecked"];
            }
        } else {
            cell.imageView.image = [UIImage imageNamed:@""];
        }
    
        if ((indexPath.row == 3 && !btn2.selected)||(indexPath.row == 1 && btn2.selected)) {
            cell.detailTextLabel.text = @"¥256";
            cell.detailTextLabel.textColor = COLOR_ORANGE;
            cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
            //        } else if (<#expression#>) {
            
        } else {
            cell.detailTextLabel.text = @"";
        }
    
    
    //    cell.reloadBlock = ^(NSString *backInfo){
    //        NSLog(@"%@",backInfo);
    //        [self.tableView reloadData];
    //    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIButton *btn2 = [self.view viewWithTag:1105];
    if (indexPath.row == 1 && !isScend && !btn2.selected) {
        isScend = YES;
        [self changeTableDate:@"type1"];
    } else if (indexPath.row == 2 && isScend&& !btn2.selected) {
        [self changeTableDate:@"type2"];
        isScend = NO;
    }
}
- (void)changeTableDate:(NSString *)type {
    [_tableData removeAllObjects];
    NSArray *arr;
    UITextField *textField1 = [self.view viewWithTag:997];
    UITextField *textField2 = [self.view viewWithTag:998];
    textField1.placeholder = @"请输入领取发票人名称";
    textField2.placeholder = @"请输入领取发票人联系方式";
    if ([type isEqualToString:@"type1"]) {
        arr = @[@"发票内容",@"服务费（机打发票）",@"服务费（定额发票）",@"发票金额",@"纳税人识别号",@"",@"发票抬头",@"领票人",@"联系方式"];
    } else if ([type isEqualToString:@"type2"]) {
        arr = @[@"发票内容",@"服务费（机打发票）",@"服务费（定额发票）",@"发票金额",@"发票抬头",@"领票人",@"联系方式"];
    } else {
        arr = @[@"服务内容  服务费",@"发票金额",@"纳税人识别号",@"",@"发票抬头",@"收件人",@"电子邮箱"];
        textField1.placeholder = @"请输入收件人名称";
        textField2.placeholder = @"用于向你发送电子行程单";
    }
    [_tableData addObjectsFromArray:arr];
    [_tableView reloadData];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{//重写textField这个方法
    NSLog(@"开始编辑");
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y+textField.frame.size.height+216+50);
    NSLog(@"偏移高度为 --- %f",offset);
    if (offset<=0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{//重写textField这个方法
    NSLog(@"将要结束编辑");
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
    return YES;
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.tableView.contentInset = UIEdgeInsetsZero;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self cancelKeybord:tap];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!tap) {
        UIView *keybordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height-350)];
        keybordView.backgroundColor = [UIColor clearColor];
        keybordView.tag = 3378677;
        [self.view addSubview:keybordView];
        
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelKeybord:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [keybordView addGestureRecognizer:tap];
    }
}
//收回键盘的点击手势
- (void)cancelKeybord:(UITapGestureRecognizer*)tap
{
    NSLog(@"手势点击");
    UIView *keybordView = (UIView*)[self.view viewWithTag:3378677];
    UITextField *text1 = (UITextField*)[self.view viewWithTag:995];
    UITextField *text2 = (UITextField*)[self.view viewWithTag:996];
    UITextField *text3 = (UITextField*)[self.view viewWithTag:997];
    UITextField *text4 = (UITextField*)[self.view viewWithTag:998];
    [text1 resignFirstResponder];
    [text2 resignFirstResponder];
    [text3 resignFirstResponder];
    [text4 resignFirstResponder];
    
    [keybordView removeFromSuperview];
    keybordView = nil;
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
