//
//  RoutesController.m
//  FreeRide
//
//  Created by  on 2017/12/11.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "RoutesController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "ChooseCarColorView.h"
#import "RoutesCell.h"
#import "NetworkTool.h"
#import "SomeSupprt.h"
#import "UserDefaults.h"

@interface RoutesController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation RoutesController

- (void)viewDidLoad {
    [super viewDidLoad];
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"合乘线路" andRightTitle:@""];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"RoutesCell" bundle:nil] forCellReuseIdentifier:@"RoutesCell"];
    [self dataSource];
    [self.tableView reloadData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self netWorking:@{@"phone":[UserDefaults getValueForKey:@"phone"],@"key":[UserDefaults getValueForKey:@"key"]}];
}
- (void)pushNextView:(NSString *)info {
    [self.navigationController popViewControllerAnimated:YES];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, self.view.frame.size.height-68) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_background;
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 12)];
            [self.tableView setSeparatorColor:COLOR_background];
        }
        self.tableView.estimatedRowHeight = 60.0f;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
//        _tableView.tableHeaderView = [self createHeadView];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        [_dataSource addObjectsFromArray:@[@{@"route_name":@"太原←→朔州"},@{@"route_name":@"太原←→晋城"}]];
    }
    return _dataSource;
}
- (void)setDataToTable:(NSArray *)dataArr {
//    [_dataSource removeAllObjects];
//    for (NSDictionary *dic in dataArr) {
//        [_dataSource addObject:[dic objectForKey:@"route_name"]];
//    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RoutesCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"RoutesCell"];
    if (!cell) {
        cell = [[RoutesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RoutesCell"];
        
    }
//    if ([[_dataSource[indexPath.row] objectForKey:@"route_name"] isEqualToString:_chooseInfoStr]) {
//        cell.isselectedImageView.image = [UIImage imageNamed:@"choose"];
//    }
    NSArray *arr = [[_dataSource[indexPath.row] objectForKey:@"route_name"]componentsSeparatedByString:@"←→"];//⇌
    cell.startLabel.text = arr[0];
    cell.endLabel.text = arr[1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.block(_dataSource[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)netWorking:(NSDictionary *)dict {
    [[NetworkTool sharedTool] requestWithURLString:WEB_GETROUDTYPE
                                        parameters:dict
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
//                                                  [self setDataToTable:[responseObject objectForKey:@"data"]];
                                                  [_dataSource removeAllObjects];
                                                  [_dataSource addObjectsFromArray:[responseObject objectForKey:@"data"]];
                                                  [_tableView reloadData];
                                              } else {
                                                  [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.8];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
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
