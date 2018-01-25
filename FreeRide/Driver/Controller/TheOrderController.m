//
//  TheOrderController.m
//  FreeRide
//
//  Created by  on 2017/12/6.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "TheOrderController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "CustomsListCell.h"

@interface TheOrderController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation TheOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_background;
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"当前订单" andRightTitle:@""];
    navi.block = ^(NSString *backInfo){
        NSLog(@"%@",backInfo);
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomsListCell" bundle:nil] forCellReuseIdentifier:@"CustomsListCell"];
    [self dataSource];
    [self.tableView reloadData];
}
- (void)pushNextView:(NSString *)info {
        [self.navigationController popViewControllerAnimated:YES];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, self.view.frame.size.height-68) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_background;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.estimatedRowHeight = 60.0f;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableHeaderView = [self createHeadView];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        [_dataSource addObjectsFromArray:@[@"",@""]];
    }
    return _dataSource;
}
- (UIView *)createHeadView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, XMAKENEW(55))];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, XMAKENEW(5), SCREEN_WIDTH, XMAKENEW(25))];
    timeLabel.attributedText = [self setLabelInfo:@"10:00-10:30-无座" andLong:2];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:timeLabel];
    
    NSArray *viewInfo = @[@{@"imageName":@"start",@"title":@"太原市"},@{@"imageName":@"end",@"title":@"朔州市"}];
    for (int i = 0; i < 2; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/4, XMAKENEW(30))];
        view.center = CGPointMake(SCREEN_WIDTH/3*(i+1), XMAKENEW(40));
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(XMAKENEW(15), XMAKENEW(10), XMAKENEW(10), XMAKENEW(10))];
        imageView.image = [UIImage imageNamed:[viewInfo[i] objectForKey:@"imageName"]];
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(35), 0, XMAKENEW(50), XMAKENEW(30))];
        label.text = [viewInfo[i] objectForKey:@"title"];
        label.textColor = COLOR_TEXT_DARK;
        label.font = [UIFont systemFontOfSize:14];
        [view addSubview:label];
        
        [headView addSubview:view];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(40), XMAKENEW(10))];
    imageView.image = [UIImage imageNamed:@"arrow"];
    imageView.center = CGPointMake(SCREEN_WIDTH/2, XMAKENEW(40));
    [headView addSubview:imageView];
    return headView;
}
- (NSMutableAttributedString *)setLabelInfo:(NSString *)string andLong:(NSInteger)stringLong{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:13]
                    range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:COLOR_TEXT_DARK
                    range:NSMakeRange(0, attrStr.length-stringLong)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:COLOR_ORANGE
                    range:NSMakeRange(attrStr.length-stringLong, stringLong)];
    return attrStr;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomsListCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"CustomsListCell"];
    if (!cell) {
        cell = [[CustomsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CustomsListCell"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
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
