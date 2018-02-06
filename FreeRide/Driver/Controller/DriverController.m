//
//  DriverController.m
//  FreeRide
//
//  Created by pc on 2017/11/23.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "DriverController.h"
#import "Header.h"
#import "DriverCell.h"
#import "PersonnalCenterController.h"
#import "MainTableController.h"
#import "FRReleaseController.h"
#import "TheOrderController.h"
#import "ConfirmCustersView.h"
#import "UserDefaults.h"
@interface DriverController () <UITableViewDelegate, UITableViewDataSource>
{
    UIView *backView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableData;

@end

@implementation DriverController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    [self createNavi];
    [self tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"DriverCell" bundle:nil] forCellReuseIdentifier:@"DriverCell"];
    [self tableData];
}
- (void)viewWillAppear:(BOOL)animated {
    ConfirmCustersView *vc = [[ConfirmCustersView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:vc];
}
- (void)createNavi {
    UIView *navi = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 48)];
    navi.backgroundColor=[UIColor whiteColor];
    //左侧按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(10), YMAKENEW(10), XMAKENEW(30), XMAKENEW(30))];
    [backBtn setImage:[UIImage imageNamed:@"profile"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:backBtn];
    
    //中间按钮
    UIButton *middleBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(153), YMAKENEW(15), XMAKENEW(73), YMAKENEW(22))];
    [middleBtn setTitle:@"车主" forState:UIControlStateNormal];
    [middleBtn addTarget:self action:@selector(chooseUser) forControlEvents:UIControlEventTouchUpInside];
    [middleBtn setTitleColor:COLOR_TEXT_DARK forState:UIControlStateNormal];
    [middleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -middleBtn.imageView.frame.size.width-XMAKENEW(26), 0, middleBtn.imageView.frame.size.width)];
    [middleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, middleBtn.titleLabel.bounds.size.width-XMAKENEW(8), 0, -middleBtn.titleLabel.bounds.size.width)];
    [middleBtn setImage:[UIImage imageNamed:@"home_open"] forState:UIControlStateNormal];
    middleBtn.layer.cornerRadius = 13.0;//2.0是圆角的弧度，根据需求自己更改
    middleBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    [middleBtn.layer setBorderColor:COLOR_TEXT_LIGHT.CGColor];
    middleBtn.layer.borderWidth = 1.0f;//设置边框颜色
    middleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [navi addSubview:middleBtn];
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(290), YMAKENEW(10), XMAKENEW(80), XMAKENEW(30))];
    [rightBtn setTitle:@"发布行程" forState:UIControlStateNormal];
    [rightBtn setTitleColor:COLOR_ORANGE forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightBtn addTarget:self action:@selector(infoAction) forControlEvents:UIControlEventTouchUpInside];
    [navi addSubview:rightBtn];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 47, SCREEN_WIDTH, 1)];
    line.backgroundColor = COLOR_background;
    [navi addSubview:line];
    [self.view addSubview:navi];
}
- (void)backAction {
    PersonnalCenterController *vc = [[PersonnalCenterController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)chooseUser {
    [self changeDriver];
}
- (void)infoAction {
    NSLog(@"点击了发布行程");
    FRReleaseController *vc = [[FRReleaseController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)changeDriver {
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    
    UIView *chooseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, XMAKENEW(84)+68)];
    chooseView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:chooseView];
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(chooseView.frame), SCREEN_WIDTH, self.view.frame.size.height-chooseView.frame.size.height)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.5;
    [backView addSubview:blackView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(175), 33, XMAKENEW(25), XMAKENEW(25))];
    imageView.image = [UIImage imageNamed:@"open_icon"];
    [chooseView addSubview:imageView];
    
    NSArray *nameArr = @[@"乘客",@"车主"];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 68+XMAKENEW(40)*i, SCREEN_WIDTH, XMAKENEW(40))];
        [button setTitle:nameArr[i] forState:UIControlStateNormal];
        [button setTitleColor:COLOR_TEXT_DARK forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1230+i;
        [chooseView addSubview:button];
    }
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 68+XMAKENEW(40), SCREEN_WIDTH, 1)];
    line.backgroundColor = COLOR_background;
    [chooseView addSubview:line];
    
    [self.view addSubview:backView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelKeybord:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [backView addGestureRecognizer:tap];
}
- (void)cancelKeybord:(UITapGestureRecognizer*)tap {
    [backView removeFromSuperview];
}
- (void)chooseAction:(UIButton *)button {
    if (button.tag == 1231) {
        [backView removeFromSuperview];
    } else {
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        window.rootViewController  = [[UINavigationController alloc] initWithRootViewController:[[MainTableController alloc] init]];
    }
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, self.view.frame.size.height-68) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [self creatHeadView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.estimatedRowHeight = 60.0f;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *)tableData {
    if (!_tableData) {
        _tableData = [NSMutableArray new];
    }
    [_tableView reloadData];
    return _tableData;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, XMAKENEW(40))];
    head.backgroundColor = COLOR_background;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(10), XMAKENEW(3), SCREEN_WIDTH, XMAKENEW(20))];
    label.text = @"今天10:00-10:30";
    label.textColor = COLOR_TEXT_DARK;
    label.font = [UIFont systemFontOfSize:13];
    [head addSubview:label];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(-XMAKENEW(12), CGRectGetMinY(label.frame), SCREEN_WIDTH, label.frame.size.height)];
    rightLabel.text = @"5个订单未完成";
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.textColor = COLOR_TEXT_NORMAL;
    rightLabel.font = [UIFont systemFontOfSize:13];
    [head addSubview:rightLabel];
    
    return head;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TheOrderController *vc = [[TheOrderController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DriverCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"DriverCell"];
    if (!cell) {
        cell = [[DriverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DriverCell"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (UIView *)creatHeadView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, XMAKENEW(63))];
    headView.backgroundColor = [UIColor whiteColor];
    //司机头像
    UIImageView *headIamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(15), YMAKENEW(10), XMAKENEW(38), XMAKENEW(38))];
    headIamgeView.image = [UIImage imageWithData:[UserDefaults getValueForKey:@"headImage"]];
    [headIamgeView.layer setCornerRadius:headIamgeView.frame.size.width/2];
    [headIamgeView.layer setMasksToBounds:YES];
    [headView addSubview:headIamgeView];
    //司机姓名
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = [UserDefaults getValueForKey:@"nick_name"];
//WithFrame:CGRectMake(CGRectGetMaxX(headIamgeView.frame)+XMAKENEW(5), CGRectGetMinY(headIamgeView.frame)-YMAKENEW(1), XMAKENEW(45), XMAKENEW(24))];
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:16];
    nameLabel.font = fnt;
    // 根据字体得到NSString的尺寸
    CGSize size = [nameLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    CGFloat nameW = size.width;
    nameLabel.frame = CGRectMake(CGRectGetMaxX(headIamgeView.frame)+XMAKENEW(5), CGRectGetMinY(headIamgeView.frame)-YMAKENEW(1), nameW, XMAKENEW(24));
    
//    nameLabel.adjustsFontSizeToFitWidth = YES;
    [headView addSubview:nameLabel];
    //司机性别
    UIImageView *maleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), CGRectGetMinY(nameLabel.frame)+XMAKENEW(5), nameLabel.frame.size.height-XMAKENEW(8), nameLabel.frame.size.height-XMAKENEW(8))];
    if ([[UserDefaults getValueForKey:@"sex"] isEqualToString:@"1"]) {
        maleImageView.image = [UIImage imageNamed:@"boy"];
    } else {
        maleImageView.image = [UIImage imageNamed:@"girl"];
    }
    [headView addSubview:maleImageView];
    //司机车牌
    UILabel *carIdLabel = [[UILabel alloc] init];
    carIdLabel.text = [UserDefaults getValueForKey:@"license_plate"];
    carIdLabel.font = fnt;
    // 根据字体得到NSString的尺寸
    CGSize carIDsize = [carIdLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    CGFloat carIDnameW = carIDsize.width;
    carIdLabel.frame = CGRectMake(CGRectGetMaxX(maleImageView.frame), CGRectGetMinY(nameLabel.frame)+4.5, carIDnameW, maleImageView.frame.size.height);
    carIdLabel.adjustsFontSizeToFitWidth = YES;
    carIdLabel.backgroundColor = COLOR_TEXT_LIGHT;
    carIdLabel.textColor = COLOR_TEXT_DARK;
//    carIdLabel.font = [UIFont systemFontOfSize:FONT12];
    [headView addSubview:carIdLabel];
    //汽车信息
    UILabel *carInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame)-YMAKENEW(3), self.view.frame.size.width, nameLabel.frame.size.height)];
    carInfoLabel.text = [NSString stringWithFormat:@"%@  %@  %@",[UserDefaults getValueForKey:@"brand_name"],[UserDefaults getValueForKey:@"vehicle_brand"],[UserDefaults getValueForKey:@"vehicle_color"]];
    carInfoLabel.textColor = COLOR_TEXT_NORMAL;
    carInfoLabel.font = [UIFont systemFontOfSize:FONT12];
    [headView addSubview:carInfoLabel];
    
    return headView;
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
