//
//  ComposeViewController.h
//  BrickMan
//
//  Created by TobyoTenma on 7/21/16.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposeViewController : UIViewController

@property (nonatomic, strong) UIImage *image; //接收捕获的图片
@property (strong, nonatomic) NSArray *imagePathArray;

+ (instancetype)sharedInstance;

@end
