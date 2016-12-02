//
//  NotifyCell.m
//  BrickMan
//
//  Created by TZ on 2016/11/15.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "NotifyCell.h"

@interface NotifyCell()
@property (strong, nonatomic) UIImageView *iconView;
@property (strong, nonatomic) UILabel *titleLabel, *contentLabel;
@end

@implementation NotifyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (!_iconView) {
            _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 30, 30)];
            _iconView.image = [UIImage imageNamed:@"icon"];
            _iconView.layer.cornerRadius = _iconView.width/2;
            _iconView.layer.masksToBounds = YES;
            [self.contentView addSubview:_iconView];
        }
        if (!_titleLabel) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.right + 10, 10, 150, 20)];
            _titleLabel.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:_titleLabel];
        }
        if (!_contentLabel) {
            _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.right + 10, _titleLabel.bottom, kScreen_Width - 80, 20)];
            _contentLabel.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:_contentLabel];
        }
    }
    return self;
}

- (void)setContent:(NSString *)contentStr withIsRead:(BOOL)isRead {
    self.contentLabel.text = contentStr;
    self.titleLabel.textColor = isRead ? [UIColor lightGrayColor] : kNavigationBarColor;
    self.contentLabel.textColor = isRead ? [UIColor lightGrayColor] : kNavigationBarColor;
    self.titleLabel.text = isRead ? @"此消息已查看!" : @"有新消息,请查看!";
}

@end
