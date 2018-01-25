//
//  MainHeadView.m
//  FreeRide
//
//  Created by  on 2017/11/13.
//  Copyright © 2017年 JNR All rights reserved.
//

#import "MainHeadView.h"
#import "Header.h"


@interface MainHeadView() <UIScrollViewDelegate>

@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) NSInteger currentPageIndex;

@property (strong, nonatomic) NSArray *imageArray;

@property (assign, nonatomic) NSInteger AdCount;

@property (strong, nonatomic) NSTimer *timer;

@end

#define SelfW self.frame.size.width
#define SelfH self.frame.size.height


@implementation MainHeadView

#pragma mark - 滚动广告栏

- (instancetype)initWithFrame:(CGRect)frame ADImageArray:(NSArray *)imageArr{
    if (self = [self initWithFrame:frame]) {
        if (imageArr) self.images = imageArr;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    return self;
}

- (void)setImages:(NSArray *)images {
    _images = images;
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)]; // 移除子视图，防止重复创建
    NSMutableArray *tempArray=[NSMutableArray arrayWithArray:images];
    [tempArray insertObject:[images lastObject] atIndex:0];
    [tempArray addObject:[images firstObject]];
    _imageArray=[NSArray arrayWithArray:tempArray];
    _AdCount = _imageArray.count;
    
    CGRect frame = _scrollView.frame;
    _scrollView.contentSize = CGSizeMake(frame.size.width * _AdCount, frame.size.height);
    // 图片数组在index ＝ 0处插入了第四张图片，所以在第二张图开始展示。
    [_scrollView setContentOffset:CGPointMake(SelfW, 0)];
    CGRect imageFrame = frame;
    for (int i = 0; i < _AdCount; i++) {
        imageFrame.origin.x = frame.size.width * i;
        UIImageView *AdImageView = [[UIImageView alloc] initWithFrame:imageFrame];
        //            if ([_imageArray[i] rangeOfString:@":"].location !=NSNotFound) {
        if ([_imageArray[i] isKindOfClass:[UIImage class]]) {
            AdImageView.image = _imageArray[i];
        } else {
//            [SSCNetDownloadPictures downloadImageWithUrl:_imageArray[i] andImageView:AdImageView andPlacehoder:_placeholdImage isURLOK:NO];
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTouched:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        AdImageView.userInteractionEnabled = YES;
        AdImageView.tag = 100000 + i;
        
        [AdImageView addGestureRecognizer:tap];
        [_scrollView addSubview:AdImageView];
    }
    CGFloat pageW = (_AdCount - 2) * 8 + 40;
    CGFloat pageH = 10;
    CGFloat pageX = (SelfW - pageW) / 2;
    CGFloat pageY = SelfH * 0.9;
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(pageX, pageY, pageW, pageH)];
        _pageControl.pageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.transform = CGAffineTransformMakeScale(0.85, 0.85);
    }
    _pageControl.numberOfPages = _AdCount - 2;
    
    [self addSubview:_pageControl];
    if (_images.count > 1) {
        [self addNSTimer];
        _scrollView.scrollEnabled = YES;
    }else {
        _scrollView.scrollEnabled = NO;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _currentPageIndex = page;
    
    _pageControl.currentPage = page - 1;
}
//拖动广告的判断
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (_currentPageIndex == 0) {
        [_scrollView setContentOffset:CGPointMake((_AdCount - 2) * SelfW, 0)];
    }
    if (_currentPageIndex == _AdCount - 1) {
        [_scrollView setContentOffset:CGPointMake(SelfW, 0)];
    }
}

//定时器滚动的判断
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (_currentPageIndex == 0) {
        [_scrollView setContentOffset:CGPointMake((_AdCount - 2) * SelfW, 0)];
    }
    if (_currentPageIndex == _AdCount - 1) {
        [_scrollView setContentOffset:CGPointMake(SelfW, 0)];
    }
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeNSTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addNSTimer];
}

#pragma mark - 计时器
- (void)addNSTimer
{
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:4 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)removeNSTimer
{
    [_timer invalidate];
    _timer =nil;
}


- (void)nextPage
{
    if (_scrollView.contentOffset.x == _AdCount * SelfW) {
        [_scrollView scrollRectToVisible:CGRectMake(SelfW, 0, SelfW, SelfH) animated:YES];
    }else{
        [_scrollView scrollRectToVisible:CGRectMake(_currentPageIndex * SelfW + SelfW, 0, SelfW, SelfH) animated:YES];
    }
}

- (void)imageTouched:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(AdScrollerViewDidClicked:)]) {
        NSInteger index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
        if (index == 0) {
            index = self.images.count - 1;
        }else if (index > 0) {
            index--;
        }else if (index == self.images.count + 1) {
            index = 0;
        }
        [self.delegate AdScrollerViewDidClicked:index];
    }
    
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}
@end
