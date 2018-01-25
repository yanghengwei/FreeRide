//
//  AddBankCardController.m
//  FreeRide
//
//  Created by  on 2017/12/13.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "BankListController.h"
#import "Header.h"
#import "PersonalNaviView.h"

@interface BankListController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation BankListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_background;
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"支持银行列表" andRightTitle:@""];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self tableView];
    [self tableData];
    [_tableView reloadData];
}
- (void)pushNextView:(NSString *)info {
    [self.navigationController popViewControllerAnimated:YES];
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
        _dataSource = [[NSMutableArray alloc] initWithArray:@[@"借记卡",@"中国邮政储蓄银行",@"民生银行",@"中国工商银行",@"中国农业银行",@"中国建设银行",@"交通银行",@"光大银行"]];;
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
    cell.textLabel.text = _dataSource[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = COLOR_TEXT_DARK;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.row == 0) {
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.backgroundColor = COLOR_background;
        cell.textLabel.textColor = COLOR_TEXT_NORMAL;
    }
    return cell;
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
