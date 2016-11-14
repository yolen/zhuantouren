//
//  RootTabBarController.h
//  BrickMan
//
//  Created by TZ on 2016/11/14.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface RootTabBarController : UITabBarController

+ (instancetype)sharedInstance;

- (MainViewController *)getMainViewController;

@end
