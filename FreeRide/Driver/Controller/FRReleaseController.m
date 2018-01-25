//
//  FRReleaseController.m
//  FreeRide
//
//  Created by  on 2017/12/6.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "FRReleaseController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "PickView.h"

@interface FRReleaseController ()

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation FRReleaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_background;
    _dataArr = [[NSMutableArray alloc] init];
    [_dataArr addObjectsFromArray:@[@"太原市",@"朔州市",@"",@"",@""]];
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"发布行程" andRightTitle:@""];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self createUI];
}
- (void)createUI {
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, XMAKENEW(160))];
    mainView.backgroundColor = [UIColor whiteColor];
    NSArray *imageNameArr = @[@"start",@"end",@"date",@"seat"];
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(15), XMAKENEW(13)+i*XMAKENEW(40), XMAKENEW(14), XMAKENEW(14))];
        imageView.image = [UIImage imageNamed:imageNameArr[i]];
        [mainView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+XMAKENEW(10), XMAKENEW(5)+i*XMAKENEW(40), SCREEN_WIDTH-2*CGRectGetMaxX(imageView.frame), XMAKENEW(30))];
        label.tag = 600+i;
        label.userInteractionEnabled = YES;
        label.font = [UIFont systemFontOfSize:13];
        if (i==2) {
            label.frame = CGRectMake(CGRectGetMaxX(imageView.frame)+XMAKENEW(10), XMAKENEW(5)+i*XMAKENEW(40), SCREEN_WIDTH/2-CGRectGetMaxX(imageView.frame)-XMAKENEW(10), XMAKENEW(30));
            UILabel *Vline = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, XMAKENEW(80), 1, XMAKENEW(40))];
            Vline.backgroundColor = COLOR_background;
            [mainView addSubview:Vline];
            UIImageView *timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+XMAKENEW(13), CGRectGetMinY(imageView.frame), imageView.frame.size.width, imageView.frame.size.height)];
            timeImageView.image = [UIImage imageNamed:@"time"];
            [mainView addSubview:timeImageView];
            UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeImageView.frame)+XMAKENEW(7), CGRectGetMinY(label.frame), label.frame.size.width, label.frame.size.height)];
            timeLabel.font = [UIFont systemFontOfSize:13];
            timeLabel.tag = 604;
            timeLabel.userInteractionEnabled = YES;
            [mainView addSubview:timeLabel];
            UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTapToCityDetail:)];
            tap1.numberOfTapsRequired = 1;
            [timeLabel addGestureRecognizer:tap1];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTapToCityDetail:)];
        tap.numberOfTapsRequired = 1;
        [label addGestureRecognizer:tap];
        [mainView addSubview:label];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame), XMAKENEW(40)*(i+1), SCREEN_WIDTH-2*CGRectGetMinX(imageView.frame), 1)];
        line.backgroundColor = COLOR_background;
        [mainView addSubview:line];
    }
    [self.view addSubview:mainView];
    [self reloadData];
    
    //确认发布
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(12.5), CGRectGetMaxY(mainView.frame)+YMAKENEW(55), XMAKENEW(350), YMAKENEW(40))];
    [loginBtn setTitle:@"确认发布" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(tagerLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = COLOR_ORANGE;
    loginBtn.layer.cornerRadius = 3.0;//2.0是圆角的弧度，根据需求自己更改
    loginBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    loginBtn.layer.borderWidth = 0.5f;//设置边框颜色
    [self.view addSubview:loginBtn];
}
- (void)tagerLoginBtn {
    NSLog(@"点击确认发布");
}
- (void)reloadData {
    NSArray *placeHoldArr = @[@"选择出发城市",@"选择到达城市",@"选择出发日期",@"选择座位数",@"选择出发时间"];
    for (int i = 0; i<5; i++) {
        UILabel *label = [self.view viewWithTag:600+i];
        if ([_dataArr[i] length]>0) {
            label.text = _dataArr[i];
            label.textColor = COLOR_TEXT_DARK;
        } else {
            label.text = placeHoldArr[i];
            label.textColor = COLOR_TEXT_LIGHT;
        }
    }
}
- (void)chooseTapToCityDetail:(UITapGestureRecognizer*)tap {
    if (tap.view.tag == 600) {
        NSLog(@"点击出发城市");
    } else if (tap.view.tag == 601) {
        NSLog(@"点击到达城市");
    } else if (tap.view.tag == 602) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM月dd日"];
        NSDate *datenow = [NSDate date];
        NSDate *Day1 = [NSDate dateWithTimeInterval:1*24*60*60 sinceDate:datenow];
        NSDate *Day2 = [NSDate dateWithTimeInterval:2*24*60*60 sinceDate:datenow];
        NSDate *Day3 = [NSDate dateWithTimeInterval:3*24*60*60 sinceDate:datenow];
        NSDate *Day4 = [NSDate dateWithTimeInterval:4*24*60*60 sinceDate:datenow];
        PickView *pick = [[PickView alloc] initWithFrame:self.view.bounds];
        pick.titleLabel.text = @"请选择出发日期";
        pick.pickerData = @[[formatter stringFromDate:datenow],[formatter stringFromDate:Day1],[formatter stringFromDate:Day2],[formatter stringFromDate:Day3],[formatter stringFromDate:Day4]];
        pick.selectInfo = _dataArr[2];
        pick.pickBlock = ^(NSString *backInfo) {
            [_dataArr replaceObjectAtIndex:2 withObject:backInfo];
            [self reloadData];
        };
        [pick changePickSelected];
        [self.view addSubview:pick];
    } else if (tap.view.tag == 603) {
        PickView *pick = [[PickView alloc] initWithFrame:self.view.bounds];
        pick.titleLabel.text = @"请选择空余座位数";
        pick.pickerData = @[@"空余1座",@"空余2座",@"空余3座",@"空余4座",@"空余5座",@"空余6座"];
        pick.selectInfo = _dataArr[3];
        [pick changePickSelected];
        pick.pickBlock = ^(NSString *backInfo) {
            [_dataArr replaceObjectAtIndex:3 withObject:backInfo];
            [self reloadData];
        };
        [self.view addSubview:pick];
    } else if (tap.view.tag == 604) {
        PickView *pick = [[PickView alloc] initWithFrame:self.view.bounds];
        pick.titleLabel.text = @"请选择出发时间";
        pick.pickerData = @[@"08:30-09:00",@"09:00-10:00",@"10:30-11:00",@"14:00-14:30",@"15:30-16:00",@"17:00-18:00"];
        pick.selectInfo = _dataArr[4];
        pick.pickBlock = ^(NSString *backInfo) {
            [_dataArr replaceObjectAtIndex:4 withObject:backInfo];
            [self reloadData];
        };
        [pick changePickSelected];
        [self.view addSubview:pick];
    }
}
- (void)pushNextView:(NSString *)info {
    [self.navigationController popViewControllerAnimated:YES];
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
