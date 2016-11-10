//
//  EditLocationViewController.h
//  BrickMan
//
//  Created by TZ on 2016/9/26.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BaseViewController.h"

@interface EditLocationViewController : BaseViewController

@property (strong, nonatomic) NSString *locationStr;
@property (copy, nonatomic) void(^updateStringBlock)(NSString *valueString);
@end
