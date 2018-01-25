//
//  ChooseEndCityController.m
//  FreeRide
//
//  Created by  on 2017/11/29.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "ChooseEndCityController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "RouteChooseController.h"

@interface ChooseEndCityController ()

@end

@implementation ChooseEndCityController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUI];
}
- (void)createUI{
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"选择终点城市" andRightTitle:@""];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(12), 68+XMAKENEW(5), SCREEN_WIDTH, XMAKENEW(30))];
    label.text = @"所有跨城车主";
    label.textColor = COLOR_TEXT_DARK;
    label.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:label];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(label.frame), SCREEN_WIDTH-XMAKENEW(12), label.frame.size.height)];
    rightLabel.textColor = COLOR_ORANGE;
    rightLabel.font = [UIFont systemFontOfSize:13];
    rightLabel.text = @"共34人";
    rightLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:rightLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame)+XMAKENEW(5), SCREEN_WIDTH-2*CGRectGetMinX(label.frame), 1)];
    line.backgroundColor = COLOR_TEXT_LIGHT;
    line.tag = 1104;
    [self.view addSubview:line];
    
    [self createBtnFrame];
}
- (void)pushNextView:(NSString *)info {
    if ([info isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)createBtnFrame {
    NSArray *arr = @[@"朔州（5人）",@"朔州（5人）",@"朔州（5人）",@"朔州（5人）",@"朔州（5人）",@"朔州（5人）",@"朔州（5人）",@"朔州（5人）",@"朔州（5人）",@"朔州（5人）",@"朔州（5人）",@"朔州（5人）",@"朔州（5人）",@"朔州（5人）",@"朔州（5人）"];
    CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
    UILabel *line = [self.view viewWithTag:1104];
    CGFloat h = CGRectGetMaxY(line.frame)+15;//用来控制button距离父视图的高
    for (int i = 0; i < arr.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitleColor:COLOR_ORANGE forState:UIControlStateSelected];
        [button setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
        //设置圆角的半径
        [button.layer setCornerRadius:15];
        //切割超出圆角范围的子视图
        button.layer.masksToBounds = YES;
        //设置边框的颜色
        [button.layer setBorderColor:COLOR_TEXT_LIGHT.CGColor];
        //设置边框的粗细
        [button.layer setBorderWidth:1.0];
        //根据计算文字的大小
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        CGFloat length = [arr[i] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //为button赋值
        [button setTitle:arr[i] forState:UIControlStateNormal];
        //设置button的frame
        button.frame = CGRectMake(10 + w, h, length + 12 , 30);
        //当button的位置超出屏幕边缘时换行 SCREEN_WIDTH 只是button所在父视图的宽度
        if(10 + w + length + 10 > SCREEN_WIDTH){
            w = 0; //换行时将w置为0
            h = h + button.frame.size.height + 10;//距离父视图也变化
            button.frame = CGRectMake(10 + w, h, length + 12, 30);//重设button的frame
        }
        w = button.frame.size.width + button.frame.origin.x;
        [self.view addSubview:button];
    }
}
//点击事件
- (void)handleClick:(UIButton *)btn{
//    btn.selected = !btn.selected;
//    if (btn.selected) {
//        [btn.layer setBorderColor:COLOR_ORANGE.CGColor];
//    } else {
//        [btn.layer setBorderColor:COLOR_TEXT_LIGHT.CGColor];
//    }
    NSLog(@"%ld",btn.tag);
    RouteChooseController *vc = [[RouteChooseController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
