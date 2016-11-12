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

@property (assign, nonatomic) BOOL isGallery, isDetail;
@property (strong, nonatomic) NSString *contentStr;
@property (strong, nonatomic) UIButton *reportBtn, *commentBtn, *shareBtn, *brickBtn;

@property (strong, nonatomic) void(^commentBlock)();
@property (copy, nonatomic) void(^shareBlock)(BMContent *content);
@property (copy, nonatomic) void(^refreshCellBlock)();
@property (copy, nonatomic) void(^pushDetailBlock)();
@property (copy, nonatomic) void(^pushLoginBlock)();
@property (nonatomic, copy) void(^pushGalleryBlock)(); /** 点击用户头像跳转到个人砖集 */
@property (copy, nonatomic) void(^reportBlock)();

@property (strong, nonatomic) BMContent *model;
@property (strong, nonatomic) CommentInputView *inputView;

+ (CGFloat)cellHeightWithModel:(BMContent *)contentModel;
@end
