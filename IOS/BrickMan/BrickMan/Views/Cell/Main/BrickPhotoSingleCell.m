//
//  BrickPhotoSingleCell.m
//  BrickMan
//
//  Created by TZ on 16/8/26.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kSingleCellWith (kScreen_Width * 0.6)
#define kSingleCellMaxHeight (kScreen_Height * 0.5)
#import "BrickPhotoSingleCell.h"
#import "CacheImageSize.h"

@implementation BrickPhotoSingleCell

- (void)setAttachmentModel:(BMAttachment *)attachmentModel {
    _attachmentModel = attachmentModel;
    
    if (!_attachmentModel) {
        return;
    }
    
    if (!_photoImgView) {
        _photoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSingleCellWith, kSingleCellWith)];
        _photoImgView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImgView.clipsToBounds = YES;
        [self.contentView addSubview:_photoImgView];
    }
    NSString *imageStr = [NSString stringWithFormat:@"%@/%@",kImageUrl,attachmentModel.attachmentPath];
    CGSize reSize = [[CacheImageSize shareManager] sizeWithSrc:imageStr originalWidth:kSingleCellWith maxHeight:kSingleCellMaxHeight];
    
    __weak typeof(self) weakSelf = self;
    [_photoImgView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image && ![[CacheImageSize shareManager] hasSrc:imageStr]) {
            [[CacheImageSize shareManager] saveImage:imageStr size:image.size];
            if (weakSelf.refreshCellBlock) {
                weakSelf.refreshCellBlock();
            }
        }
    }];
    [_photoImgView setSize:reSize];
}

+ (CGSize)cellHeithWithAttachment:(BMAttachment *)attachment {
    NSString *imageStr = [NSString stringWithFormat:@"%@/%@",kImageUrl,attachment.attachmentPath];
    CGSize size = [[CacheImageSize shareManager] sizeWithSrc:imageStr originalWidth:kSingleCellWith maxHeight:kSingleCellMaxHeight];
    return size;
}

@end
