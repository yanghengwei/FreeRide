//
//  MakeInvoiceController.m
//  FreeRide
//
//  Created by  on 2017/12/12.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "MakeInvoiceController.h"
#import "Header.h"
#import "PersonalNaviView.h"

@interface MakeInvoiceController ()

@end

@implementation MakeInvoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"关于我们" andRightTitle:@""];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    self.view.backgroundColor = COLOR_background;
    [self creatUI];
}
- (void)pushNextView:(NSString *)info {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)creatUI {
    UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 80, SCREEN_WIDTH-24, self.view.frame.size.height-72)];
    mainLabel.numberOfLines = 0;
    NSString *string = @"1、开票金额不包含优惠券及通行费（过路过桥费，小费、高速费、停车费等）；\n2、选择行程的开票内容目前只支持“服务费”；\n3、只可开具申请当日的发票，不可更改开票日期；\n4、根据《国家税务总局关于增值税发票开具有关问题的公告》（国家税务总局公告2017年第16号）的要求，自2017年7月1日起，开具发票时，如果购买方是企业的，需提供准确的纳税人识别号或统一社会信用代码，否则发票将无法用于企业报销；\n已办理”三证合一“的企业需提供统一社会信用代码；未办理”三证合一“的企业需提供税务登记证的纳税人识别号，即税号。\n5、若您需要纸质发票（机打发票），则需要您去服务站自行领取，如果您有任何疑问可咨询客服。客服热线：96508。";
    mainLabel.attributedText = [self getAttributedStringWithString:string];
    [mainLabel sizeToFit];
    [self.view addSubview:mainLabel];
}
-(NSAttributedString *)getAttributedStringWithString:(NSString *)string {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.0f; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:COLOR_TEXT_DARK
                             range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:14]
                             range:NSMakeRange(0, string.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:COLOR_ORANGE
                             range:NSMakeRange(string.length - 6, 5)];
    return attributedString;
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
