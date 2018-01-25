//
//  OrderController.m
//  FreeRide
//
//  Created by pc on 2017/11/22.
//  Copyright © 2017年 JNR All rights reserved.
//  我的订单

#import "OrderController.h"
#import "OrderTableViewCell.h"
#import "Header.h"
#import "PersonalNaviView.h"

@interface OrderController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation OrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_background;
    [self setSegInView];
    [self tableView];
    [self tableData];
    [self.tableView registerNib:[UINib nibWithNibName:@"OrderTableViewCell" bundle:nil] forCellReuseIdentifier:@"OrderTableViewCell"];
}

- (void)setSegInView {
    UIView *naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 48)];
    naviView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:naviView];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [backBtn addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [naviView addSubview:backBtn];
    
    //选择器
    NSArray *nameArr = @[@"车主",@"乘客"];
    for (int i = 0;  i < 2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-XMAKENEW(80)*i, 10, XMAKENEW(80), 28)];
        [button setTitle:nameArr[i] forState:UIControlStateNormal];
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
        [naviView addSubview:button];
        if (i == 1) {
            button.selected = YES;
            [button.layer setBorderColor:COLOR_ORANGE.CGColor];
        }
    }
    
    //线
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, naviView.frame.size.height-1, naviView.frame.size.width, 1)];
    line.backgroundColor = COLOR_background;
    [naviView addSubview:line];
}
- (void)chooseInvoice:(UIButton *)button{
    UIButton *btn1 = [self.view viewWithTag:1104];
    UIButton *btn2 = [self.view viewWithTag:1105];
    NSArray *arr;
    [_tableData removeAllObjects];
    if (button.tag == 1104 && !btn1.selected) {
        btn1.selected = YES;
        [btn1.layer setBorderColor:COLOR_ORANGE.CGColor];
        btn2.selected = NO;
        [btn2.layer setBorderColor:COLOR_TEXT_LIGHT.CGColor];
        arr = @[@[@"1",@"2",@"3"],@[@"2",@"1",@"3"]];
    } else if (button.tag == 1105 && !btn2.selected) {
        btn2.selected = YES;
        [btn2.layer setBorderColor:COLOR_ORANGE.CGColor];
        btn1.selected = NO;
        [btn1.layer setBorderColor:COLOR_TEXT_LIGHT.CGColor];
        arr = @[@[@"1"],@[@"2",@"1",@"3"]];
    }
    [_tableData addObjectsFromArray:arr];
    [_tableView reloadData];
};
- (void)backTo {
    [self.navigationController popViewControllerAnimated:YES];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, self.view.frame.size.height-68) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_background;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *)tableData {
    if (!_tableData) {
        _tableData = [NSMutableArray new];
        NSArray *arr = @[@[@"1"],@[@"2",@"1",@"3"]];
        [_tableData addObjectsFromArray:arr];
    }
    [_tableView reloadData];
    return _tableData;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _tableData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableData[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *title = @[@"待处理订单",@"历史订单"];
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, -0, SCREEN_WIDTH, 30)];
    sectionHeader.backgroundColor = COLOR_background;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(15), 3, SCREEN_WIDTH, 24)];
    label.textColor = COLOR_TEXT_LIGHT;
    label.font = [UIFont systemFontOfSize:13];
    label.text = title[section];
    [sectionHeader addSubview:label];
    
    return sectionHeader;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderTableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"OrderTableViewCell"];
    if (!cell) {
        cell = [[OrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderTableViewCell"];
        
    }
//    cell.reloadBlock = ^(NSString *backInfo){
//        NSLog(@"%@",backInfo);
//        [self.tableView reloadData];
//    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
