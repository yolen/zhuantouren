//
//  Mine_infoCell.m
//  BrickMan
//
//  Created by 段永瑞 on 16/7/22.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "Mine_infoCell.h"

@implementation Mine_infoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 27 * kMineCellHeightRadio, 80, 20 * kMineCellHeightRadio)];
            _titleLabel.font = [UIFont systemFontOfSize:16];
            [self.contentView addSubview:_titleLabel];
        }
        if (!_subLabel) {
            _subLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - 180, 27 * kMineCellHeightRadio, 150, 20 * kMineCellHeightRadio)];
            _subLabel.enabled = NO;
            _subLabel.font = [UIFont systemFontOfSize:16];
            _subLabel.numberOfLines = 0;
            _subLabel.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:_subLabel];
        }
        if (!_subImgView) {
            _subImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 40 * kMineCellHeightRadio - 30, 17 * kMineCellHeightRadio, 40 * kMineCellHeightRadio, 40 * kMineCellHeightRadio)];
            _subImgView.layer.masksToBounds = YES;
            _subImgView.layer.cornerRadius = _subImgView.width/2;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [self.contentView addSubview:_subImgView];
            self.backgroundColor = [UIColor whiteColor];
        }
    };
    return self;
}

+ (CGFloat)cellHeight {
    return 74.0;
}

@end
