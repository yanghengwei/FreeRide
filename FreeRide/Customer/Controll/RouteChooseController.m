//
//  RouteChooseController.m
//  FreeRide
//
//  Created by  on 2017/11/29.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "RouteChooseController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "RootTableView.h"
#import "PerfectInfoController.h"

@interface RouteChooseController () <UIScrollViewDelegate>
{
    UIView *line;
    UIView *headView;
    NSInteger selectedBtnTag;
}

@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation RouteChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_background;
    [self createBtnFrame];
}
- (void)createBtnFrame {
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"顺路车主" andRightTitle:@""];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, XMAKENEW(40))];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    NSDate *datenow = [NSDate date];
    NSDate *nextDay = [NSDate dateWithTimeInterval:3*24*60*60 sinceDate:datenow];
    NSDate *thirdDay = [NSDate dateWithTimeInterval:4*24*60*60 sinceDate:datenow];
    NSArray *titleArr = @[@"今天",@"明天",@"后天",[formatter stringFromDate:nextDay],[formatter stringFromDate:thirdDay]];
    for (int i=0; i<5; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/5*i, XMAKENEW(5), SCREEN_WIDTH/5, XMAKENEW(30))];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_ORANGE forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.tag = 600+i;
        [btn addTarget:self action:@selector(chooseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:btn];
    }
    
    line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/6, 1)];
    line.backgroundColor = COLOR_ORANGE;
    [headView addSubview:line];
    
    UIButton *btn = [self.view viewWithTag:600];
    selectedBtnTag = 600;
    line.center = CGPointMake(CGRectGetMinX(btn.frame)+btn.frame.size.width/2, headView.frame.size.height-0.5);
    btn.selected = YES;
    [self scrollView];
}
- (void)chooseBtn:(UIButton *)button {
    for (int i=0; i<5; i++) {
        UIButton *btn = [self.view viewWithTag:600+i];
        if (button.tag == btn.tag) {
            btn.selected = YES;
            [UIView animateWithDuration:0.5 animations:^{
//                line.center=CGPointMake(CGRectGetMinX(btn.frame)+btn.frame.size.width/2, -0.5+XMAKENEW(40));
                _mainScrollView.contentOffset = CGPointMake(SCREEN_WIDTH*i, 0);
                selectedBtnTag = btn.tag;
            } completion:nil];
        } else {
            btn.selected = NO;
        }
    }
}
- (void)scrollView {
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 68+XMAKENEW(40), SCREEN_WIDTH, self.view.frame.size.height-68-XMAKENEW(40))];
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.delegate = self;
    _mainScrollView.bounces = NO;
    _mainScrollView.tag = 999;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.delegate = self;
    CGRect frame = _mainScrollView.frame;
    _mainScrollView.contentSize = CGSizeMake(frame.size.width * 5, frame.size.height);
    [self.view addSubview:_mainScrollView];
    
    for (int i=0; i<5; i++) {
        RootTableView *tableView = [[RootTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, _mainScrollView.frame.size.height)];
        tableView.blockBtn = ^(NSString *backInfo) {
            [self nextBtnAction];
        };
        [_mainScrollView addSubview:tableView];
    }
}
- (void)nextBtnAction {
    PerfectInfoController *VC= [[PerfectInfoController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    NSLog(@"一起同行");
}
- (void)pushNextView:(NSString *)info {
    if ([info isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - scrollew协议相关
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 999) {
        line.center=CGPointMake(scrollView.contentOffset.x/SCREEN_WIDTH*(SCREEN_WIDTH/5)+SCREEN_WIDTH/10, -0.5+XMAKENEW(40));
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger num = scrollView.contentOffset.x/SCREEN_WIDTH;
    UIButton *btn1 = [self.view viewWithTag:selectedBtnTag];
    UIButton *btn2 = [self.view viewWithTag:600+num];
    btn1.selected = NO;
    btn2.selected = YES;
    selectedBtnTag = btn2.tag;
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
