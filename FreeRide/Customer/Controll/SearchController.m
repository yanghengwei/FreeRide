//
//  SearchController.m
//  FreeRide
//
//  Created by  on 2017/12/15.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "SearchController.h"
#import "Header.h"
#import "PersonalNaviView.h"

@interface SearchController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray * dataBase;
@property (nonatomic,strong) UITableView * tableView;

@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataBase = [[NSMutableArray alloc]init];
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"选择城市" andRightTitle:@""];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
                   [self.view addSubview:navi];
    //初始化数据
    [self createData];
    [self createTableView];
}
- (void)pushNextView:(NSString *)info {
        [self.navigationController popViewControllerAnimated:YES];
}
- (void)createData {
    [self.dataBase addObjectsFromArray:@[@{@"section":@"C",@"data":@[@"长治"]},
                                         @{@"section":@"D",@"data":@[@"大同"]},
                                         @{@"section":@"J",@"data":@[@"晋城",@"晋中"]},
                                         @{@"section":@"L",@"data":@[@"临汾",@"吕梁"]},
                                         @{@"section":@"S",@"data":@[@"朔州"]},
                                         @{@"section":@"T",@"data":@[@"太原"]},
                                         @{@"section":@"X",@"data":@[@"忻州"]},
                                         @{@"section":@"Y",@"data":@[@"阳泉",@"运城"]}]];
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
        [cell.textLabel setText:[self.dataBase[indexPath.section] objectForKey:@"data"][indexPath.row]];
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
