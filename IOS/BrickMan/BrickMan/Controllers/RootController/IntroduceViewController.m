//
//  IntroduceViewController.m
//  BrickMan
//
//  Created by TZ on 16/8/15.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "IntroduceViewController.h"
#import "RootTabBarController.h"
#import "SMPageControl.h"

@interface IntroduceViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *myScrollView;
@property (strong, nonatomic) SMPageControl *pageControl;
@end

@implementation IntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView.pagingEnabled = YES;
    self.myScrollView.bounces = NO;
    self.myScrollView.delegate = self;
    self.myScrollView.contentSize = CGSizeMake(kScreen_Width * 5, kScreen_Height);
    [self.view addSubview:self.myScrollView];
    
    for (int i = 0; i < 5; i++) {
        NSString *imgString = [NSString stringWithFormat:@"Introduce_%d",i];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreen_Width, 0, kScreen_Width, kScreen_Height)];
        imgView.image = [UIImage imageNamed:imgString];
        [self.myScrollView addSubview:imgView];
    }
    self.pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake((kScreen_Width - 80)/2, kScreen_Height - 40, 80, 10)];
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.pageIndicatorImage = [UIImage imageNamed:@"page_unsel"];
    self.pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"page_sel"];
    self.pageControl.numberOfPages = 5;
    self.pageControl.currentPage = 0;
    self.pageControl.alignment = SMPageControlAlignmentCenter;
    [self.view addSubview:self.pageControl];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentSize.width - scrollView.frame.size.width == scrollView.contentOffset.x) {
        RootTabBarController *root = [RootTabBarController sharedInstance];
        root.view.alpha = 0.0;
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        [window addSubview:root.view];
        [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.alpha = 0.0;
        } completion:nil];
        
        [UIView animateWithDuration:1.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            root.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            window.rootViewController = root;
        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.pageControl.currentPage = floor(scrollView.contentOffset.x / kScreen_Width);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
