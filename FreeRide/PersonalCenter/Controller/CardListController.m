//
//  CardListController.m
//  FreeRide
//
//  Created by  on 2017/12/13.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "CardListController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "AddCardController.h"
#import "NetworkTool.h"
#import "UserDefaults.h"
#import "SomeSupprt.h"

@interface CardListController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation CardListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_background;
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"我的银行卡" andRightTitle:@"添加银行卡"];
    [navi.rightBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self tableView];
    [self tableData];
    [_tableView reloadData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getDataFromWeb];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"解绑";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self deleteDataNotiWeb:[_dataSource[indexPath.row] objectForKey:@"id"]];
    // 从数据源中删除
    [_dataSource removeObjectAtIndex:indexPath.row];
    // 从列表中删除
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
- (void)deleteDataNotiWeb:(NSString *)str {
    [[NetworkTool sharedTool] requestWithURLString:WEB_DELETEBANKCARD
                                        parameters:@{@"key":[UserDefaults getValueForKey:@"key"],
                                                     @"id":str}
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
//                                                  [self setDataToTable:[responseObject objectForKey:@"data"]];
                                              } else {
                                                  [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.5];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
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
- (void)pushNextView:(NSString *)info {
    if ([info isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        AddCardController *vc = [[AddCardController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, self.view.frame.size.height-68) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = COLOR_background;
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
        _dataSource = [[NSMutableArray alloc] initWithArray:@[@"借记卡"]];;
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
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myCell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor blueColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.row == 0) {
        cell.textLabel.text = _dataSource[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.backgroundColor = COLOR_background;
        cell.textLabel.textColor = COLOR_TEXT_NORMAL;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        NSDictionary *dic = _dataSource[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (尾号%@)",[dic objectForKey:@"band_type"], [[dic objectForKey:@"band_card_no"] substringFromIndex:[[dic objectForKey:@"band_card_no"] length]-4]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AddCardController *vc = [[AddCardController alloc] init];
    vc.dataDic = _dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
