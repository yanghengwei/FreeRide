//
//  PerfectInfoController.m
//  FreeRide
//
//  Created by  on 2017/11/30.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "PerfectInfoController.h"
#import "PersonalNaviView.h"
#import "Header.h"
#import "PickView.h"
#import "CommentsController.h"
#import "PassengerController.h"
#import "TravelListController.h"
#import "WebViewController.h"

@interface PerfectInfoController ()
{
    UIView *moneyView;
    NSMutableDictionary *dateDic;
}
@end

@implementation PerfectInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_background;
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"完善行程信息" andRightTitle:@"计价规则"];
    [navi.rightBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    navi.block = ^(NSString *backInfo){
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self createUI];
    dateDic = [[NSMutableDictionary alloc] init];
}
- (void)createUI {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, XMAKENEW(159))];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    NSArray *arr = @[@"start_eidt",@"end_eidt",@"time_eidt",@"seat"];
    NSArray *labelArr = @[@"太原市万国城MOMA",@"朔州市输入详细地址",@"今天10:00-10:30",@"选择乘车人数"];
    for (int i = 0; i<4; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(15), XMAKENEW(12.5)+i*XMAKENEW(40), XMAKENEW(15), XMAKENEW(15))];
        imageView.image = [UIImage imageNamed:arr[i]];
        [headView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+XMAKENEW(15), XMAKENEW(10)+i*XMAKENEW(40), SCREEN_WIDTH, XMAKENEW(20))];
        label.font = [UIFont systemFontOfSize:13];
        label.text = labelArr[i];
        label.textColor = COLOR_TEXT_DARK;
        label.userInteractionEnabled = YES;
        label.tag = 660+i;
        [headView addSubview:label];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame), XMAKENEW(40)*(i+1), SCREEN_WIDTH-2*CGRectGetMinX(imageView.frame), 1)];
        line.backgroundColor = COLOR_background;
        [headView addSubview:line];
        if (i == 0) {
            UIButton *placeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-XMAKENEW(93), CGRectGetMinY(label.frame), XMAKENEW(80), label.frame.size.height)];
            [placeBtn setTitle:@"查看定位" forState:UIControlStateNormal];
            placeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            
            placeBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 4, 0);
            [placeBtn setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
            [placeBtn setTitleColor:COLOR_TEXT_LIGHT forState:UIControlStateNormal];
            [headView addSubview:placeBtn];
            
            UILabel *fristLine = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(placeBtn.frame), CGRectGetMinY(placeBtn.frame), 1, label.frame.size.height)];
            fristLine.backgroundColor = COLOR_background;
            [headView addSubview:fristLine];
        } else if (i==1) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTapToCityDetail:)];
            tap.numberOfTapsRequired = 1;
            label.attributedText = [self setLabelRichInfo:labelArr[i] andSmall:3 withColor:COLOR_TEXT_DARK];
            [label addGestureRecognizer:tap];
        } else if (i == 3) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTap:)];
            label.textColor = COLOR_TEXT_LIGHT;
            tap.numberOfTapsRequired = 1;
            [label addGestureRecognizer:tap];
        }
    }
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame)+5, SCREEN_WIDTH, XMAKENEW(60))];
    middleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:middleView];
    
    NSArray *btnName = @[@{@"name":@"行程备注",@"image":@"remarks_nor",@"selectImage":@"remarks_set"},@{@"name":@"更换乘车人",@"image":@"passenger_nor",@"selectImage":@"passenger_sel"}];
    for (int i = 0; i<2; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2*i, 0, SCREEN_WIDTH/2, middleView.frame.size.height)];
        [btn setTitle:[btnName[i] objectForKey:@"name"] forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:FONT12];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height+XMAKENEW(17) ,-btn.imageView.frame.size.width-XMAKENEW(8), 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-XMAKENEW(17), 0.0,0.0, -btn.titleLabel.bounds.size.width-XMAKENEW(8))];//图片距离右边框距离减少图片的宽度，其它不边
        [btn setImage:[UIImage imageNamed:[btnName[i] objectForKey:@"image"]]  forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[btnName[i] objectForKey:@"selectImage"]]  forState:UIControlStateSelected];
        btn.adjustsImageWhenHighlighted = NO;
        btn.tag = 230+i;
        [btn addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
        [middleView addSubview:btn];
    }
    UILabel *lines = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 8, 1, middleView.frame.size.height-16)];
    lines.backgroundColor = COLOR_background;
    [middleView addSubview:lines];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-XMAKENEW(100), SCREEN_WIDTH, XMAKENEW(100))];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    //登录
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(12.5), YMAKENEW(20), XMAKENEW(350), YMAKENEW(40))];
    [loginBtn setTitle:@"确认同行" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(tagerLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = COLOR_ORANGE;
    loginBtn.layer.cornerRadius = 3.0;//2.0是圆角的弧度，根据需求自己更改
    loginBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    loginBtn.layer.borderWidth = 0.5f;//设置边框颜色
    [footView addSubview:loginBtn];
    
    UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(loginBtn.frame), CGRectGetMaxY(loginBtn.frame)+XMAKENEW(2), XMAKENEW(205), XMAKENEW(30))];
    footLabel.text = @"点击确认预约，即表示您已经";
    footLabel.textColor = COLOR_TEXT_NORMAL;
    footLabel.textAlignment = NSTextAlignmentRight;
    footLabel.font = [UIFont systemFontOfSize:10];
    [footView addSubview:footLabel];
    
    UIButton *footBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(footLabel.frame), CGRectGetMinY(footLabel.frame), XMAKENEW(150), footLabel.frame.size.height)];
    [footBtn setTitle:@"同意《合乘规则》" forState:UIControlStateNormal];
    footBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [footBtn setTitleColor:COLOR_ORANGE forState:UIControlStateNormal];
    footBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [footBtn addTarget:self action:@selector(agreement) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:footBtn];
    
    moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(footView.frame)-XMAKENEW(100), SCREEN_WIDTH, XMAKENEW(100))];
    moneyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:moneyView];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(12), XMAKENEW(6), XMAKENEW(9.5), XMAKENEW(11))];
    titleImageView.image = [UIImage imageNamed:@"prompt"];
    [moneyView addSubview:titleImageView];
    
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleImageView.frame)+XMAKENEW(5), 0, SCREEN_WIDTH, XMAKENEW(25))];
    promptLabel.text = @"合乘为预约制，请您在预约后耐心等待司机";
    promptLabel.font = [UIFont systemFontOfSize:10];
    promptLabel.textColor = COLOR_TEXT_NORMAL;
    [moneyView addSubview:promptLabel];
    
    UILabel *lastLine = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(promptLabel.frame), SCREEN_WIDTH, 1)];
    lastLine.backgroundColor = COLOR_background;
    [moneyView addSubview:lastLine];
    
    NSArray *btnNameArr = @[@"拼座\n256.6元",@"不拼座\n306.6元"];
    for (int i = 0; i<2; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2*i, CGRectGetMaxY(lastLine.frame), SCREEN_WIDTH/2, moneyView.frame.size.height-promptLabel.frame.size.height)];
        btn.titleLabel.numberOfLines = 0;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:btnNameArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(choosePrice:) forControlEvents:UIControlEventTouchUpInside];
        btn.adjustsImageWhenHighlighted = NO;
        btn.tag = 990+i;
        if (i==0) {
            btn.titleLabel.attributedText = [self setLabelInfo:btnNameArr[i] andSmall:i+2 withColor:COLOR_ORANGE];
            btn.selected = YES;
        } else {
            btn.titleLabel.attributedText = [self setLabelInfo:btnNameArr[i] andSmall:i+2 withColor:COLOR_TEXT_DARK];
        }
        [btn setTitleColor:COLOR_ORANGE forState:UIControlStateSelected];
        [btn setTitleColor:COLOR_TEXT_DARK forState:UIControlStateNormal];
        [moneyView addSubview:btn];
    }
    UILabel *moneyLine = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, CGRectGetMaxY(lastLine.frame)+(moneyView.frame.size.height-promptLabel.frame.size.height)/4, 1, (moneyView.frame.size.height-promptLabel.frame.size.height)/2)];
    moneyLine.backgroundColor = COLOR_background;
    [moneyView addSubview:moneyLine];
    
    UILabel *moneyLastLine = [[UILabel alloc] initWithFrame:CGRectMake(0, moneyView.frame.size.height-1, SCREEN_WIDTH, 1)];
    moneyLastLine.backgroundColor = COLOR_background;
    [moneyView addSubview:moneyLastLine];
    moneyView.hidden = YES;
}
- (NSMutableAttributedString *)setLabelRichInfo:(NSString *)string andSmall:(NSInteger)smallLong withColor:(UIColor *)color{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:13]
                    range:NSMakeRange(0, smallLong)];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:11]
                    range:NSMakeRange(smallLong, attrStr.length-smallLong)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:color
                    range:NSMakeRange(0, smallLong)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:COLOR_TEXT_LIGHT
                    range:NSMakeRange(smallLong, attrStr.length-smallLong)];
    return attrStr;
}
- (void)chooseTapToCityDetail:(UITapGestureRecognizer*)tap {
    NSLog(@"点击终点详细地址");
    UILabel *label = [self.view viewWithTag:661];
    label.text = @"朔州市市政府7号楼2单元3001";
}
- (void)chooseTap:(UITapGestureRecognizer*)tap {
    NSLog(@"点击选择乘车人数");
    UILabel *label = [self.view viewWithTag:663];
    PickView *pickView = [[PickView alloc] initWithFrame:self.view.bounds];
    if (label.text.length > 3) {
        pickView.selectInfo = @"1人";
    } else {
        pickView.selectInfo = label.text;
    }
    [pickView changePickSelected];
    pickView.pickBlock = ^(NSString *backInfo) {
        if (![backInfo isEqualToString:@""]) {
            label.text = backInfo;
            label.textColor = COLOR_TEXT_DARK;
            [dateDic setObject:backInfo forKey:@"personsNum"];
            moneyView.hidden = NO;
        }
    };
    [self.view addSubview:pickView];
}
- (NSMutableAttributedString *)setLabelInfo:(NSString *)string andSmall:(NSInteger)smallLong withColor:(UIColor *)color{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:11]
                    range:NSMakeRange(0, smallLong)];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:15]
                    range:NSMakeRange(smallLong, attrStr.length-smallLong)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:color
                    range:NSMakeRange(0, attrStr.length)];
    return attrStr;
}
- (void)btnSelected:(UIButton *)button {
    if (button.tag == 230) {
        CommentsController *vc = [[CommentsController alloc] init];
        if ([dateDic objectForKey:@"comments"]) {
            vc.selectInfo = [dateDic objectForKey:@"comments"];
        }
        vc.pickBlock = ^(NSString *backInfo) {
            [dateDic setValue:backInfo forKey:@"comments"];
            button.selected = YES;
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        PassengerController *vc = [[PassengerController alloc] init];
        if ([dateDic objectForKey:@"passenger"]) {
            vc.selectInfo = [dateDic objectForKey:@"passenger"];
        }
        vc.pickBlock = ^(NSDictionary *backInfo) {
            [dateDic setObject:backInfo forKey:@"passenger"];
            button.selected = YES;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)choosePrice:(UIButton *)button {
    button.selected = YES;
    if (button.tag == 990) {
        UIButton *btn = [self.view viewWithTag:991];
        btn.selected = NO;
        //        button.selected = YES;
    } else if (button.tag == 991) {
        UIButton *btn = [self.view viewWithTag:990];
        btn.selected = NO;
        //        button.selected = YES;
    }
}
- (void)tagerLoginBtn {
    TravelListController *VC = [[TravelListController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    NSLog(@"点击确认同行");
}
- (void)agreement {
    WebViewController *webView = [[WebViewController alloc] init];
    webView.titleName = @"合乘规则";
    webView.urlString = @"carpool_rule.html";
    [self.navigationController pushViewController:webView animated:YES];
}
- (void)pushNextView:(NSString *)info {
    if ([info isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        WebViewController *webView = [[WebViewController alloc] init];
        webView.titleName = @"计价规则";
        webView.urlString = @"valuation_rules.html";
        [self.navigationController pushViewController:webView animated:YES];
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
