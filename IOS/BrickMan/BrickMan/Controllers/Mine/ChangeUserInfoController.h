//
//  ChangeUserInfoController.h
//  BrickMan
//
//  Created by TZ on 16/8/26.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BaseViewController.h"

@interface ChangeUserInfoController : BaseViewController

@property (copy, nonatomic) void(^updateBlock)(NSString *value);

@end
