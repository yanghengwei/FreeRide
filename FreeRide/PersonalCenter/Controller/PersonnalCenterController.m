//
//  PersonnalCenterController.m
//  FreeRide
//
//  Created by  on 2017/11/21.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "PersonnalCenterController.h"
#import "Header.h"
#import "SetUpController.h"
#import "EvaluationChooseView.h"
#import "PersonInfoController.h"
#import "UserDefaults.h"
#import "AESCipher.h"

@interface PersonnalCenterController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *className;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation PersonnalCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self tableView];
    [self dataSource];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}
- (void)reloadData {
    UILabel *nameLabel = [self.view viewWithTag:6781];
    if ([UserDefaults getValueForKey:@"nick_name"] && ![[UserDefaults getValueForKey:@"nick_name"] isEqualToString:@""]) {
        nameLabel.text = [UserDefaults getValueForKey:@"nick_name"];
    } else if ([UserDefaults getValueForKey:@"phone"]){
        nameLabel.text = aesDecryptString([UserDefaults getValueForKey:@"phone"], AESKEY);
    }
    UIImageView *maleImageView = [self.view viewWithTag:6782];
    if ([[UserDefaults getValueForKey:@"sex"] isEqualToString:@"2"]) {
        maleImageView.image = [UIImage imageNamed:@"girl"];
    } else if ([[UserDefaults getValueForKey:@"sex"] isEqualToString:@"1"]) {
        maleImageView.image = [UIImage imageNamed:@"boy"];
    }
    UIButton *imageBtn = [self.view viewWithTag:6783];
    if ([UserDefaults getValueForKey:@"headImage"]) {
        [imageBtn setImage:[UIImage imageWithData:[UserDefaults getValueForKey:@"headImage"]] forState:UIControlStateNormal];
    }
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        NSArray *infoArr = @[/*@{@"image":@"wallet",@"title":@"我的钱包",@"className":@"MyWalletController"},
                             @{@"image":@"cupon",@"title":@"优惠券",@"className":@"DiscountController"},*/
                             @{@"image":@"order",@"title":@"我的订单",@"className":@"OrderController"},
                             /*@{@"image":@"trip",@"title":@"我的行程",@"className":@"DiscountController"},*/
                             @{@"image":@"vehicle_icon",@"title":@"我的车辆",@"className":@"MyCarController"},
                             @{@"image":@"invoice",@"title":@"开具发票",@"className":@"InvoiceListViewController"},
                             @{},
                             @{@"image":@"manual",@"title":@"合乘攻略",@"className":@"SearchController"},
                             @{@"image":@"opinion",@"title":@"意见反馈",@"className":@"OpinionController"},
                             @{@"image":@"pro_customerservice",@"title":@"联系客服",@"className":@"PilotViewController"}];
        [_dataSource addObjectsFromArray:infoArr];
        [_tableView reloadData];
    }
    return _dataSource;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, self.view.frame.size.height+20) style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_background;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [self createHeadView];
        _tableView.tableFooterView = [[UIView alloc] init];
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 12)];
            [self.tableView setSeparatorColor:COLOR_background];
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (UIView *)createHeadView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, XMAKENEW(200))];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, XMAKENEW(165))];
    imageView.image = [UIImage imageNamed:@"bg"];
    imageView.userInteractionEnabled = YES;
    [headView addSubview:imageView];
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(3), XMAKENEW(20), XMAKENEW(40), XMAKENEW(40))];
    [leftBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(320), CGRectGetMinY(leftBtn.frame), XMAKENEW(40), XMAKENEW(40))];
    [rightBtn setImage:[UIImage imageNamed:@"setup"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(setBtn:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:rightBtn];
    
    UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(150), XMAKENEW(40), XMAKENEW(76), XMAKENEW(76))];
    imageBtn.tag = 6783;
    [imageBtn setImage:[UIImage imageNamed:@"bg"] forState:UIControlStateNormal];
//    imageBtn.layer.cornerRadius = 37.0;//2.0是圆角的弧度，根据需求自己更改
//    imageBtn.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);//设置边框颜色
//    imageBtn.layer.borderWidth = 5.0f;//设置边框颜色
    [imageBtn addTarget:self action:@selector(personInfo) forControlEvents:UIControlEventTouchUpInside];
    [imageBtn.layer setCornerRadius:imageBtn.frame.size.width/2];
    [imageBtn.layer setMasksToBounds:YES];
    [headView addSubview:imageBtn];
    UIImageView *maleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(203), XMAKENEW(99), XMAKENEW(15), XMAKENEW(15))];
    maleImageView.tag = 6782;
    [headView addSubview:maleImageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(100), CGRectGetMaxY(imageBtn.frame)+XMAKENEW(5), XMAKENEW(175), XMAKENEW(20))];
    nameLabel.tag = 6781;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:nameLabel];
    
    NSArray *btnNameArr = @[@"  今日收益",@"  我的钱包"];
    NSArray *btnImageArr = @[@"profit",@"confirmorder"];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2*i, CGRectGetMaxY(nameLabel.frame)+XMAKENEW(3), SCREEN_WIDTH/2, XMAKENEW(30))];
        [btn setImage:[UIImage imageNamed:btnImageArr[i]] forState:UIControlStateNormal];
        [btn setTitle:btnNameArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_TEXT_DARK forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.tag = 1104+i;
        [btn addTarget:self action:@selector(btnTagert:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:btn];
    }
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, CGRectGetMaxY(nameLabel.frame)+XMAKENEW(11), 1, XMAKENEW(24))];
    line.backgroundColor = COLOR_background;
    [headView addSubview:line];
    
    UILabel *lines = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame)+XMAKENEW(12), SCREEN_WIDTH, 8)];
    lines.backgroundColor = COLOR_background;
    [headView addSubview:lines];
    return headView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return 5;
    } else {
        return 50;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
    }
    if (indexPath.row == 3) {
        cell.backgroundColor = COLOR_background;
    } else {
        cell.imageView.image = [UIImage imageNamed:[_dataSource[indexPath.row] objectForKey:@"image"]];
        cell.textLabel.text = [_dataSource[indexPath.row] objectForKey:@"title"];
        cell.textLabel.textColor = COLOR_TEXT_DARK;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return;
    } else if (indexPath.row == 6) {
        UIWebView * callWebview = [[UIWebView alloc]init];
        
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:96508"]]];
        
        [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
    } else {
        UIViewController *subViewController = [[NSClassFromString([_dataSource[indexPath.row] objectForKey:@"className"]) alloc] init];
        [self.navigationController pushViewController:subViewController animated:YES];
    }
    NSLog(@"点击了第%ld个cell",(long)indexPath.row);
}
- (void)backView {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setBtn:(UIButton *)button {
    SetUpController *vc = [[SetUpController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)personInfo {
    PersonInfoController *vc = [[PersonInfoController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)btnTagert:(UIButton *)button {
    if (button.tag == 1104) {
        NSLog(@"点击今日收益");
//        EvaluationChooseView *view = [[EvaluationChooseView alloc] initWithFrame:self.view.bounds];
//        [self.view addSubview:view];
        UIViewController *subViewController = [[NSClassFromString(@"WalletDetailController") alloc] init];
        [self.navigationController pushViewController:subViewController animated:YES];
    } else {
        UIViewController *subViewController = [[NSClassFromString(@"MyWalletController") alloc] init];
        [self.navigationController pushViewController:subViewController animated:YES];
        NSLog(@"点击确认订单");
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
