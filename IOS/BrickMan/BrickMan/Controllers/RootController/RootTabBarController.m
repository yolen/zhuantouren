//
//  RootTabBarController.m
//  BrickMan
//
//  Created by TZ on 16/7/18.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "RootTabBarController.h"
#import "MainViewController.h"
#import "PublishViewController.h"
#import "MineViewController.h"

@interface RootTabBarController ()<UITabBarDelegate>

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tabberView];
}

- (void)tabberView {
    MainViewController *mainVC = [[MainViewController alloc] init];
    UINavigationController *mainNav = [[UINavigationController alloc]initWithRootViewController:mainVC];
    mainVC.title = @"砖集";
    
    PublishViewController *publishVC = [[PublishViewController alloc] init];
    UINavigationController *publishNav = [[UINavigationController alloc]initWithRootViewController:publishVC];
    
    MineViewController *meVC = [[MineViewController alloc] init];
    UINavigationController *meNav = [[UINavigationController alloc]initWithRootViewController:meVC];
    meVC.title = @"砖头人";
    self.viewControllers = @[mainNav,publishNav,meNav];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabBar_bg"]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor orangeColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    UITabBar *tabbar = self.tabBar;
    UITabBarItem *item1 = [tabbar.items objectAtIndex:0];
    UITabBarItem *item2 = [tabbar.items objectAtIndex:1];
    UITabBarItem *item3 = [tabbar.items objectAtIndex:2];
    
    item1.selectedImage = [[UIImage imageNamed:@"tabbar0_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = [[UIImage imageNamed:@"tabbar0_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.imageInsets = UIEdgeInsetsMake(3, 0, -3, 0);
    item2.image = [[UIImage imageNamed:@"tabbar1_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [[UIImage imageNamed:@"tabbar2_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    item3.image = [[UIImage imageNamed:@"tabbar2_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.imageInsets = UIEdgeInsetsMake(3, 0, -3, 0);
}

#pragma mark - UITabBarDelegate 
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
