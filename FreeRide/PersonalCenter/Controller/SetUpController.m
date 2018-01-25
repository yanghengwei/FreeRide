//
//  SetUpController.m
//  FreeRide
//
//  Created by pc on 2017/11/28.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "SetUpController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "ResetPassWordController.h"
#import "AboutUsController.h"
#import "LoginViewController.h"
#import "UserDefaults.h"
#import "NetworkTool.h"
#import "SomeSupprt.h"

@interface SetUpController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SetUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_background;
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"设置" andRightTitle:@""];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self tableView];
    [self tableData];
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
        _tableView.tableFooterView = [self createFootView];
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 12)];
            [self.tableView setSeparatorColor:COLOR_background];
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *)tableData {
    if (!_tableData) {
        _tableData = [[NSMutableArray alloc] init];
        NSArray *arr = @[@"重置登录密码",@"重置支付密码",@"",@"版本更新",@"关于我们",@""];
        [_tableData addObjectsFromArray:arr];
    }
    [_tableView reloadData];
    return _tableData;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2 || indexPath.row == 5) {
        return 8;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"setup"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"setup"];
    }
    cell.textLabel.text = _tableData[indexPath.row];
    cell.textLabel.textColor = COLOR_TEXT_DARK;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    if (indexPath.section == 3) {
        cell.detailTextLabel.text = @"V0.0.1";
        cell.detailTextLabel.textColor = COLOR_TEXT_DARK;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    } else if (indexPath.row == 2 || indexPath.row == 5) {
        cell.backgroundColor = COLOR_background;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (UIView *)createFootView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, XMAKENEW(40))];
    footer.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, footer.frame.size.height)];
    [btn setTitle:@"退出" forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_ORANGE forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(exctBtn:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btn];
    
    return footer;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < 2) {
        ResetPassWordController *vc = [[ResetPassWordController alloc] init];
        vc.titleName = _tableData[indexPath.row];
        vc.isLogin = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.row == 4) {
        AboutUsController *vc = [[AboutUsController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)exctBtn:(UIButton *)button {
    [[NetworkTool sharedTool] requestWithURLString:WEB_USEREXIT
                                        parameters:@{@"key":[UserDefaults getValueForKey:@"key"],
                                                     @"phone":[UserDefaults getValueForKey:@"phone"]
                                                     }
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  [self userExit];
                                              } else {
                                                  [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.5];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
}
- (void)userExit {
    [UserDefaults removeValueForKey:@"phone"];
    [UserDefaults removeValueForKey:@"key"];
    [UserDefaults removeValueForKey:@"nick_name"];
    [UserDefaults removeValueForKey:@"home_town"];
    [UserDefaults removeValueForKey:@"sex"];
    [UserDefaults removeValueForKey:@"haunt"];
    [UserDefaults removeValueForKey:@"persion_sign"];
    [UserDefaults removeValueForKey:@"head_portrait"];
    [UserDefaults removeValueForKey:@"headImage"];
    self.view.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
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
