//
//  HeadEditController.h
//  BrickMan
//
//  Created by 段永瑞 on 16/7/22.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BaseViewController.h"

@interface HeadEditController : BaseViewController

@property (nonatomic, strong) UIImageView *headImgView;
@property (copy, nonatomic) void(^updateBlock)(NSString *value);

@end
