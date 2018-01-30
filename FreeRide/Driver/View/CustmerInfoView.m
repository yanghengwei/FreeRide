
//
//  CustmerInfoView.m
//  FreeRide
//
//  Created by iOS on 2018/1/26.
//  Copyright © 2018年 pc. All rights reserved.
//

#import "CustmerInfoView.h"
#import "Header.h"

@implementation CustmerInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.width/2)];
    _imageView.image = [UIImage imageNamed:@"driver'slicense"];
    _imageView.layer.cornerRadius = _imageView.frame.size.width/2.0;
    _imageView.layer.masksToBounds = YES;
    _imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - XMAKENEW(12.5));
    [self addSubview:_imageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame), self.frame.size.width, self.frame.size.height-_imageView.frame.size.height)];
    _nameLabel.text = @"sdf ";
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_nameLabel];
}
@end
