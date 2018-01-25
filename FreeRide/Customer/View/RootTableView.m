//
//  RootTableView.m
//  FreeRide
//
//  Created by  on 2017/11/30.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "RootTableView.h"
#import "Header.h"
#import "MainTableViewCell.h"

@interface RootTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSouce;

@end

@implementation RootTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self doActions];
    }
    return self;
}
- (void)doActions {
    [self tableView];
    [self dataSouce];
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"mainCell"];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR_background;
        _tableView.tableHeaderView = [self tableViewHeadView];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.estimatedRowHeight = 102.0f;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        [self addSubview:_tableView];
    }
    return _tableView;
}
- (UIView *)tableViewHeadView {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    headView.backgroundColor = COLOR_background;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(XMAKENEW(12), 2.5, self.frame.size.width, 25)];
    titleLabel.text = @"顺路合乘车主5位";
    titleLabel.textColor = COLOR_TEXT_DARK;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [headView addSubview:titleLabel];
    
    return headView;
}
- (NSMutableArray *)dataSouce {
    if (!_dataSouce) {
        _dataSouce = [NSMutableArray new];
    }
    return _dataSouce;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    if (!cell) {
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainCell"];
    }
    cell.blockBtn = ^(NSString *backInfo) {
        self.blockBtn(backInfo);
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
