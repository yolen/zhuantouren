//
//  BrickDetailCell.h
//  BrickMan
//
//  Created by TZ on 2016/12/9.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kCellIdentifier_BrickDetailCell @"BrickDetailCell"
#import <UIKit/UIKit.h>
#import "BMContent.h"

@interface BrickDetailCell : UITableViewCell

@property (strong, nonatomic) UIButton *reportBtn, *commentBtn, *shareBtn, *brickBtn, *flowerBtn;
@property (strong, nonatomic) BMContent *model;

@property (nonatomic, copy) void(^pushGalleryBlock)(); //个人详情
@property (copy, nonatomic) void(^pushLoginBlock)();
@property (strong, nonatomic) void(^commentBlock)();
@property (copy, nonatomic) void(^shareBlock)(BMContent *content);
@property (copy, nonatomic) void(^reportBlock)();
@property (copy, nonatomic) void(^refreshCellBlock)();

+ (CGFloat)cellHeightWithModel:(BMContent *)contentModel;

@end
