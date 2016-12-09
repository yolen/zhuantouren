//
//  BrickDetailPhotoCell.m
//  BrickMan
//
//  Created by TZ on 2016/12/9.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kDetailCellWidth (kScreen_Width - 20)
#define kDetailCellMaxHeight kScreen_Height
#import "BrickDetailPhotoCell.h"
#import "CacheImageSize.h"

@implementation BrickDetailPhotoCell

- (void)setAttachmentModel:(BMAttachment *)attachmentModel {
    if (!_photoImgView) {
        _photoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDetailCellWidth, kDetailCellWidth)];
        _photoImgView.contentMode = UIViewContentModeScaleAspectFit;
        _photoImgView.clipsToBounds = YES;
        [self.contentView addSubview:_photoImgView];
    }
    NSString *imageStr = [NSString stringWithFormat:@"%@/compress/%@",kImageUrl,attachmentModel.attachmentPath];
    CGSize reSize = [[CacheImageSize shareManager] sizeWithSrc:imageStr originalWidth:kDetailCellWidth maxHeight:kDetailCellMaxHeight];
    
    __weak typeof(self) weakSelf = self;
    [_photoImgView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
    NSString *imageStr = [NSString stringWithFormat:@"%@/compress/%@",kImageUrl,attachment.attachmentPath];
    CGSize size = [[CacheImageSize shareManager] sizeWithSrc:imageStr originalWidth:kDetailCellWidth maxHeight:kDetailCellMaxHeight];
    return size;
}

@end
