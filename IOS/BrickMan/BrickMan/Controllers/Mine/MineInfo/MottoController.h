//
//  MottoController.h
//  BrickMan
//
//  Created by 段永瑞 on 16/7/24.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BaseViewController.h"
@class MottoController;

@protocol MottoControllerDelegate <NSObject>

- (void)saveMotto:(MottoController *)controller;

@end

@interface MottoController : BaseViewController

@property (nonatomic, assign) id <MottoControllerDelegate> delegate;

@property (nonatomic, strong) UITextView *textView;

@end
