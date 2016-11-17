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
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 80, 30)];
            _titleLabel.font = [UIFont systemFontOfSize:16];
            [self.contentView addSubview:_titleLabel];
        }
        if (!_subLabel) {
            _subLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - 200, 20, 170, 20)];
            _subLabel.enabled = NO;
            _subLabel.font = [UIFont systemFontOfSize:16];
            _subLabel.numberOfLines = 0;
            _subLabel.textAlignment = NSTextAlignmentRight;
            [self.contentView addSubview:_subLabel];
        }
        if (!_subImgView) {
            _subImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 40 - 30, 10, 40, 40)];
            _subImgView.layer.masksToBounds = YES;
            _subImgView.layer.cornerRadius = _subImgView.width/2;
            [self.contentView addSubview:_subImgView];
            self.backgroundColor = [UIColor whiteColor];
        }
    };
    return self;
}

+ (CGFloat)cellHeight {
    return 60.0;
}

@end
