//
//  AboutUsController.m
//  FreeRide
//
//  Created by  on 2017/12/12.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "AboutUsController.h"
#import "Header.h"
#import "PersonalNaviView.h"

@interface AboutUsController ()

@end

@implementation AboutUsController

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
    NSString *string = @"        出行有约是一款为用户提供最快捷最方便的约车手机软件，让手机约车的生活方式更加时尚。您在出门之前就可以预约到车，充分节省您的时间。现在开通的路线有太原市到朔州市、朔州市到太原市。其他线路正在筹备中。\n我们的特色：\n专业约车-通过手机或者电话为自己或他人一键预约，方便快捷；\n专业司机-我们的司机全部培训上岗，专职为您服务；\n专业车辆-我们所有车辆状况良好，手续齐全；\n专业服务-我们的乘车环境舒适，赠送高额保险，门对门服务，用一流的服务让您的出行安全舒适；\n专业客服-我们的客服电话96508，您24小时的贴心管家。\n        我们用专业的团队和一流的服务让您摆脱头疼的12306验证码、发愁的派对购买大巴票和坐车被劫财的担心，让您的出行安全、高效、方便、快捷。同事为您避免了交通拥堵，节约了出行成本，倡行了环保公益，让您的出行更有意义、更有价值。\n        快约上您的小伙伴一起出行！让我们一起改变大家的出行方式吧！";
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
                             range:NSMakeRange(114, 4)];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:COLOR_ORANGE
                             range:NSMakeRange(144, 4)];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:COLOR_ORANGE
                             range:NSMakeRange(169, 4)];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:COLOR_ORANGE
                             range:NSMakeRange(191, 4)];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:COLOR_ORANGE
                             range:NSMakeRange(236, 4)];
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
