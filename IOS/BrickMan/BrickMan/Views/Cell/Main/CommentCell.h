//
//  CommentCell.h
//  BrickMan
//
//  Created by TZ on 16/7/21.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kCellIdentifier_CommentCell @"CommentCell"
#import <UIKit/UIKit.h>
#import "BMComment.h"

@interface CommentCell : UITableViewCell
@property (strong, nonatomic) BMComment *comment;
@property (nonatomic, copy) void(^pushGalleryBlock)();

+ (CGFloat)cellHeightWithModel:(BMComment *)comment;
@end
