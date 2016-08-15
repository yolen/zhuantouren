//
//  IntroduceViewController.m
//  BrickMan
//
//  Created by TZ on 16/8/15.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "IntroduceViewController.h"
#import "RootTabBarController.h"

@interface IntroduceViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *myScrollView;
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
    self.myScrollView.contentSize = CGSizeMake(kScreen_Width * 4, kScreen_Height);
    [self.view addSubview:self.myScrollView];
    
    for (int i = 0; i < 4; i++) {
        NSString *imgString = [NSString stringWithFormat:@"Introduce_%d",i];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreen_Width, 0, kScreen_Width, kScreen_Height)];
        imgView.image = [UIImage imageNamed:imgString];
        [self.myScrollView addSubview:imgView];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentSize.width - scrollView.frame.size.width == scrollView.contentOffset.x) {
        RootTabBarController *root = [RootTabBarController sharedInstance];
        root.view.alpha = 0.0;
        [[[[UIApplication sharedApplication] delegate] window] addSubview:root.view];
        [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.alpha = 0.0;
        } completion:nil];
        
        [UIView animateWithDuration:1.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            root.view.alpha = 1.0;
        } completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
