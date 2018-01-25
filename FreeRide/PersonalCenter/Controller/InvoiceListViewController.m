//
//  InvoiceListViewController.m
//  FreeRide
//
//  Created by pc on 2017/11/28.
//  Copyright © 2017年 JNR All rights reserved.
//  开具发票列表

#import "InvoiceListViewController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "InvoiceController.h"

@interface InvoiceListViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UILabel *titleLabel;
}
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation InvoiceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PersonalNaviView *navi = [[PersonalNaviView alloc] initWithFrame:CGRectMake(0, 0, XMAKENEW(375), 68) andName:@"开具发票" andRightTitle:@"开票历史"];
    [navi.rightBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    navi.block = ^(NSString *backInfo){
        [self pushNextView:backInfo];
    };
    [self.view addSubview:navi];
    [self tableView];
    [self tableData];
    [self createFootView];
    [self.tableView registerNib:[UINib nibWithNibName:@"InvoiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"InvoiceTableViewCell"];
}
- (void)pushNextView:(NSString *)info {
    if ([info isEqualToString:@"back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"开票历史");
    }
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, self.view.frame.size.height-68-XMAKENEW(70)) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_background;
        _tableView.tableFooterView = [[UIView alloc] init];
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            [self.tableView setSeparatorColor:COLOR_background];
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *)tableData {
    if (!_tableData) {
        _tableData = [[NSMutableArray alloc] init];
        NSArray *arr = @[@[@"",@""],@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""]];
        [_tableData addObjectsFromArray:arr];
    }
    [_tableView reloadData];
    return _tableData;
}
- (void)createFootView {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-XMAKENEW(70), SCREEN_WIDTH, XMAKENEW(70))];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(15), XMAKENEW(10), XMAKENEW(250), XMAKENEW(35))];
    titleLabel.attributedText = [self setLabelInfo:@"0" andNumTrip:@"0"];
    [footView addSubview:titleLabel];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame)-XMAKENEW(5), XMAKENEW(300), XMAKENEW(20))];
    detailLabel.text = @"只可开具申请当日的发票，不可更改开票日期！";
    detailLabel.textColor = COLOR_TEXT_NORMAL;
    detailLabel.font = [UIFont systemFontOfSize:11];
    [footView addSubview:detailLabel];
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(XMAKENEW(270), CGRectGetMinY(titleLabel.frame), XMAKENEW(97.5), XMAKENEW(50))];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(tagerLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.backgroundColor = COLOR_ORANGE;
    nextBtn.layer.cornerRadius = 3.0;//2.0是圆角的弧度，根据需求自己更改
    nextBtn.layer.borderColor = (__bridge CGColorRef _Nullable)(COLOR_ORANGE);//设置边框颜色
    nextBtn.layer.borderWidth = 0.5f;//设置边框颜色
    [footView addSubview:nextBtn];
}
- (void)tagerLoginBtn {
    NSLog(@"点击下一步");
    InvoiceController *vc = [[InvoiceController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSMutableAttributedString *)setLabelInfo:(NSString *)string andNumTrip:(NSString *)numTrp{
    UIColor *color;
    if ([numTrp isEqualToString:@"0"]) {
        color = COLOR_TEXT_NORMAL;
    } else {
        color = COLOR_ORANGE;
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@（已选%@个行程）",string ,numTrp]];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:18]
                    range:NSMakeRange(0, string.length+1)];
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:13]
                    range:NSMakeRange(string.length+1, attrStr.length-string.length-1)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:color
                    range:NSMakeRange(0, string.length+1)];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:COLOR_TEXT_DARK
                    range:NSMakeRange(string.length+1, attrStr.length-string.length-1)];
    return attrStr;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _tableData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableData[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *title = @[@"10月",@"9月"];
    UIView *sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, -0, SCREEN_WIDTH, 30)];
    sectionHeader.backgroundColor = COLOR_background;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(15), 3, SCREEN_WIDTH, 24)];
    label.textColor = COLOR_TEXT_NORMAL;
    label.font = [UIFont systemFontOfSize:13];
    label.text = title[section];
    [sectionHeader addSubview:label];
    
    if (section == 0) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH- XMAKENEW(77), 0, XMAKENEW(65), sectionHeader.frame.size.height)];
        [button setTitle:@"开票说明" forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button addTarget:self action:@selector(invoiceInfoInstructions:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [sectionHeader addSubview:button];
    }
    
    return sectionHeader;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    titleLabel.attributedText = [self setLabelInfo:@"256" andNumTrip:@"1"];
}
- (void)invoiceInfoInstructions:(UIButton *)button {
    NSLog(@"点击开票说明");
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"InvoiceTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InvoiceTableViewCell"];
        
    }
    //    cell.reloadBlock = ^(NSString *backInfo){
    //        NSLog(@"%@",backInfo);
    //        [self.tableView reloadData];
    //    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
