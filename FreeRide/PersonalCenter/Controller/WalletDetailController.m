//
//  WalletDetailController.m
//  FreeRide
//
//  Created by pc on 2017/11/25.
//  Copyright © 2017年 JNR All rights reserved.
//  明细

#import "WalletDetailController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "WalletDetailedViewCell.h"
#import "NetworkTool.h"
#import "SomeSupprt.h"
#import "UserDefaults.h"
#import "WalletDetailedViewCell.h"
#import <MJRefresh.h>

@interface WalletDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation WalletDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"明细" andRightTitle:@""];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"WalletDetailedViewCell" bundle:nil] forCellReuseIdentifier:@"WalletDetailedViewCell"];
    [self tableData];
}
- (void)pushNextView:(NSString *)info {
    if ([info isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupRefresh];
}
- (void)downDataFromWeb {
    [[NetworkTool sharedTool] requestWithURLString:WEB_GETACCOUNTDETAIL
                                        parameters:@{@"key":[UserDefaults getValueForKey:@"key"],
                                                     @"phone":[UserDefaults getValueForKey:@"phone"],
                                                     @"pageNumber":[NSString stringWithFormat:@"%ld",(long)_currentPage]
                                                     }
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  [self cheakDataAndReload:[responseObject objectForKey:@"data"]];
                                              } else {
                                                  [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.5];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
}
- (void)cheakDataAndReload:(NSDictionary *)dic {
    if (self.currentPage > [[dic objectForKey:@"endPage"] integerValue]) {
        [self createFooterView];
        return;
    }
    if (self.currentPage == 1) {
        [_tableData removeAllObjects];
        self.tableView.tableFooterView = nil;
    }
    [_tableData addObjectsFromArray:[dic objectForKey:@"result"]];
    [self.tableView reloadData];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, self.view.frame.size.height-68) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_background;
        _tableView.tableFooterView = [[UIView alloc] init];
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 12)];
            [self.tableView setSeparatorColor:COLOR_background];
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}
- (NSMutableArray *)tableData {
    if (!_tableData) {
        _tableData = [NSMutableArray new];
    }
    return _tableData;
}- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WalletDetailedViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"WalletDetailedViewCell"];
    if (!cell) {
        cell = [[WalletDetailedViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"WalletDetailedViewCell"];
    }
    NSString *string = [[_tableData[indexPath.row] objectForKey:@"phone"] substringWithRange:NSMakeRange(3,4)];
    //字符串的替换
    cell.phoneLabel.text = [[_tableData[indexPath.row] objectForKey:@"phone"] stringByReplacingOccurrencesOfString:string withString:@"****"];
    cell.timeLabel.text = [_tableData[indexPath.row] objectForKey:@"create_date"];
    cell.moneyLabel.text = [_tableData[indexPath.row] objectForKey:@"money"];
    if ([[_tableData[indexPath.row] objectForKey:@"flag"] isEqualToString:@"1"]) {
        cell.typeLabel.text = @"提现";
    } else {
        cell.typeLabel.text = @"收入";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark -- 上拉/下拉刷新
//上下拉
//刷新页面
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}
- (void)headerRereshing
{
    self.currentPage = 1;
    [self downDataFromWeb];
    [self.tableView.mj_header endRefreshing];
}
- (void)footerRereshing
{
    self.currentPage ++;
    [self downDataFromWeb];
    [self.tableView.mj_footer endRefreshing];
}

-(void)createFooterView
{
    UILabel *foot = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 375, 50)];
    foot.text  = @"没有更多内容了!";
    foot.textColor = COLOR_TEXT_NORMAL;
    foot.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableFooterView = foot;
    self.currentPage --;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
