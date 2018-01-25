//
//  GuideController.m
//  text
//
//  Created by pillar‘s on 16/1/27.
//  Copyright © 2016年 pillar‘s. All rights reserved.
//

#import "GuideController.h"
#import "Header.h"
#import "LoginViewController.h"

#define SCREEN_HEIGHT self.view.frame.size.height

@interface GuideController ()<UIScrollViewDelegate>
{
    UIScrollView *scroll;
    UIPageControl * pageCtr;

}
@end

@implementation GuideController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self goGuide];
}

- (void)goGuide
{
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    scroll.contentSize = CGSizeMake(SCREEN_WIDTH*3,SCREEN_HEIGHT);
    scroll.contentOffset = CGPointMake(0, 0);
    scroll.bounces = NO;
    scroll.showsHorizontalScrollIndicator = NO; //水平
    scroll.showsVerticalScrollIndicator = NO; //垂直
    scroll.pagingEnabled = YES;
    scroll.delegate = self;
    
    NSArray *arr = @[@"bg_splashscreen one",@"bg_splashscreen two",@"bg_splashscreen three"];
    for (int i=0; i<arr.count; i++){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        NSString * imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"guide%d@3x",i+1] ofType:@"png"];
//        [imageView setImage:[UIImage imageWithContentsOfFile:imagePath]];
        imageView.image = [UIImage imageNamed:arr[i]];
        if (i==2){
            imageView.userInteractionEnabled=YES;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goActionShow)];
            [imageView addGestureRecognizer:tap];
            
            UILabel *goin = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 40)];
            goin.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/5*4+XMAKENEW(30));
            goin.text = @"立即体验";
            goin.textAlignment = NSTextAlignmentCenter;
            goin.textColor = COLOR_ORANGE;
            goin.layer.cornerRadius = 20.0f;
            goin.layer.borderWidth = 1.0f;
            goin.layer.borderColor = COLOR_ORANGE.CGColor;
            [imageView addSubview:goin];
        }
        [scroll addSubview:imageView];
    
        pageCtr = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, scroll.frame.size.width/5, 30)];
        pageCtr.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-50);
        pageCtr.currentPage = 0;
        pageCtr.numberOfPages = arr.count;
        pageCtr.pageIndicatorTintColor = [UIColor lightGrayColor];
        pageCtr.currentPageIndicatorTintColor = COLOR_ORANGE;
        [self.view addSubview:scroll];
        [self.view addSubview:pageCtr];
    
    }
}

- (void)goActionShow
{
    self.view.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
//    //直接进入登录
//    SSCLoginViewController *log = [[SSCLoginViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:log];
//    self.view.window.rootViewController = nav;
}




- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageCtr.currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
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
