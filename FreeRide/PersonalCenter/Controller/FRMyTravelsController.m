
//
//  FRMyTravelsController.m
//  FreeRide
//
//  Created by  on 2017/12/7.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "FRMyTravelsController.h"
#import "Header.h"
#import "PersonalNaviView.h"
#import "FRMyTravelsCell.h"

@interface FRMyTravelsController () <UITableViewDelegate, UITableViewDataSource>
{
    UILabel *titleLabel;
}
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FRMyTravelsController

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
    [self.tableView registerNib:[UINib nibWithNibName:@"FRMyTravelsCell" bundle:nil] forCellReuseIdentifier:@"FRMyTravelsCell"];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 68, SCREEN_WIDTH, self.view.frame.size.height-68-XMAKENEW(70)) style:UITableViewStylePlain];
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
        NSArray *arr = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        [_tableData addObjectsFromArray:arr];
    }
    [_tableView reloadData];
    return _tableData;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"FRMyTravelsCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FRMyTravelsCell"];
        
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
