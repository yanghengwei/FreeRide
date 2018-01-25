//
//  CommonsController.m
//  FreeRide
//
//  Created by  on 2017/12/6.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "CommonsController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "FRCancelTableViewCell.h"

@interface CommonsController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CommonsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_background;
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"常用乘车人" andRightTitle:@"添加"];
    [navi.rightBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"FRCancelTableViewCell" bundle:nil] forCellReuseIdentifier:@"FRCancelTableViewCell"];
    [self footView];
}
- (void)footView {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-XMAKENEW(90), SCREEN_WIDTH, XMAKENEW(90))];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, XMAKENEW(7), SCREEN_WIDTH, XMAKENEW(25))];
    [button setTitle:@"短信通知乘车人" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:FONT12];
    [button setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    [button setTitleColor:COLOR_TEXT_DARK forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(changeBtnSeleted:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:button];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(15), XMAKENEW(37), SCREEN_WIDTH-2*XMAKENEW(15), YMAKENEW(40))];
    [loginBtn setTitle:@"提交" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(tagerLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = COLOR_ORANGE;
    loginBtn.layer.cornerRadius = 3.0;//2.0是圆角的弧度，根据需求自己更改
    loginBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    loginBtn.layer.borderWidth = 0.5f;//设置边框颜色
    [footView addSubview:loginBtn];
}
- (void)changeBtnSeleted:(UIButton *)button {
    button.selected = !button.selected;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self dataSource];
    [_tableView reloadData];
}
- (void)tagerLoginBtn {
    NSLog(@"点击提交");
}
- (void)pushNextView:(NSString *)info {
    if ([info isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"点击添加按钮");
    }
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, self.view.frame.size.height-68-XMAKENEW(90)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_background;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [self headView];
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 12)];
            [self.tableView setSeparatorColor:COLOR_background];
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (UIView *)headView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 4)];
    headView.backgroundColor = COLOR_background;
    return headView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        [_dataSource addObjectsFromArray:@[@{@"name":@"王晓旺",@"phone":@"15234568956"},@{@"name":@"王晓旺",@"phone":@"15234568956"},@{@"name":@"王晓旺",@"phone":@"15234568956"},@{@"name":@"王晓旺",@"phone":@"15234568956"},@{@"name":@"王晓旺",@"phone":@"15234568956"},@{@"name":@"王晓旺",@"phone":@"15234568956"},@{@"name":@"王晓旺",@"phone":@"15234568956"}]];
    }
    return _dataSource;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FRCancelTableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"FRCancelTableViewCell"];
    if (!cell) {
        cell = [[FRCancelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FRCancelTableViewCell"];
    }
    cell.titleLabel.text = [_dataSource[indexPath.row] objectForKey:@"name"];
    cell.phoneLabel.text = [_dataSource[indexPath.row] objectForKey:@"phone"];
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
