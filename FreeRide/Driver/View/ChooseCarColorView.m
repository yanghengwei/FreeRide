//
//  ChooseCarColorView.m
//  FreeRide
//
//  Created by  on 2017/12/11.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "ChooseCarColorView.h"
#import "Header.h"
#import "CarColorCell.h"

@interface ChooseCarColorView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ChooseCarColorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseTapToCityDetail:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [backView addGestureRecognizer:tap];
    [self addSubview:backView];
    
    [self tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"CarColorCell" bundle:nil] forCellReuseIdentifier:@"CarColorCell"];
    [self dataSource];
    [_tableView reloadData];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/7.25*6.25, 446) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = [self createHeadView];
        _tableView.scrollEnabled = NO;
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 12)];
            [self.tableView setSeparatorColor:COLOR_background];
        }
        self.tableView.estimatedRowHeight = 60.0f;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.center = self.center;
        [self addSubview:_tableView];
    }
    return _tableView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
        [_dataSource addObjectsFromArray:@[@{@"color":[UIColor grayColor],@"label":@"银灰色"},
                                           @{@"color":[UIColor whiteColor],@"label":@"白色"},
                                           @{@"color":[UIColor blackColor],@"label":@"黑色"},
                                           @{@"color":[UIColor redColor],@"label":@"红色"},
                                           @{@"color":[UIColor brownColor],@"label":@"棕色"},
                                           @{@"color":[UIColor blueColor],@"label":@"蓝色"},
                                           @{@"color":[UIColor greenColor],@"label":@"绿色"},
                                           @{@"color":COLOR_ORANGE,@"label":@"橙色"},
                                           @{@"color":COLOR_background,@"label":@"其他"},
                                           ]];
    }
    return _dataSource;
}
- (UIView *)createHeadView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 50)];
    UILabel *title = [[UILabel alloc] initWithFrame:headView.bounds];
    title.text = @"车辆颜色";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:17];
    title.textColor = COLOR_TEXT_DARK;
    [headView addSubview:title];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(_tableView.frame.size.width-headView.frame.size.height/3*2, 0, headView.frame.size.height/3*2, headView.frame.size.height/3*2)];
    [button setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:button];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, headView.frame.size.height-1, headView.frame.size.width, 1)];
    line.backgroundColor = COLOR_background;
    [headView addSubview:line];
    return headView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CarColorCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"CarColorCell"];
    if (!cell) {
        cell = [[CarColorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CarColorCell"];
        
    }
    if (indexPath.row == 1 || indexPath.row == 8) {
        cell.colorImageView.layer.borderWidth = 1.0f;
        cell.colorImageView.layer.borderColor = [COLOR_TEXT_LIGHT CGColor];
    }
    if (indexPath.row == 8) {
        cell.colorImageView.image = [UIImage imageNamed:@"close"];
    }
    cell.colorImageView.backgroundColor = [_dataSource[indexPath.row] objectForKey:@"color"];
    cell.infoLabel.text = [_dataSource[indexPath.row] objectForKey:@"label"];
    if ([_chooseInfoStr isEqualToString:[_dataSource[indexPath.row] objectForKey:@"label"]]) {
        cell.selected = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.block([_dataSource[indexPath.row] objectForKey:@"label"]);
    [self removeView];
}
- (void)removeView {
    [self removeFromSuperview];
}
- (void)chooseTapToCityDetail:(UITapGestureRecognizer*)tap {
    [self removeFromSuperview];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}
@end
