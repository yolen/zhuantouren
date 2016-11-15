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
@property (strong, nonatomic) UILabel *titleLabel, *contentLabel;
@end

@implementation Mine_titleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (!_iconImageView) {
            _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
            [self.contentView addSubview:_iconImageView];
        }
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.right + 10, 15, 100, 30)];
            _titleLabel.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:_titleLabel];
        }
        if (!_contentLabel) {
            _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - 80, 15, 50, 30)];
            _contentLabel.textAlignment = NSTextAlignmentRight;
            _contentLabel.textColor = [UIColor lightGrayColor];
            _contentLabel.font = [UIFont systemFontOfSize:14];
            _contentLabel.hidden = YES;
            [self.contentView addSubview:_contentLabel];
        }
    }
    return self;
}

- (void)setIconImage:(NSString *)imageStr withTitle:(NSString *)title {
    _iconImageView.image = [UIImage imageNamed:imageStr];
    _titleLabel.text = title;
}

- (void)setContent:(NSString *)content {
    if (content) {
        _contentLabel.hidden = NO;
        _contentLabel.text = content;
    }
}

+ (CGFloat)cellHeight {
    return 60.0;
}

@end
