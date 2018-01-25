//
//  TopUpController.m
//  FreeRide
//
//  Created by pc on 2017/11/25.
//  Copyright © 2017年 JNR All rights reserved.
//  充值

#import "TopUpController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "SetPassWordViewController.h"

@interface TopUpController ()
{
    NSInteger buttonTag;
    UILabel *lastLabel;
    UIView *headView;
}
@end

@implementation TopUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"我的钱包" andRightTitle:@""];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    self.view.backgroundColor = COLOR_background;
    [self createUI];
}
- (void)createUI {
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, XMAKENEW(160))];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(15), 0, SCREEN_WIDTH, XMAKENEW(30))];
    titleLabel.text = @"选择充值金额";
    titleLabel.textColor = COLOR_TEXT_NORMAL;
    titleLabel.font = [UIFont systemFontOfSize:13];
    [headView addSubview:titleLabel];
    
    NSArray *arr = @[@[@"100元",@"200元",@"300元"],@[@"500元",@"800元",@"1000元"]];
    for (int i = 0; i < 2; i++) {
        for (int j = 0;  j < 3; j++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame)+XMAKENEW(120)*j, CGRectGetMaxY(titleLabel.frame)+XMAKENEW(55)*i, XMAKENEW(105), XMAKENEW(45))];
            button.layer.cornerRadius = 3.0;//2.0是圆角的弧度，根据需求自己更改
            [button.layer setBorderColor:COLOR_TEXT_LIGHT.CGColor];
            button.layer.borderWidth = 1.0f;//设置边框颜色
            [button setTitle:arr[i][j] forState:UIControlStateNormal];
            [button setTitleColor:COLOR_TEXT_DARK forState:UIControlStateNormal];
            [button setTitleColor:COLOR_ORANGE forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.tag = 1000+i*10+j;
            [button addTarget:self action:@selector(chooseMoney:) forControlEvents:UIControlEventTouchUpInside];
            [headView addSubview:button];
        }
    }
    lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, XMAKENEW(133), XMAKENEW(360), XMAKENEW(30))];
    lastLabel.attributedText = [self setLabelInfo:@"0.00"];
    [lastLabel sizeToFit];
    lastLabel.frame = CGRectMake(SCREEN_WIDTH-lastLabel.frame.size.width-XMAKENEW(15), XMAKENEW(133), lastLabel.frame.size.width, XMAKENEW(30));
    [headView addSubview:lastLabel];
    
    [self.view addSubview:headView];
    
    UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame)+XMAKENEW(5), SCREEN_WIDTH, XMAKENEW(50))];
    cellView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:cellView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(15), XMAKENEW(15), XMAKENEW(20), XMAKENEW(20))];
    imageView.image = [UIImage imageNamed:@"WeChat"];
    [cellView addSubview: imageView];
    
    UILabel *wechatLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+XMAKENEW(5), XMAKENEW(10), SCREEN_WIDTH, XMAKENEW(30))];
    wechatLabel.text = @"微信支付";
    wechatLabel.textColor = COLOR_TEXT_DARK;
    wechatLabel.font =[UIFont systemFontOfSize:14];
    [cellView addSubview:wechatLabel];
    
    UIImageView *lastImageView = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(350), XMAKENEW(17.5), XMAKENEW(15), XMAKENEW(15))];
    lastImageView.image = [UIImage imageNamed:@"Selected"];
    [cellView addSubview:lastImageView];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-XMAKENEW(120), SCREEN_WIDTH, XMAKENEW(120))];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    //登录
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(12.5), YMAKENEW(30), XMAKENEW(350), YMAKENEW(40))];
    [loginBtn setTitle:@"确认充值" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(tagerLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor = COLOR_ORANGE;
    loginBtn.layer.cornerRadius = 3.0;//2.0是圆角的弧度，根据需求自己更改
    loginBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    loginBtn.layer.borderWidth = 0.5f;//设置边框颜色
    [footView addSubview:loginBtn];
    
    UILabel *footLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(loginBtn.frame), CGRectGetMaxY(loginBtn.frame)+XMAKENEW(5), XMAKENEW(225), XMAKENEW(30))];
    footLabel.text = @"点击确认，即表示你已同意";
    footLabel.textColor = COLOR_TEXT_DARK;
    footLabel.textAlignment = NSTextAlignmentRight;
    footLabel.font = [UIFont systemFontOfSize:13];
    [footView addSubview:footLabel];
    
    UIButton *footBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(footLabel.frame), CGRectGetMinY(footLabel.frame), XMAKENEW(150), footLabel.frame.size.height)];
    [footBtn setTitle:@"《充值协议》" forState:UIControlStateNormal];
    footBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [footBtn setTitleColor:COLOR_ORANGE forState:UIControlStateNormal];
    footBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [footBtn addTarget:self action:@selector(agreement) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:footBtn];
}
- (void)tagerLoginBtn {
    SetPassWordViewController *vc = [[SetPassWordViewController alloc] init];
    vc.titleName = @"设置支付密码";
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)agreement {
    NSLog(@"点击协议");
}
- (NSMutableAttributedString *)setLabelInfo:(NSString *)string {
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实际到账：%@",string]];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:13]
                    range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:COLOR_TEXT_DARK
                    range:NSMakeRange(0, 5)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:COLOR_ORANGE
                    range:NSMakeRange(5, attrStr.length-5)];
    return attrStr;
}
- (void)chooseMoney:(UIButton *)button {
    if (buttonTag) {
        UIButton *selectBtn = [self.view viewWithTag:buttonTag];
        selectBtn.selected = NO;
        [selectBtn.layer setBorderColor:COLOR_TEXT_LIGHT.CGColor];
    }
    button.selected = YES;
    buttonTag = button.tag;
    [button.layer setBorderColor:COLOR_ORANGE.CGColor];
    
    NSString *str = [NSString stringWithFormat:@"%@:00",[button.titleLabel.text substringToIndex:button.titleLabel.text.length-1]];
    lastLabel.attributedText = [self setLabelInfo:str];
    [lastLabel sizeToFit];
    lastLabel.frame = CGRectMake(SCREEN_WIDTH-lastLabel.frame.size.width-XMAKENEW(15), XMAKENEW(133), lastLabel.frame.size.width, XMAKENEW(30));
}
- (void)pushNextView:(NSString *)info {
    if ([info isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
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
