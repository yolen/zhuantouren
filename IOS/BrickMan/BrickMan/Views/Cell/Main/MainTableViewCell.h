//
//  MainTableViewCell.h
//  BrickMan
//
//  Created by TZ on 16/7/21.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kCellIdentifier_MainTableViewCell @"MainTableViewCell"
#import <UIKit/UIKit.h>
#import "BMContentModel.h"
#import "CommentInputView.h"

@interface MainTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *contentStr;
@property (nonatomic, assign) BOOL isGallery;
@property (strong, nonatomic) void(^commentBlock)();
@property (copy, nonatomic) void(^shareBlock)();
@property (strong, nonatomic) BMContentModel *model;
@property (strong, nonatomic) CommentInputView *inputView;

//- (void)setData:(NSDictionary *)dataDic;
+ (CGFloat)cellHeightWithModel:(BMContentModel *)contentModel;
@end
