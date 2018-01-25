//
//  MyCarController.m
//  FreeRide
//
//  Created by pc on 2017/11/25.
//  Copyright © 2017年 JNR All rights reserved.
//  我的车辆

#import "MyCarController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "SetPersonInfoController.h"
#import "SetCarInfoController.h"
#import "NetworkTool.h"
#import "SomeSupprt.h"
#import "UserDefaults.h"
#import "WebViewController.h"

@interface MyCarController () <UITableViewDelegate, UITableViewDataSource>
{
    UIView *headView;
    UILabel *label;
    UILabel *carInfoLabel;
}
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MyCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"我的车辆" andRightTitle:@"认证常见问题"];
    [navi.rightBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self tableView];
    [self tableData];
    [self changeBtn];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getDataFromWeb];
}
- (void)getDataFromWeb {
    [[NetworkTool sharedTool] requestWithURLString:WEB_GETCARSDATE
                                        parameters:@{@"key":[UserDefaults getValueForKey:@"key"],
                                                     @"phone":[UserDefaults getValueForKey:@"phone"]}
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  [self changeUI:[responseObject objectForKey:@"data"]];
//                                                  [SomeSupprt createUIAlertWithMessage:@"提交成功" andDisappearTime:0.5];
//                                                  [self.navigationController popViewControllerAnimated:YES];
                                              } else {
                                                  [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.5];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
}
- (NSMutableAttributedString *)setLabelInfo:(NSString *)string andStrLong:(NSInteger)strLong {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:16]
                    range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:COLOR_TEXT_DARK
                    range:NSMakeRange(0, attrStr.length - strLong)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:COLOR_TEXT_NORMAL
                    range:NSMakeRange(attrStr.length - strLong , strLong)];
    return attrStr;
}
- (void)changeUI:(NSDictionary *)dataDic {
    UIButton *btn1 = [self.view viewWithTag:990];
    UIButton *btn2 = [self.view viewWithTag:991];
    if ([[dataDic objectForKey:@"audit_status"] isEqualToString:@"2"]) {
        label.text = @"审核中";
        label.textColor = COLOR_TEXT_DARK;
    } else if ([[dataDic objectForKey:@"audit_status"] isEqualToString:@"4"]) {
        label.text = @"认证失败";
        label.textColor = [UIColor redColor];
    } else if ([[dataDic objectForKey:@"audit_status"] isEqualToString:@"3"]) {
        UIImageView *imageView = [self.view viewWithTag:4345];
        imageView.image = [UIImage imageNamed:@"certified"];
        carInfoLabel.attributedText = [self setLabelInfo:[NSString stringWithFormat:@"%@(%@)",[dataDic objectForKey:@"vehicle_brand"],[dataDic objectForKey:@"vehicle_color"]] andStrLong:[[dataDic objectForKey:@"vehicle_color"] length]+2];
        carInfoLabel.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame)+XMAKENEW(8), SCREEN_WIDTH, XMAKENEW(30));
        label.frame = CGRectMake(0, CGRectGetMaxY(carInfoLabel.frame)-XMAKENEW(5), SCREEN_WIDTH, XMAKENEW(30));
        headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, XMAKENEW(180));
        label.text = [dataDic objectForKey:@"license_plate"];
        label.textColor = COLOR_TEXT_NORMAL;
        UILabel *line = [self.view viewWithTag:4346];
        line.frame = CGRectMake(0, headView.frame.size.height-5, SCREEN_WIDTH, 5);
    }
    if ([[dataDic objectForKey:@"real_name_auth"] isEqualToString:@"3"]) {
        btn1.selected = YES;
    } else if ([[dataDic objectForKey:@"real_name_auth"] isEqualToString:@"2"]) {
        [btn1 setTitle:@"审核中" forState:UIControlStateNormal];
        [btn1 setTitleColor:COLOR_TEXT_DARK forState:UIControlStateNormal];
    } else if ([[dataDic objectForKey:@"real_name_auth"] isEqualToString:@"4"]) {
        [btn1 setTitle:@"审核失败" forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    if ([[dataDic objectForKey:@"car_owner_auth"] isEqualToString:@"3"]) {
        btn2.selected = YES;
    } else if ([[dataDic objectForKey:@"car_owner_auth"] isEqualToString:@"2"]) {
        [btn2 setTitle:@"审核中" forState:UIControlStateNormal];
        [btn2 setTitleColor:COLOR_TEXT_DARK forState:UIControlStateNormal];
    } else if ([[dataDic objectForKey:@"car_owner_auth"] isEqualToString:@"4"]) {
        [btn2 setTitle:@"审核失败" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    [_tableView reloadData];
}
- (void)pushNextView:(NSString *)info {
    if ([info isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        WebViewController *webView = [[WebViewController alloc] init];
        webView.titleName = @"认证常见问题";
        webView.urlString = @"attest_problems.html";
        [self.navigationController pushViewController:webView animated:YES];
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
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, XMAKENEW(150))];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(150), XMAKENEW(20), XMAKENEW(75), XMAKENEW(75))];
    imageView.image = [UIImage imageNamed:@"notcertified"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.tag = 4345;
    [headView addSubview:imageView];
    
    carInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+XMAKENEW(5), SCREEN_WIDTH, XMAKENEW(0))];
    carInfoLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:carInfoLabel];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(carInfoLabel.frame), SCREEN_WIDTH, XMAKENEW(30))];
    label.text = @"暂无车辆";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = COLOR_TEXT_LIGHT;
    label.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:label];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, headView.frame.size.height-5, SCREEN_WIDTH, 5)];
    line.backgroundColor = COLOR_background;
    line.tag = 4346;
    [headView addSubview:line];
    
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
        NSArray *arr = @[@{@"image":@"personal",@"title":@"个人信息"},
                         @{@"image":@"vehicle",@"title":@"车辆信息"}];
        [_tableData addObjectsFromArray:arr];
    }
    [_tableView reloadData];
    return _tableData;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"mycar"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycar"];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-XMAKENEW(120), 0, XMAKENEW(100), cell.frame.size.height)];
        [btn setImage:[UIImage imageNamed:@"unchecked_icon"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
        [btn setTitle:@"未认证" forState:UIControlStateNormal];
        [btn setTitle:@"已认证" forState:UIControlStateSelected];
        [btn setTitleColor:COLOR_ORANGE forState:UIControlStateSelected];
        [btn setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.tag = 990+indexPath.row;
        [cell addSubview:btn];
    }
    cell.textLabel.text = [_tableData[indexPath.row] objectForKey:@"title"];
    cell.textLabel.textColor = COLOR_TEXT_NORMAL;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.imageView.image = [UIImage imageNamed:[_tableData[indexPath.row] objectForKey:@"image"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)changeBtn {
    UIButton *btn = [self.view viewWithTag:990];
    btn.selected =YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIButton *btn1 = [self.view viewWithTag:990];
    UIButton *btn2 = [self.view viewWithTag:991];
    if (indexPath.row == 0) {
        SetPersonInfoController *vc = [[SetPersonInfoController alloc] init];
        if (btn1.selected || [btn1.titleLabel.text isEqualToString:@"审核中"]) {
            vc.isUped = YES;
        }
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        SetCarInfoController *vc = [[SetCarInfoController alloc] init];
        if (btn2.selected || [btn2.titleLabel.text isEqualToString:@"审核中"]) {
            vc.isUped = YES;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
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
