//
//  Mine_headerCell.m
//  BrickMan
//
//  Created by TZ on 16/7/19.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "Mine_headerCell.h"

@interface Mine_headerCell()
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *nameLabel, *subTitle;
@end

@implementation Mine_headerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (!_iconImageView) {
            _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
            _iconImageView.layer.cornerRadius = _iconImageView.width/2;
            _iconImageView.layer.masksToBounds = YES;
            [self.contentView addSubview:_iconImageView];
        }
        if (!_nameLabel) {
            _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.right + 10, 15, 100, 20)];
            _nameLabel.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:_nameLabel];
        }
        if (!_subTitle) {
            _subTitle = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom, 150, 20)];
            _subTitle.font = [UIFont systemFontOfSize:12];
            _subTitle.textColor = [UIColor lightGrayColor];
            [self.contentView addSubview:_subTitle];
        }
    }
    return self;
}

- (void)setUserIcon:(NSString *)iconStr nameTitle:(NSString *)nameStr subTitle:(NSString *)subTitleStr {
    _iconImageView.image = [UIImage imageNamed:iconStr];
    _nameLabel.text = nameStr;
    _subTitle.text = subTitleStr;
}

+ (CGFloat)cellHeight {
    return 70.0;
}

@end
