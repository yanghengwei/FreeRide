//
//  MainTableController.m
//  FreeRide
//
//  Created by  on 2017/11/15.
//  Copyright © 2017年 JNR All rights reserved.
//
#import "MainTableController.h"
#import "Header.h"
#import "NaviView.h"
//#import "MainHeadView.h"
#import "MainTableViewCell.h"
#import "PersonnalCenterController.h"
#import "DriverController.h"
#import "NotifyController.h"
#import "ChooseEndCityController.h"
#import "PerfectInfoController.h"
#import "DriverInfoController.h"
#import "MapViewController.h"
#import "NetworkTool.h"
#import "SomeSupprt.h"
#import "UserDefaults.h"
#import <UIImageView+WebCache.h>
#import <GCCycleScrollView.h>

@interface MainTableController () <UITableViewDelegate, UITableViewDataSource,GCCycleScrollViewDelegate>
{
    UIView *backView;
    UIButton *carImageViewBtn;
    UIButton *stateBtn;
    UIView *headView;
}

@property (strong, nonatomic) GCCycleScrollView *adScrollView;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation MainTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![UserDefaults getValueForKey:@"key"]) {
        [UserDefaults saveValue:@"" forKey:@"key"];
        [UserDefaults saveValue:@"" forKey:@"phone"];
    }
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    NaviView *navi = [[NaviView alloc] initWithFrame:CGRectMake(0, 20, XMAKENEW(375), SCREEN_HEGHT) andName:@"乘客" andTyep:@"personalCenter"];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    self.routeDic = @{};
    [self createUI];
    [self creatMainScrollView];
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"mainCell"];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self getDataFromWeb];
    [self getBanner];
}
- (void)getBanner {
    [[NetworkTool sharedTool] requestWithURLString:WEB_GETBANNER
                                        parameters:@{@"key":[UserDefaults getValueForKey:@"key"],
                                                     @"phone":[UserDefaults getValueForKey:@"phone"]}
                                            method:@"POST"
                                          callBack:^(id responseObject) {
                                              if ([[responseObject objectForKey:@"status"] isEqualToString:@"0"]) {
                                                  [self changeADScrollView:[responseObject objectForKey:@"data"]];
                                              } else {
                                                  [SomeSupprt createUIAlertWithMessage:[responseObject objectForKey:@"message"] andDisappearTime:0.5];
                                              }
                                              NSLog(@"%@",responseObject);
                                          }];
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
- (void)changeUI:(NSDictionary *)dic {
    UILabel *label = [self.view viewWithTag:4334];
    UIImageView *imageView = [self.view viewWithTag:4333];
    stateBtn.hidden = NO;
    if ([[dic objectForKey:@"audit_status"] isEqualToString:@"2"]) {
        [stateBtn setTitle:@"审核中" forState:UIControlStateNormal];
        [carImageViewBtn setTitle:@"审核中..." forState:UIControlStateNormal];
        carImageViewBtn.userInteractionEnabled = NO;
        label.text = @"系统审核中，暂时不可修改信息";
        imageView.image = [UIImage imageNamed:@"bg_certification"];
        stateBtn.selected = NO;
    } else if ([[dic objectForKey:@"audit_status"] isEqualToString:@"4"]) {
        [stateBtn setTitle:@"认证失败" forState:UIControlStateNormal];
        [carImageViewBtn setTitle:@"立即查看" forState:UIControlStateNormal];
        imageView.image = [UIImage imageNamed:@"bg_certification"];
        carImageViewBtn.userInteractionEnabled = YES;
        label.text = [dic objectForKey:@"audit_opinion"];
        stateBtn.selected = NO;
    } else if ([[dic objectForKey:@"audit_status"] isEqualToString:@"3"]) {
        [stateBtn setTitle:@"认证成功" forState:UIControlStateNormal];
        [carImageViewBtn setTitle:@"邀请车主" forState:UIControlStateNormal];
        carImageViewBtn.userInteractionEnabled = YES;
        label.text = @"";
        imageView.image = [UIImage imageNamed:@"bg_invitation"];
        stateBtn.selected = YES;
    } else {
        imageView.image = [UIImage imageNamed:@"bg_certification"];
        stateBtn.hidden = YES;
    }
    [UserDefaults saveValue:[dic objectForKey:@"vehicle_color"] forKey:@"vehicle_color"];
    [UserDefaults saveValue:[dic objectForKey:@"vehicle_brand"] forKey:@"vehicle_brand"];
    [UserDefaults saveValue:[dic objectForKey:@"license_plate"] forKey:@"license_plate"];
}
- (void)pushNextView:(NSString *)info {
    if ([info isEqualToString:@"back"]) {
        PersonnalCenterController *vc = [[PersonnalCenterController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([info isEqualToString:@"choose"]) {
        NSLog(@"点击乘客切换按钮");
        [self changeDriver];
    } else {
        NotifyController *vc = [[NotifyController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
- (void)chooseAction:(UIButton *)button {
    if (button.tag == 1230) {
        [backView removeFromSuperview];
    } else {
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        window.rootViewController  = [[UINavigationController alloc] initWithRootViewController:[[DriverController alloc] init]];
    }
}
- (void)cancelKeybord:(UITapGestureRecognizer*)tap {
    [backView removeFromSuperview];
}
- (void)changeADScrollView:(NSArray *)arr {
    [_adScrollView removeFromSuperview];
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in arr) {
        NSString *imageString = [NSString stringWithFormat:@"http://%@/%@",FRHEAD,[dic objectForKey:@"banner_img"]];
        [imageArr addObject:imageString];
    }
    _adScrollView = [[GCCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, XMAKENEW(120))];
    _adScrollView.delegate =self;
//    NSArray *urlimages = [[NSArray alloc] initWithObjects:@"http://pics.sc.chinaz.com/files/pic/pic9/201603/apic19563.jpg",@"http://pics.sc.chinaz.com/files/pic/pic9/201603/apic19747.jpg",@"http://pics.sc.chinaz.com/files/pic/pic9/201603/apic19515.jpg",@"http://pics.sc.chinaz.com/files/pic/pic9/201602/apic18951.jpg",nil];
    _adScrollView.imageUrlGroups = imageArr;
    _adScrollView.autoScrollTimeInterval = 3.0;
    _adScrollView.dotColor = COLOR_ORANGE;
    [headView addSubview:_adScrollView];
}
- (void)createUI {
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, XMAKENEW(160))];
    UIImage *image1 = [UIImage imageNamed:@"bg_certification"];
    UIImage *image2 = [UIImage imageNamed:@"bg_invitation"];
    //    UIImage *image3 = [UIImage imageNamed:@"banner03"];
    NSArray *arr = @[image1,image2];
    _adScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, XMAKENEW(120)) ];
    _adScrollView.delegate = self;
    [headView addSubview:_adScrollView];
    
    NSArray *nameArr = @[@"我是乘客",@"认证车主"];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, XMAKENEW(40))];
        btn.center = CGPointMake(SCREEN_WIDTH/3*(i+1), CGRectGetMaxY(_adScrollView.frame)+XMAKENEW(20));
        btn.tag = 10000+i;
        if (i == 0) {
            btn.selected = YES;
        }
        [btn setTitle:nameArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_ORANGE forState:UIControlStateSelected];
        [btn setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(chooseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:btn];
    }
    stateBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2+XMAKENEW(30), CGRectGetMaxY(_adScrollView.frame)+XMAKENEW(12), XMAKENEW(50), XMAKENEW(12))];
    [stateBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, XMAKENEW(3), 0, 0)];
    [stateBtn setBackgroundImage:[UIImage imageNamed:@"fail"] forState:UIControlStateNormal];
    [stateBtn setBackgroundImage:[UIImage imageNamed:@"success"] forState:UIControlStateSelected];
    [stateBtn setTitle:@"认证失败" forState:UIControlStateNormal];
    stateBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    stateBtn.hidden = YES;
    stateBtn.userInteractionEnabled = NO;
    [headView addSubview:stateBtn];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_adScrollView.frame)+XMAKENEW(39.5), SCREEN_WIDTH, XMAKENEW(0.5 ))];
    line.tag = 10009;
    line.backgroundColor = COLOR_TEXT_LIGHT;
    [headView addSubview:line];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(60), 1)];
    lineView.backgroundColor = COLOR_ORANGE;
    lineView.tag = 10010;
    lineView.center = CGPointMake(SCREEN_WIDTH/3, CGRectGetMinY(line.frame));
    [headView addSubview:lineView];
    [self.view addSubview:headView];
}
- (void)chooseBtn:(UIButton *)button {
    UIButton *btn1 = [self.view viewWithTag:10000];
    UIButton *btn2 = [self.view viewWithTag:10001];
    UILabel *line = [self.view viewWithTag:10009];
    UIView *lineView = [self.view viewWithTag:10010];
    //    btn1.selected = !btn1.selected;
    //    btn2.selected = !btn2.selected;
    if (button.tag == 10001 && btn2.selected == NO) {
        btn1.selected = !btn1.selected;
        btn2.selected = !btn2.selected;
        [UIView animateWithDuration:0.5 animations:^{
            lineView.center=CGPointMake(SCREEN_WIDTH/3*2, CGRectGetMinY(line.frame));
            _mainScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        } completion:nil];
    } else if (button.tag == 10000 && btn1.selected == NO){
        btn1.selected = !btn1.selected;
        btn2.selected = !btn2.selected;
        [UIView animateWithDuration:0.5 animations:^{
            lineView.center=CGPointMake(SCREEN_WIDTH/3*1, CGRectGetMinY(line.frame));
            _mainScrollView.contentOffset = CGPointMake(0, 0);
        } completion:nil];
    }
    
}
- (NSMutableArray *)tableData {
    if (!_tableData) {
        _tableData = [NSMutableArray new];
    }
    return _tableData;
}
-(UITableView *)tableView {
    return _tableView;
}
- (UIView *)tableViewHeadView {
    UIView *HeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, XMAKENEW(185))];
    HeaderView.backgroundColor = [UIColor whiteColor];
    NSArray *imageName = @[@"start_eidt",@"end"];
    for (int i = 0; i < 2; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(15), XMAKENEW(15)+XMAKENEW(35)*i, XMAKENEW(10), XMAKENEW(10))];
        imageView.image = [UIImage imageNamed:imageName[i]];
        [HeaderView addSubview:imageView];
        
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+XMAKENEW(10), CGRectGetMinY(imageView.frame)-XMAKENEW(5), SCREEN_WIDTH-XMAKENEW(150), XMAKENEW(20))];
        addressLabel.text = @"太原市万国城MOMA";
        addressLabel.font = [UIFont systemFontOfSize:13];
        addressLabel.textColor = COLOR_TEXT_DARK;
        addressLabel.tag = 10086+i;
        [HeaderView addSubview:addressLabel];
    }
    UIButton *endBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(40), XMAKENEW(45), SCREEN_WIDTH-XMAKENEW(150), XMAKENEW(20))];
    [endBtn addTarget:self action:@selector(endBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [HeaderView addSubview:endBtn];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(265), XMAKENEW(8), XMAKENEW(100), XMAKENEW(20))];
    [btn setTitle:@"查看定位" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:FONT12];
    [btn setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(findMe:) forControlEvents:UIControlEventTouchUpInside];
    [HeaderView addSubview:btn];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(10), CGRectGetMaxY(btn.frame)+XMAKENEW(8), SCREEN_WIDTH-XMAKENEW(20), 0.5)];
    line.backgroundColor = COLOR_background;
    [HeaderView addSubview:line];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame)+XMAKENEW(38), SCREEN_WIDTH, XMAKENEW(115))];
    backView.backgroundColor = COLOR_background;
    [HeaderView addSubview:backView];
    NSArray *titleName = @[@"常用路线",@"顺路合乘"];
    for (int i = 0; i < 2; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(12), XMAKENEW(5)+XMAKENEW(85)*i, XMAKENEW(100), XMAKENEW(25))];
        titleLabel.text = titleName[i];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = COLOR_TEXT_DARK;
        [backView addSubview:titleLabel];
        
        UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(310), CGRectGetMinY(titleLabel.frame)-XMAKENEW(3), XMAKENEW(55), XMAKENEW(30))];
        [moreBtn setTitle:@"管理" forState:UIControlStateNormal];
        [moreBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
        [moreBtn setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:FONT12];
        [moreBtn addTarget:self action:@selector(nextInfo:) forControlEvents:UIControlEventTouchUpInside];
        moreBtn.tag = 1111+i;
        [backView addSubview:moreBtn];
    }
    UIView *whithView = [[UIView alloc] initWithFrame:CGRectMake(XMAKENEW(12), XMAKENEW(35), XMAKENEW(351), XMAKENEW(50))];
    whithView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:whithView];
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:whithView.bounds];
    [nextBtn addTarget:self action:@selector(comRoute:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitleColor:COLOR_ORANGE forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:FONT12];
    [whithView addSubview:nextBtn];
    
    if (_routeDic) {
        [nextBtn setTitle:@"+添加常用线路，寻找同行车主" forState:UIControlStateNormal];
    } else {
        for (int i = 0; i < 2; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(10), XMAKENEW(5)+XMAKENEW(20)*i, XMAKENEW(20), XMAKENEW(20))];
            imageView.image = [UIImage imageNamed:imageName[i]];
            [whithView addSubview:imageView];
            
            UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+XMAKENEW(10), CGRectGetMinY(imageView.frame), SCREEN_WIDTH-XMAKENEW(150), XMAKENEW(20))];
            addressLabel.text = @"太原市万国城MOMA";
            addressLabel.font = [UIFont systemFontOfSize:13];
            addressLabel.textColor = COLOR_TEXT_DARK;
            [whithView addSubview:addressLabel];
        }
        UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(325), XMAKENEW(15), XMAKENEW(20), XMAKENEW(20))];
        imageView1.image = [UIImage imageNamed:@"more"];
        [whithView addSubview:imageView1];
    }
    return HeaderView;
}
- (void)endBtnAction:(UIButton *)button {
    ChooseEndCityController *vc = [[ChooseEndCityController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)comRoute:(UIButton *)button {
    NSLog(@"点击常用线路");
}
- (void)nextInfo:(UIButton *)button {
    if (button.tag == 1111) {
        NSLog(@"点击常用线路管理");
    } else {
//        NSArray *arr = @[];
//        NSLog(@"%@", arr[1]);
        NSLog(@"点击顺路合乘管理");
    }
}
- (void)findMe:(UIButton *)button {
    NSLog(@"点击定位按钮");
    MapViewController *map = [[MapViewController alloc] init];
    [self.navigationController pushViewController:map animated:YES];
}
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 40;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    if (!cell) {
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainCell"];
    }
    cell.blockBtn = ^(NSString *backInfo) {
        [self goNextBtn];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)goNextBtn {
    PerfectInfoController *VC= [[PerfectInfoController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    NSLog(@"点击与他同行");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 顶部滚动广告
- (UIView *)setAdvertisementView {
    UIImage *image1 = [UIImage imageNamed:@"bg_certification"];
    UIImage *image2 = [UIImage imageNamed:@"bg_Invitation"];
    //    UIImage *image3 = [UIImage imageNamed:@"banner03"];
    NSArray *arr = @[image1,image2];
//    _adScrollView = [[MainHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, YMAKENEW(180)) ADImageArray:arr];
//    _adScrollView.delegate = self;
    //文字广告栏;
    //    UIView *newsScroll = [self headerForSection0];
    //    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _adScrollView.bounds.size.height + newsScroll.bounds.size.height)];
    
    //    [headerView addSubview:_adScrollView];
    //    [headerView addSubview:newsScroll];
    return _adScrollView;
}
//  文字 滚动广告，(不能加载sectionHeader上，会一直创建)

- (void)moreNews {
    NSLog(@"点击图片");
}
#pragma mark -乘客车主的滚动视图
- (void)creatMainScrollView {
    UILabel *line = [self.view viewWithTag:10009];
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame)+68, SCREEN_WIDTH, self.view.frame.size.height-CGRectGetMaxY(line.frame)-68)];
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.delegate = self;
    _mainScrollView.bounces = NO;
    _mainScrollView.tag = 999;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.delegate = self;
    CGRect frame = _mainScrollView.frame;
    _mainScrollView.contentSize = CGSizeMake(frame.size.width * 2, frame.size.height);
    [self.view addSubview:_mainScrollView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _mainScrollView.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = COLOR_background;
    _tableView.tableHeaderView = [self tableViewHeadView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 102.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [_mainScrollView addSubview:_tableView];
    
    UIImageView *carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, _mainScrollView.frame.size.height)];
    carImageView.tag = 4333;
    carImageView.image = [UIImage imageNamed:@"bg_certification"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, carImageView.frame.size.height/9*5, SCREEN_WIDTH, XMAKENEW(80))];
    label.tag = 4334;
    label.text = @"申请认证成为出行有约车主\n让你“零”投资赚钱";
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.textColor = [UIColor whiteColor];
    [carImageView addSubview:label];
    
    carImageView.userInteractionEnabled = YES;
    carImageViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(12.5), CGRectGetMaxY(label.frame), XMAKENEW(350), XMAKENEW(35))];
    [carImageViewBtn setTitle:@"认证车主" forState:UIControlStateNormal];
    [carImageViewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [carImageViewBtn addTarget:self action:@selector(goToDriver:) forControlEvents:UIControlEventTouchUpInside];
    carImageViewBtn.backgroundColor = COLOR_ORANGE;
    carImageViewBtn.layer.cornerRadius = 3.0;//2.0是圆角的弧度，根据需求自己更改
    carImageViewBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    carImageViewBtn.layer.borderWidth = 0.5f;//设置边框颜色
    [carImageView addSubview:carImageViewBtn];
    
    [_mainScrollView addSubview:carImageView];
}
- (void)goToDriver:(UIButton *)button {
    DriverInfoController *vc = [[DriverInfoController alloc] init];
    if ([button.titleLabel.text isEqualToString:@"立即查看"]) {
        vc.isUped = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([button.titleLabel.text isEqualToString:@"邀请车主"]) {
        NSLog(@"邀请车主");
    }
}
#pragma mark - scrollew协议相关
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UILabel *line = [self.view viewWithTag:10009];
    UIView *lineView = [self.view viewWithTag:10010];
    if (scrollView.tag == 999) {
        lineView.center=CGPointMake(scrollView.contentOffset.x/3+SCREEN_WIDTH/3*1, CGRectGetMinY(line.frame));
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    UIButton *btn1 = [self.view viewWithTag:10000];
    UIButton *btn2 = [self.view viewWithTag:10001];
    UILabel *line = [self.view viewWithTag:10009];
    UIView *lineView = [self.view viewWithTag:10010];
    if (scrollView.tag == 999) {
        
        if (scrollView.contentOffset.x > SCREEN_WIDTH-1) {
            btn2.selected = YES;
            btn1.selected = NO;
            [UIView animateWithDuration:0.5 animations:^{
                lineView.center=CGPointMake(SCREEN_WIDTH/3*2, CGRectGetMinY(line.frame));
            } completion:nil];
        }else{
            btn1.selected = YES;
            btn2.selected = NO;
            [UIView animateWithDuration:0.5 animations:^{
                lineView.center=CGPointMake(SCREEN_WIDTH/3*1, CGRectGetMinY(line.frame));
            }completion:nil];
        }
    }
}

@end
