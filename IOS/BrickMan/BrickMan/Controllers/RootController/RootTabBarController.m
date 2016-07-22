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
#import "BaseNavigationController.h"

@interface RootTabBarController ()<UITabBarControllerDelegate>

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tabberView];
}

- (void)tabberView {
    MainViewController *mainVC = [[MainViewController alloc] init];
    UINavigationController *mainNav = [[BaseNavigationController alloc]initWithRootViewController:mainVC];
    mainVC.title = @"砖集";
    
    UIViewController *publishVC = [[UIViewController alloc] init];
    UINavigationController *publishNav = [[BaseNavigationController alloc]initWithRootViewController:publishVC];
    
    MineViewController *meVC = [[MineViewController alloc] init];
    UINavigationController *meNav = [[BaseNavigationController alloc]initWithRootViewController:meVC];
    meVC.title = @"砖头人";
    self.delegate = self;
    self.viewControllers = @[mainNav,publishNav,meNav];
    
    UIImage *bgImage = [UIImage imageNamed:@"tabBar_bg"];
    if (kDevice_Is_iPhone6) {
        bgImage = [UIImage imageNamed:@"tabBar_bg_6"];
    }

    [[UITabBar appearance] setBackgroundImage:bgImage];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor clearColor]];
    [[UITabBar appearance] setClipsToBounds:YES];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       kNavigationBarColor, NSForegroundColorAttributeName,
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
    //当前选中viewController的下标
    NSInteger shouldSelectIndex = -1;
    NSArray* viewControllersArray = [tabBarController viewControllers];
    
    for (int i = 0 ; i<viewControllersArray.count ; i ++) {
        if ([viewControllersArray objectAtIndex:i] == viewController) {
            shouldSelectIndex = i;
            
            if (shouldSelectIndex > 0) {
                //selectedIndex是上一个选中的页面
                UINavigationController* firstNavVC = (UINavigationController*)[viewControllersArray objectAtIndex:tabBarController.selectedIndex];
                BaseViewController* vc = (BaseViewController*)[firstNavVC.viewControllers objectAtIndex:0];
                if (shouldSelectIndex == 1) {
                    PublishViewController *publishVC = [[PublishViewController alloc] init];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:publishVC];
                    [vc.navigationController presentViewController:nav animated:YES completion:nil];
                    return NO;
                }
            }
        }
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
