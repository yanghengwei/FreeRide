//
//  MainHeadView.h
//  FreeRide
//
//  Created by  on 2017/11/13.
//  Copyright © 2017年 JNR All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SSCAdScrollViewDelegate <NSObject>

@optional
-(void)AdScrollerViewDidClicked:(NSUInteger)index;
@end

@interface MainHeadView : UIView

- (instancetype)initWithFrame:(CGRect)frame ADImageArray:(NSArray *)imageArr;

@property (strong, nonatomic) NSArray *images;//轮播图图片数组
@property (strong, nonatomic) NSArray *urls; //轮播图对应url
@property (strong, nonatomic) NSArray *ids;  //轮播图对应广告
@property (strong, nonatomic) UIImage *placeholdImage;
@property (weak, nonatomic) id<SSCAdScrollViewDelegate> delegate;

@end
