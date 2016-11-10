//
//  BaseViewController.m
//  BrickMan
//
//  Created by TZ on 16/7/18.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()


@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kViewBGColor;
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController.navigationBar setBackIndicatorImage:[UIImage imageNamed:@"back"]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"back"]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    [backItem setBackgroundVerticalPositionAdjustment:10 forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
    
    if (self.isEndEdit) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditAction)];
        tap.cancelsTouchesInView = YES;
        [self.view addGestureRecognizer:tap];
    }
}

- (void)endEditAction {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
