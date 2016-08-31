//
//  BrickPhotoSingleCell.h
//  BrickMan
//
//  Created by TZ on 16/8/26.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kCellIdentifier_BrickPhotoSingleCell @"BrickPhotoSingleCell"
#import <UIKit/UIKit.h>
#import "BMAttachment.h"

@interface BrickPhotoSingleCell : UICollectionViewCell

@property (strong, nonatomic) BMAttachment *attachmentModel;
@property (strong, nonatomic) UIImageView *photoImgView;

+ (CGSize)cellHeithWithAttachment:(BMAttachment *)attachment;

@end
