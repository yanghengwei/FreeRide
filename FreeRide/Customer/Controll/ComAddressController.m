//
//  ComAddressController.m
//  FreeRide
//
//  Created by pc on 2017/11/20.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "ComAddressController.h"
#import "Header.h"
#import "PersonalNaviView.h"

@interface ComAddressController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSouce;

@end

@implementation ComAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"常用地址" andRightTitle:@""];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self tableView];
    [self dataSouce];
}
- (void)pushNextView:(NSString *)info {
    [self.navigationController popViewControllerAnimated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"cacell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cacell"];
    }
    cell.imageView.image = [UIImage imageNamed:@"time_eidt"];
    cell.textLabel.text = [_dataSouce[indexPath.row] objectForKey:@"title"];
    cell.textLabel.textColor = COLOR_TEXT_DARK;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.detailTextLabel.text = [_dataSouce[indexPath.row] objectForKey:@"detail"];
    cell.detailTextLabel.textColor = COLOR_TEXT_NORMAL;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:FONT12];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSouce.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, self.view.frame.size.width, self.view.frame.size.height-68) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击%ld个cell",(long)indexPath.row);
}
- (NSMutableArray *)dataSouce {
    if (!_dataSouce) {
        _dataSouce = [[NSMutableArray alloc] init];
        for (int i = 0; i < 5; i++) {
            NSDictionary *dic = @{@"title":@"万国城MOMA停车场",@"detail":@"山西省太原市万柏林区长风西街16号"};
            [_dataSouce addObject:dic];
        }
    }
    return _dataSouce;
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
