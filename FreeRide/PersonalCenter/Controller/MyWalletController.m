//
//  MyWalletController.m
//  FreeRide
//
//  Created by pc on 2017/11/25.
//  Copyright © 2017年 JNR All rights reserved.
//  我的钱包

#import "MyWalletController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "TopUpController.h"
#import "WalletDetailController.h"
#import "WithdrawCashController.h"
#import "CardListController.h"
#import "NetworkTool.h"
#import "SomeSupprt.h"
#import "UserDefaults.h"

@interface MyWalletController () <UITableViewDelegate, UITableViewDataSource>
{
    UIButton *moneyButton;
}
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MyWalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_background;
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"我的钱包" andRightTitle:@""];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self tableView];
    [self tableData];
}
- (void)viewWillAppear:(BOOL)animated {
    [self downDataFromWeb];
}
- (void)pushNextView:(NSString *)info {
    if ([info isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, self.view.frame.size.height-68) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_background;
        _tableView.tableHeaderView = [self HeadView];
        _tableView.tableFooterView = [[UIView alloc] init];
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 12)];
            [self.tableView setSeparatorColor:COLOR_background];
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (UIView *)HeadView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, XMAKENEW(165))];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, XMAKENEW(30))];
    titleLabel.text = @"我的余额";
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = COLOR_ORANGE;
    [headView addSubview:titleLabel];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(XMAKENEW(150), CGRectGetMaxY(titleLabel.frame), XMAKENEW(75), XMAKENEW(75))];
    backView.backgroundColor = COLOR_background;
    [backView.layer setCornerRadius:backView.frame.size.width/2];
    [backView.layer setMasksToBounds:YES];
    [headView addSubview:backView];
    
    UIView *backWhiteView = [[UIView alloc] initWithFrame:CGRectMake(3, 3, backView.frame.size.width-6, backView.frame.size.width-6)];
    backWhiteView.backgroundColor = [UIColor whiteColor];
    [backWhiteView.layer setCornerRadius:backWhiteView.frame.size.width/2];
    [backWhiteView.layer setMasksToBounds:YES];
    [backView addSubview:backWhiteView];
    
    moneyButton = [[UIButton alloc] initWithFrame:CGRectMake(3, 3, backWhiteView.frame.size.width-6, backWhiteView.frame.size.width-6)];
    [moneyButton setTitle:@"0.0" forState:UIControlStateNormal];
    [moneyButton setTitleColor:COLOR_ORANGE forState:UIControlStateNormal];
    moneyButton.titleLabel.font = [UIFont systemFontOfSize:FONT12];
    moneyButton.layer.cornerRadius = moneyButton.frame.size.width/2;//2.0是圆角的弧度，根据需求自己更改
    [moneyButton.layer setBorderColor:COLOR_ORANGE.CGColor];
    moneyButton.layer.borderWidth = 1.0f;//设置边框颜色
    [backWhiteView addSubview:moneyButton];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(15), CGRectGetMaxY(backView.frame)+XMAKENEW(5), XMAKENEW(345), 1)];
    line.backgroundColor = COLOR_background;
    [headView addSubview:line];
    
//    NSArray *btnNameArr = @[@" 赠额：0",@" 本金：0"];
//    NSArray *colorArr = @[[UIColor redColor],[UIColor greenColor]];
//    UIView *point = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 2)];
//    for (int i = 0; i < 2; i++) {
//        point.backgroundColor = colorArr[i  ];
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2*i, CGRectGetMaxY(line.frame), SCREEN_WIDTH/2, XMAKENEW(35))];
//        [btn setImage:[self convertViewToImage:point] forState:UIControlStateNormal];
//        [btn setTitle:btnNameArr[i] forState:UIControlStateNormal];
//        [btn setTitleColor:COLOR_TEXT_DARK forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:13];
//        btn.tag = 1104+i;
//        [btn addTarget:self action:@selector(btnTagert:) forControlEvents:UIControlEventTouchUpInside];
//        [headView addSubview:btn];
//    }
//    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, CGRectGetMaxY(line.frame), 1, XMAKENEW(35))];
//    line.backgroundColor = COLOR_background;
//    [headView addSubview:line1];
    
//    UILabel *lines = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line1.frame), SCREEN_WIDTH, 5)];
//    lines.backgroundColor = COLOR_background;
//    [headView addSubview:lines];
    
    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(line.frame));
    
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (void)btnTagert:(UIButton *)button {
    if (button.tag == 1104) {
        NSLog(@"增额");
    } else {
        NSLog(@"本金");
    }
}
-(UIImage*)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    UIGraphicsBeginImageContext(s);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (NSMutableArray *)tableData {
    if (!_tableData) {
        _tableData = [NSMutableArray new];
        NSArray *arr = @[/*@"充值",*/
                         @"银行卡",
                         @"提现",
                         @"明细"];
        [_tableData addObjectsFromArray:arr];
    }
    [_tableView reloadData];
    return _tableData;
}- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"myWallet"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"myWallet"];
    }
    cell.textLabel.text = _tableData[indexPath.row];
    cell.textLabel.textColor = COLOR_TEXT_DARK;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.row == 1) {
        cell.detailTextLabel.text = @"可提现0.0";
        cell.detailTextLabel.textColor = COLOR_ORANGE;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:FONT12];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if /*(indexPath.row == 0) {
        TopUpController *vc = [[TopUpController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if */(indexPath.row == 0) {
        CardListController *vc = [[CardListController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 1) {
        WithdrawCashController *vc = [[WithdrawCashController alloc] init];
        vc.mostMoney = moneyButton.titleLabel.text;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 2) {
        WalletDetailController *vc = [[WalletDetailController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)downDataFromWeb {
    [[NetworkTool sharedTool] requestWithURLString:WEB_GETACCOUNTMONEY
                                        parameters:@{@"key":[UserDefaults getValueForKey:@"key"],
                                                     @"phone":[UserDefaults getValueForKey:@"phone"]
                                                     }
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  if (![[responseObject objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                                                      [moneyButton setTitle:[NSString stringWithFormat:@"%.1f",[[[responseObject objectForKey:@"data"] objectForKey:@"principal"] floatValue]] forState:UIControlStateNormal];
                                                      NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                                                      UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
                                                      cell.detailTextLabel.text = [NSString stringWithFormat:@"可提现%.1f",[[[responseObject objectForKey:@"data"] objectForKey:@"principal"] floatValue]];
                                                  }
//                                                  [self cheakDataAndReload:[responseObject objectForKey:@"data"]];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
