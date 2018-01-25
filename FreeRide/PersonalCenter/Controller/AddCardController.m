//
//  AddCardController.m
//  FreeRide
//
//  Created by  on 2017/12/13.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "AddCardController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "BankListController.h"
#import "TextFTableViewCell.h"
#import "BankCardInfo.h"
#import "UserDefaults.h"
#import "NetworkTool.h"
#import "SomeSupprt.h"

@interface AddCardController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    NSInteger cellID;
    NSArray*placeHold;
    UITapGestureRecognizer *tap;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *upDataArr;

@end

@implementation AddCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    _upDataArr = [[NSMutableArray alloc] initWithArray:@[@"",@"",@"",@""]];
    placeHold = @[@"",@"请输入银行卡号",@"",@"请输入持卡人姓名",@"请输入持卡人身份证号"];
    self.view.backgroundColor = [UIColor whiteColor];
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"添加银行卡" andRightTitle:@""];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self tableView];
    [self tableData];
    [_tableView reloadData];
    [self createUI];
    [self.tableView registerNib:[UINib nibWithNibName:@"TextFTableViewCell" bundle:nil] forCellReuseIdentifier:@"TextFTableViewCell"];
    tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goActionShow)];
    //    tap.numberOfTapsRequired = 1;
    //    tap.numberOfTouchesRequired = 1;
    tap.enabled = NO;
    [self.tableView addGestureRecognizer:tap];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeData];
}
- (void)changeData {
    if (_dataDic) {
        _upDataArr = [[NSMutableArray alloc] initWithArray:@[[_dataDic objectForKey:@"band_card_no"],[_dataDic objectForKey:@"band_type"],[_dataDic objectForKey:@"user_name"],[_dataDic objectForKey:@"card_no"]]];
        _tableView.userInteractionEnabled = NO;
    }
}
- (void)createUI {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-XMAKENEW(60), SCREEN_WIDTH, XMAKENEW(65))];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    //登录
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(12.5), YMAKENEW(14), XMAKENEW(350), YMAKENEW(35))];
    if (_dataDic) {
        [loginBtn setTitle:@"解绑" forState:UIControlStateNormal];
    } else {
        [loginBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
    [loginBtn addTarget:self action:@selector(tagerLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = COLOR_ORANGE;
    loginBtn.layer.cornerRadius = 3.0;//2.0是圆角的弧度，根据需求自己更改
    loginBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    loginBtn.layer.borderWidth = 0.5f;//设置边框颜色
    [footView addSubview:loginBtn];
}
- (void)tagerLoginBtn {
    if (_dataDic) {
        [self deleteDataNotiWeb:[_dataDic objectForKey:@"id"]];
    } else {
        [self cheakDataAndUp];
    }
}
- (void)deleteDataNotiWeb:(NSString *)str {
    [[NetworkTool sharedTool] requestWithURLString:WEB_DELETEBANKCARD
                                        parameters:@{@"key":[UserDefaults getValueForKey:@"key"],
                                                     @"id":str}
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  [self.navigationController popViewControllerAnimated:YES];
                                                  //                                                  [self setDataToTable:[responseObject objectForKey:@"data"]];
                                              } else {
                                                  [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.5];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
}
- (void)pushNextView:(NSString *)info {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, self.view.frame.size.height-68-XMAKENEW(60)) style:UITableViewStylePlain];
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
- (NSMutableArray *)tableData {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithArray:@[@"提现到银行卡",@"卡号",@"",@"姓名",@"身份证号"]];;
    }
    return _dataSource;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 30;
    }
    return 44;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 2) {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"myCell"];
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = _upDataArr[indexPath.row-1];
        } else {
            cell.textLabel.text = _dataSource[indexPath.row];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.backgroundColor = COLOR_background;
        cell.textLabel.textColor = COLOR_TEXT_DARK;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.textLabel.textColor = COLOR_TEXT_NORMAL;
            cell.detailTextLabel.text = @"支持银行100家";
            cell.detailTextLabel.textColor = [UIColor blueColor];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭
        }
        return cell;
    } else {
        TextFTableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"TextFTableViewCell"];
        if (!cell) {
            cell = [[TextFTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TextFTableViewCell"];
            
        }
        if (indexPath.row == 1) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 11, 20, 20)];
            [button setTitle:@"×" forState:UIControlStateNormal];
            [button setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
            [button addTarget:self action:@selector(cleanTextField) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:button];
//        } else if (indexPath.row == 3) {
//            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 11, 20, 20)];
//            [button setTitle:@"×" forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(cleanTextField) forControlEvents:UIControlEventTouchUpInside];
//            [cell addSubview:button];
        }
        cell.textField.tag = 600+indexPath.row;
        cell.textField.textAlignment = NSTextAlignmentLeft;
        cell.textField.placeholder = placeHold[indexPath.row];
        cell.textField.text = _upDataArr[indexPath.row-1];
        cell.textField.delegate = self;
        [cell.textField addTarget:self action:@selector(BankCardTextChange:) forControlEvents:UIControlEventEditingChanged];
        cell.label.text = _dataSource[indexPath.row];
        cell.label.font = [UIFont systemFontOfSize:13];
        cell.label.textColor = COLOR_TEXT_DARK;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    
}
- (void)cleanTextField {
    UITextField *textField = [self.view viewWithTag:601];
    textField.text = @"";
    [_upDataArr replaceObjectAtIndex:1 withObject:[BankCardInfo getBankName:textField.text]];
    NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:2 inSection:0]; //刷新第0段第2行
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        BankListController *vc = [[BankListController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)BankCardTextChange:(UITextField *)textField {
    if (textField.tag == 601) {
        [_upDataArr replaceObjectAtIndex:1 withObject:[BankCardInfo getBankName:textField.text]];
        NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:2 inSection:0]; //刷新第0段第2行
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [_upDataArr replaceObjectAtIndex:textField.tag-601 withObject:textField.text];
    tap.enabled = YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [_upDataArr replaceObjectAtIndex:textField.tag-601 withObject:textField.text];
}
- (void)goActionShow {
    UITextField *field1 = [self.view viewWithTag:601];
    UITextField *field2 = [self.view viewWithTag:603];
    UITextField *field3 = [self.view viewWithTag:604];
    [field1 resignFirstResponder];
    [field2 resignFirstResponder];
    [field3 resignFirstResponder];
    tap.enabled = NO;
}
- (void)cheakDataAndUp {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:[UserDefaults getValueForKey:@"phone"] forKey:@"phone"];
    [dic setObject:[UserDefaults getValueForKey:@"key"] forKey:@"key"];
    NSArray *keyArr = @[@"bandCardNo",@"bandType",@"userName",@"cardNo"];
    for (int i = 0; i < keyArr.count; i++) {
        if ([_upDataArr[i] length] == 0) {
            if (i == 1) {
                [SomeSupprt createUIAlertWithMessage:@"卡号有误或暂不支持" andDisappearTime:0.5];
            } else {
                [SomeSupprt createUIAlertWithMessage:@"请填写完整信息" andDisappearTime:0.5];
            }
            return;
        }
        [dic setObject:_upDataArr[i] forKey:keyArr[i]];
    }
    if ([_upDataArr[1] rangeOfString:@"信用卡"].location !=NSNotFound) {
        [SomeSupprt createUIAlertWithMessage:@"暂不支持信用卡" andDisappearTime:0.5];
        return;
    }
    [self getDataFromWeb:dic];
}
- (void)getDataFromWeb:(NSDictionary *)dic {
    [[NetworkTool sharedTool] requestWithURLString:WEB_POSTBANKCARD
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
