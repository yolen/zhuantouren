//
//  BrickDetailPhotoCell.h
//  BrickMan
//
//  Created by TZ on 2016/12/9.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kCellIdentifier_BrickDetailPhotoCell @"BrickDetailPhotoCell"
#import <UIKit/UIKit.h>
#import "BMAttachment.h"

@interface BrickDetailPhotoCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *photoImgView;
@property (strong, nonatomic) BMAttachment *attachmentModel;

@property (copy, nonatomic) void(^refreshCellBlock)();

+ (CGSize)cellHeithWithAttachment:(BMAttachment *)attachment;

@end
