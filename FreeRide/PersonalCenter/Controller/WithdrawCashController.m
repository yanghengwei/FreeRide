//
//  WithdrawCashController.m
//  FreeRide
//
//  Created by  on 2017/12/13.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "WithdrawCashController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "BankListController.h"
#import "PromptViewController.h"
#import "NetworkTool.h"
#import "UserDefaults.h"
#import "SomeSupprt.h"

@interface WithdrawCashController ()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
{
    NSInteger cellID;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation WithdrawCashController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"我的银行卡" andRightTitle:@""];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self tableView];
    [self tableData];
    [_tableView reloadData];
    [self createUI];
    [self createHeadView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getDataFromWeb];
}
- (void)getDataFromWeb {
    [[NetworkTool sharedTool] requestWithURLString:WEB_GETBANKCARD
                                        parameters:@{@"phone":[UserDefaults getValueForKey:@"phone"],
                                                     @"key":[UserDefaults getValueForKey:@"key"]}
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  [self setDataToTable:[responseObject objectForKey:@"data"]];
                                              } else {
                                                  [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.5];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
}
- (void)setDataToTable:(NSArray *)arr {
    NSString *string = _dataSource[0];
    [_dataSource removeAllObjects];
    [_dataSource addObject:string];
    [_dataSource addObjectsFromArray:arr];
    [_tableView reloadData];
}
- (void)createUI {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-XMAKENEW(60), SCREEN_WIDTH, XMAKENEW(60))];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    //登录
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(12.5), YMAKENEW(10), XMAKENEW(350), YMAKENEW(40))];
    [loginBtn setTitle:@"提现" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(tagerLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = COLOR_ORANGE;
    loginBtn.layer.cornerRadius = 3.0;//2.0是圆角的弧度，根据需求自己更改
    loginBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    loginBtn.layer.borderWidth = 0.5f;//设置边框颜色
    [footView addSubview:loginBtn];
}
- (void)tagerLoginBtn {
    UITextField *moneyTextField = [self.view viewWithTag:601];
    if (!cellID) {
        [SomeSupprt createUIAlertWithMessage:@"请选择提现账户" andDisappearTime:0.5];
        return;
    }
    if (moneyTextField.text.length == 0) {
        [SomeSupprt createUIAlertWithMessage:@"请输入提现金额" andDisappearTime:0.5];
        return;
    }
    if ([moneyTextField.text floatValue] > [_mostMoney floatValue]) {
        [SomeSupprt createUIAlertWithMessege:[NSString stringWithFormat:@"输入的提现金额超过最大可提现金额（¥%@）",_mostMoney] andTag:90987];
        return;
    }
    [self updateAndMoneyToWeb:@{@"phone":[UserDefaults getValueForKey:@"phone"],
                                @"key":[UserDefaults getValueForKey:@"key"],
                                @"withdrawalsMoney":moneyTextField.text,
                                @"withdrawalsBank":[_dataSource[cellID] objectForKey:@"id"]
                                }];
    NSLog(@"提现");
}
- (void)updateAndMoneyToWeb:(NSDictionary *)dic {
    [[NetworkTool sharedTool] requestWithURLString:WEB_POSTMONEYTOBANK
                                        parameters:dic
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  [self withdrawCashSuccess];
                                              } else {
                                                  [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.5];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
}
- (void)withdrawCashSuccess {
    UITextField *textField = [self.view viewWithTag:601];
    PromptViewController *vc = [[PromptViewController alloc] init];
    vc.promptStr = [NSString stringWithFormat:@"提现¥%@到%@操作成功",textField.text,[_dataSource[cellID] objectForKey:@"band_type"]];
    vc.detailPromptStr = @"根据银行的不同，2到24小时到账";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)pushNextView:(NSString *)info {
        [self.navigationController popViewControllerAnimated:YES];

}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68+XMAKENEW(70), SCREEN_WIDTH, self.view.frame.size.height-68-XMAKENEW(130)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = COLOR_background;
//        _tableView.tableHeaderView = [self createHeadView];
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 12)];
            [self.tableView setSeparatorColor:COLOR_background];
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (void)createHeadView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(12, 68, SCREEN_WIDTH, XMAKENEW(70))];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:headView.bounds];
    label.textColor = COLOR_TEXT_DARK;
    label.text = @"提现金额";
    label.font = [UIFont systemFontOfSize:20];
    [headView addSubview:label];
    
    UITextField *moneyTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, 0, SCREEN_WIDTH/2, headView.frame.size.height)];
    moneyTextField.placeholder = @"请输入提现金额";
    moneyTextField.font = [UIFont systemFontOfSize:20];
    moneyTextField.tag = 601;
    moneyTextField.keyboardType = UIKeyboardTypeNumberPad;
    moneyTextField.textAlignment = NSTextAlignmentRight;
    [headView addSubview:moneyTextField];
    [self.view addSubview:headView];
}
- (NSMutableArray *)tableData {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithArray:@[@"提现到银行卡"]];;
    }
    return _dataSource;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"myCell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = COLOR_TEXT_DARK;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.row == 0) {
        cell.textLabel.text = _dataSource[indexPath.row];
        cell.backgroundColor = COLOR_background;
        cell.textLabel.textColor = COLOR_TEXT_NORMAL;
        cell.detailTextLabel.text = @"支持银行100家";
        cell.detailTextLabel.textColor = [UIColor blueColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭
    } else {
        NSDictionary *dic = _dataSource[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (尾号%@)",[dic objectForKey:@"band_type"], [[dic objectForKey:@"band_card_no"] substringFromIndex:[[dic objectForKey:@"band_card_no"] length]-4]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BankListController *vc = [[BankListController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if (cellID) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellID inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.textColor = COLOR_TEXT_DARK;
        }
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = COLOR_ORANGE;
        cellID = indexPath.row;
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
