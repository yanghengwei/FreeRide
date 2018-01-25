//
//  CarsInfoTableView.m
//  FreeRide
//
//  Created by mac on 2017/12/29.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "CarsInfoTableView.h"
#import "Header.h"

@interface CarsInfoTableView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataBase;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation CarsInfoTableView

- (instancetype)initWithFrame:(CGRect)frame andType:(NSArray *)dataArr {
    self = [super initWithFrame:frame];
    if (self) {
        _dataBase = [[NSMutableArray alloc] init];
        [_dataBase addObjectsFromArray:dataArr];
        [self createUI];
    }
    return self;
}
- (void)createUI {
    UIView *baseView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:baseView];
    UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
    backgroudView.backgroundColor = [UIColor blackColor];
    backgroudView.alpha = 0.7;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTapToCityDetail:)];
    //    tap.numberOfTapsRequired = 1;
    //    tap.numberOfTouchesRequired = 1;
    [backgroudView addGestureRecognizer:tap];
    [baseView addSubview:backgroudView];
    
    UIView *dataView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height)];
    _tableView = [[UITableView alloc] initWithFrame:dataView.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableHeaderView = [self tableViewHeadView];
    [dataView addSubview:_tableView];
    [baseView addSubview:dataView];
    
    
}
- (UIView *)tableViewHeadView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 60)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:headView.bounds];
    titleLabel.text = @"型号";
    //    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = COLOR_TEXT_DARK;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:titleLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, headView.frame.size.width, 1)];
    line.backgroundColor = COLOR_background;
    [headView addSubview:line];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataBase.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.block(_dataBase[indexPath.row]);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *flag=@"cellFlag";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
    }
    [cell.textLabel setText:[self.dataBase[indexPath.row] objectForKey:@"name"]];
    return cell;
}
- (void)chooseTapToCityDetail:(UITapGestureRecognizer*)tap {
    [self removeFromSuperview];
}
@end

