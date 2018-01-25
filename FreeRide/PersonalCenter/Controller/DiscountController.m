//
//  DiscountController.m
//  FreeRide
//
//  Created by pc on 2017/11/22.
//  Copyright © 2017年 JNR All rights reserved.
//  优惠券

#import "DiscountController.h"
#import "Header.h"
#import "DiscountCell.h"
#import "PersonalNaviView.h"

@interface DiscountController ()

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DiscountController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"优惠券" andRightTitle:@"优惠券规则"];
    [navi.rightBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscountCell" bundle:nil] forCellReuseIdentifier:@"DiscountCell"];
}
- (void)pushNextView:(NSString *)info {
    if ([info isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"点击了右侧按钮");
    }
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, self.view.frame.size.height-68) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *)tableData {
    if (!_tableData) {
        _tableData = [NSMutableArray new];
        NSArray *arr = @[@{@"id":@"0",@"time":@"2017-10-16-2017-10-31",@"info":@"太原市区→朔州市区\n小店区箭头→朔州市区\n小店区→朔州市区"},
                         @{@"id":@"1",@"time":@"2017-10-16-2017-10-31",@"info":@"太原市区→朔州市区\n小店区箭头→朔州市区\n小店区→朔州市区"},
                         @{@"id":@"2",@"time":@"2017-10-16-2017-10-31",@"info":@"太原市区→朔州市区\n小店区箭头→朔州市区\n小店区→朔州市区"},
                         @{@"id":@"3",@"time":@"2017-10-16-2017-10-31",@"info":@"太原市区→朔州市区\n小店区箭头→朔州市区\n小店区→朔州市区"},
                         @{@"id":@"4",@"time":@"2017-10-16-2017-10-31",@"info":@"太原市区→朔州市区\n小店区箭头→朔州市区\n小店区→朔州市区"},
                         @{@"id":@"5",@"time":@"2017-10-16-2017-10-31",@"info":@"太原市区→朔州市区\n小店区箭头→朔州市区\n小店区→朔州市区"},
                         @{@"id":@"6",@"time":@"2017-10-16-2017-10-31",@"info":@"太原市区→朔州市区\n小店区箭头→朔州市区\n小店区→朔州市区"},
                         @{@"id":@"7",@"time":@"2017-10-16-2017-10-31",@"info":@"太原市区→朔州市区\n小店区箭头→朔州市区\n小店区→朔州市区"},
                         @{@"id":@"8",@"time":@"2017-10-16-2017-10-31",@"info":@"太原市区→朔州市区\n小店区箭头→朔州市区\n小店区→朔州市区"},
                         @{@"id":@"9",@"time":@"2017-10-16-2017-10-31",@"info":@"太原市区→朔州市区\n小店区箭头→朔州市区\n小店区→朔州市区"}];
        [_tableData addObjectsFromArray:arr];
    }
    [_tableView reloadData];
    return _tableData;
}- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscountCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"DiscountCell"];
    if (!cell) {
        cell = [[DiscountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DiscountCell"];
        
    }
    cell.reloadBlock = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self.tableView reloadData];
    };
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
