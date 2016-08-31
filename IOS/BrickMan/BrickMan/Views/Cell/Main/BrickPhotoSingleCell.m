//
//  BrickPhotoSingleCell.m
//  BrickMan
//
//  Created by TZ on 16/8/26.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kSingleCellWith (kScreen_Width * 0.6)
#import "BrickPhotoSingleCell.h"

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
    [_photoImgView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:nil];
}

+ (CGSize)cellHeithWithAttachment:(BMAttachment *)attachment {
    CGSize size;
    size = CGSizeMake(kSingleCellWith, kSingleCellWith);
    return size;
}

@end
