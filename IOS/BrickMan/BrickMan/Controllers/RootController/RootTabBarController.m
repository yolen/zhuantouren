//
//  RootTabBarController.m
//  BrickMan
//
//  Created by TZ on 2016/11/14.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "RootTabBarController.h"
#import "BaseNavigationController.h"
#import "PublishViewController.h"
#import "MineViewController.h"

@interface RootTabBarController ()<UINavigationControllerDelegate,CustomTabBarDelegate>
@property(nonatomic,strong) UIView *centerView;
@property(nonatomic,strong) UIButton *centerBtn;

@end

@implementation RootTabBarController

+ (instancetype)sharedInstance {
    static RootTabBarController* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[RootTabBarController alloc] init];
    });
    
    return instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CustomTabBar *customerTB = [[CustomTabBar alloc] initWithFrame:CGRectMake(0, kScreen_Height - kTabbarHeight, kScreen_Width, kTabbarHeight)];
    customerTB.delegate = self;
    customerTB.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabBar_bg"]];
    [self.view addSubview:customerTB];
    self.myTabBar = customerTB;
    
    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 61)];
    self.centerView.center = CGPointMake(kScreen_Width/2, kScreen_Height - 61/2);
    self.centerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_brickViewBg"]];
    self.centerBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 8, 40, 40)];
    [self.centerBtn setBackgroundImage:[UIImage imageNamed:@"tabbar1_nor"] forState:UIControlStateNormal];
    [self.centerBtn addTarget:self action:@selector(brickButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.centerView addSubview:self.centerBtn];
    [self.view addSubview:self.centerView];
    
    MainViewController *mainVC = [[MainViewController alloc] init];
    UINavigationController *mainNav = [[BaseNavigationController alloc]initWithRootViewController:mainVC];
    mainVC.title = @"砖集";

    PublishViewController *publishVC = [[PublishViewController alloc] init];
    UINavigationController *publishNav = [[BaseNavigationController alloc]initWithRootViewController:publishVC];
    publishVC.title = @"发布";
    
    MineViewController *meVC = [[MineViewController alloc] init];
    UINavigationController *meNav = [[BaseNavigationController alloc]initWithRootViewController:meVC];
    meVC.title = @"我的";
    self.viewControllers = @[mainNav,publishNav,meNav];
    
    for (UINavigationController *navVC in self.viewControllers) {
        navVC.delegate = self;
    }
}

- (void)brickButtonClick:(UIButton *)btn {
    self.selectedIndex = 1;
}

- (void)changeNavigation:(NSInteger)fromIndex to:(NSInteger)toIndex {
    self.selectedIndex = toIndex;
}

- (MainViewController *)getMainViewController {
    UINavigationController *nav = self.viewControllers[0];
    MainViewController *vc = nav.viewControllers.firstObject;
    return vc;
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.tabBar.hidden = YES;
    [_myTabBar removeFromSuperview];
    [_centerView removeFromSuperview];
        
    // 调整tabbar的Y值
    CGRect tabBarFrame = _myTabBar.frame;
    CGRect centerViewFrame = _centerView.frame;
    UIViewController *mainVC = navigationController.viewControllers.firstObject;
    centerViewFrame.origin.y = mainVC.view.height -61;
    tabBarFrame.origin.y = mainVC.view.height - kTabbarHeight;
    _myTabBar.frame = tabBarFrame;
        
    _centerView.frame = centerViewFrame;
        
    //添加dock到根控制器界面
    [mainVC.view addSubview:_myTabBar];
    [mainVC.view addSubview:_centerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
