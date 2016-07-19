//
//  Mine_titleCell.m
//  BrickMan
//
//  Created by TZ on 16/7/19.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "Mine_titleCell.h"

@interface Mine_titleCell()
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation Mine_titleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (!_iconImageView) {
            _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
            _iconImageView.layer.cornerRadius = _iconImageView.width/2;
            _iconImageView.layer.masksToBounds = YES;
            [self.contentView addSubview:_iconImageView];
        }
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.right + 10, 15, 100, 20)];
            _titleLabel.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:_titleLabel];
        }
    }
    return self;
}

- (void)setIconImage:(NSString *)imageStr withTitle:(NSString *)title {
    _iconImageView.image = [UIImage imageNamed:imageStr];
    _titleLabel.text = title;
}

+ (CGFloat)cellHeight {
    return 50.0;
}

@end
