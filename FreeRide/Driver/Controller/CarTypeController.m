//
//  CarTypeController.m
//  FreeRide
//
//  Created by mac on 2017/12/29.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "CarTypeController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "NetworkTool.h"
#import "SomeSupprt.h"
#import "UserDefaults.h"
#import "CarsInfoTableView.h"

@interface CarTypeController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray * dataBase;
@property (nonatomic,strong) UITableView * tableView;

@end

@implementation CarTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataBase = [[NSMutableArray alloc]init];
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"选择车型" andRightTitle:@""];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    //初始化数据
    //    [self createData];
    [self createTableView];
    [self createDataFromWeb];
}
- (void)createDataFromWeb {
    [[NetworkTool sharedTool] requestWithURLString:WEB_GETCARTYPE
                                        parameters:@{@"key":[UserDefaults getValueForKey:@"key"]}
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  [self checkDate:[[responseObject objectForKey:@"data"] objectForKey:@"vehicle_brand"]];
                                                  //                                                  [self loginAndAction:[responseObject objectForKey:@"data"]];
                                                  //                                                  [self downPersonInfo];
                                              } else {
                                                  [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.8];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
}
- (void)checkDate:(NSArray *)dataArr {
    NSString *section = @"A";
    NSMutableArray *dicArr = [NSMutableArray new];
    for (NSDictionary *carDic in dataArr) {
        if (![[carDic objectForKey:@"bfirstletter"] isEqualToString:section]) {
            NSArray *arr = [NSArray arrayWithArray:dicArr];
            [self.dataBase addObject:@{@"section":section,@"data":arr}];
            [dicArr removeAllObjects];
            section = [carDic objectForKey:@"bfirstletter"];
        }
        [dicArr addObject:carDic];
    }
    [self.dataBase addObject:@{@"section":section,@"data":dicArr}];
    [_tableView reloadData];
}
- (void)pushNextView:(NSString *)info {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self createCarInfoFromWeb:@{@"key":[UserDefaults getValueForKey:@"key"],@"brand_id":[[self.dataBase[indexPath.section] objectForKey:@"data"][indexPath.row] objectForKey:@"id"]}];
}
- (void)createCarInfoFromWeb:(NSDictionary *)dic {
    [[NetworkTool sharedTool] requestWithURLString:WEB_GETCARINFO
                                        parameters:dic
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  CarsInfoTableView *view = [[CarsInfoTableView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, self.view.frame.size.height-20) andType:[[responseObject objectForKey:@"data"] objectForKey:@"vehicleautomobile_models"]];
                                                  view.block = ^(NSDictionary *backInfo) {
                                                      self.block(backInfo);
                                                      [self.navigationController popViewControllerAnimated:YES];
                                                  };
                                                  [self.view addSubview:view];
                                                  //                                                  [self loginAndAction:[responseObject objectForKey:@"data"]];
                                                  //                                                  [self downPersonInfo];
                                              } else {
                                                  [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.8];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
}
- (void)createTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,68, SCREEN_WIDTH, self.view.bounds.size.height-68)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

//返回索引数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < _dataBase.count; i++) {
        [arr addObject:[_dataBase[i] objectForKey:@"section"]];
    }
    return arr;
}

//返回每个索引的内容
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[_dataBase objectAtIndex:section] objectForKey:@"section"];
}

//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataBase count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[_dataBase objectAtIndex:section] objectForKey:@"data"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *flag=@"cellFlag";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
    }
    [cell.textLabel setText:[[self.dataBase[indexPath.section] objectForKey:@"data"][indexPath.row] objectForKey:@"name"]];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
