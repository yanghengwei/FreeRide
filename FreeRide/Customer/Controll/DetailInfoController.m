//
//  DetailInfoController.m
//  FreeRide
//
//  Created by pc on 2017/11/17.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "DetailInfoController.h"
#import "PersonalNaviView.h"
#import "Header.h"

@interface DetailInfoController ()

@end

@implementation DetailInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_background;
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"订单信息" andRightTitle:@""];
    [navi.rightBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self createUI];
}
- (void)pushNextView:(NSString *)info {
        [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUI {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 73, SCREEN_WIDTH, XMAKENEW(115))];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(12), 0, SCREEN_WIDTH, XMAKENEW(35))];
    firstLabel.text = @"乘车人信息";
    firstLabel.textColor = COLOR_TEXT_NORMAL;
    firstLabel.font = [UIFont systemFontOfSize:13];
    [headView addSubview:firstLabel];
    
    UILabel *firstLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(-XMAKENEW(12), 0, SCREEN_WIDTH, XMAKENEW(35))];
    firstLabel2.textColor = COLOR_TEXT_NORMAL;
    firstLabel2.text = @"已通过短信通知乘车人";
    firstLabel2.font = [UIFont systemFontOfSize:13];
    firstLabel2.textAlignment = NSTextAlignmentRight;
    [headView addSubview:firstLabel2];
    
    UILabel *firstLine = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(firstLabel.frame), SCREEN_WIDTH, 1)];
    firstLine.backgroundColor = COLOR_background;
    [headView addSubview:firstLine];
    
    NSArray *leftNameArr = @[@"姓名",@"手机号"];
    NSArray *rightNameArr = @[@"张校长",@"15234568908"];
    for ( int i = 0; i < 2; i++) {
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(12), CGRectGetMaxY(firstLine.frame)+i*XMAKENEW(40), SCREEN_WIDTH, XMAKENEW(40))];
        leftLabel.text = leftNameArr[i];
        leftLabel.textColor = COLOR_TEXT_DARK;
        leftLabel.font = [UIFont systemFontOfSize:13];
        [headView addSubview:leftLabel];
        
        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(80), CGRectGetMinY(leftLabel.frame), SCREEN_WIDTH, leftLabel.frame.size.height)];
        rightLabel.text = rightNameArr[i];
        rightLabel.textColor = COLOR_TEXT_DARK;
        rightLabel.font = [UIFont systemFontOfSize:13];
        [headView addSubview:rightLabel];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(leftLabel.frame), CGRectGetMaxY(leftLabel.frame), SCREEN_WIDTH-2*CGRectGetMinX(leftLabel.frame), 1)];
        line.backgroundColor = COLOR_background;
        [headView addSubview:line];
    }
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame)+XMAKENEW(5), SCREEN_WIDTH, XMAKENEW(100))];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(12), 0, SCREEN_WIDTH, XMAKENEW(35))];
    footLabel.text = @"行程备注";
    footLabel.textColor = COLOR_TEXT_NORMAL;
    footLabel.font = [UIFont systemFontOfSize:13];
    [footView addSubview:footLabel];
    
    UILabel *footline = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(footLabel.frame), SCREEN_WIDTH, 1)];
    footline.backgroundColor = COLOR_background;
    [footView addSubview:footline];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(footLabel.frame), CGRectGetMaxY(footline.frame)+XMAKENEW(2), SCREEN_WIDTH-2*CGRectGetMinX(footLabel.frame), XMAKENEW(65))];
    infoLabel.text = @"有大件行李，需要使用后备箱；由于赶飞机，希望车主可以准时到达。有大件行李，需要使用后备箱；";
    infoLabel.textColor = COLOR_TEXT_DARK;
    infoLabel.font = [UIFont systemFontOfSize:13];
    infoLabel.numberOfLines = 0;
    [footView addSubview:infoLabel];
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
