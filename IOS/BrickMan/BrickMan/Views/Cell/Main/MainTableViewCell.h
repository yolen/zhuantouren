//
//  MainTableViewCell.h
//  BrickMan
//
//  Created by TZ on 16/7/21.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kCellIdentifier_MainTableViewCell @"MainTableViewCell"
#import <UIKit/UIKit.h>
#import "BMContent.h"
#import "CommentInputView.h"

@interface MainTableViewCell : UITableViewCell

@property (assign, nonatomic) BOOL isGallery;
@property (strong, nonatomic) NSString *contentStr;
@property (strong, nonatomic) UIButton *reportBtn, *commentBtn, *shareBtn, *brickBtn;

@property (copy, nonatomic) void(^refreshCellBlock)();
@property (copy, nonatomic) void(^pushDetailBlock)();
@property (nonatomic, copy) void(^pushGalleryBlock)(); /** 点击用户头像跳转到个人砖集 */

@property (strong, nonatomic) BMContent *model;

+ (CGFloat)cellHeightWithModel:(BMContent *)contentModel;
@end
