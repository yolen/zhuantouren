//
//  BrickPhotoCell.m
//  BrickMan
//
//  Created by TZ on 16/7/22.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kCellWidth (kScreen_Width - 28.0)/3.0
#import "BrickPhotoCell.h"

@implementation BrickPhotoCell

- (void)setAttachmentModel:(BMAttachment *)attachmentModel {
    if (!_photoImgView) {
        _photoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCellWidth, kCellWidth)];
        _photoImgView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImgView.clipsToBounds = YES;
        [self.contentView addSubview:_photoImgView];
    }
    
    NSString *imageStr = [NSString stringWithFormat:@"%@/compress/%@",kImageUrl,attachmentModel.attachmentPath];
    [_photoImgView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority];
}

+ (CGSize)cellHeithWithAttachment:(BMAttachment *)attachment {
    CGSize size = CGSizeMake(kCellWidth, kCellWidth);
    return size;
}

@end
