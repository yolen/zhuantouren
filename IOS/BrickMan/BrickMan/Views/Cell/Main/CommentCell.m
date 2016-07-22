//
//  CommentCell.m
//  BrickMan
//
//  Created by TZ on 16/7/21.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kContentString @"人生应该如蜡烛一样,从顶燃到底,一直都是光明的.身边总有那么些好人好事,让生活更美好"
#import "CommentCell.h"

@interface CommentCell()
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *nameLabel, *timeLabel, *commentLabel;
@end

@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!_iconImageView) {
            _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
            _iconImageView.layer.cornerRadius = _iconImageView.width/2;
            _iconImageView.layer.masksToBounds = YES;
            [self.contentView addSubview:_iconImageView];
        }
        if (!_nameLabel) {
            _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.right + 10, 15, 100, 20)];
            _nameLabel.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:_nameLabel];
        }
        if (!_timeLabel) {
            _timeLabel  = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.right + 10, _nameLabel.bottom - 5, 150, 20)];
            _timeLabel.font = [UIFont systemFontOfSize:12];
            _timeLabel.textColor = [UIColor lightGrayColor];
            [self.contentView addSubview:_timeLabel];
        }
        if (!_commentLabel) {
            _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.right + 10, _timeLabel.bottom + 10, kScreen_Width - 70, 1)];
            _commentLabel.font = [UIFont systemFontOfSize:12];
            _commentLabel.textColor = [UIColor lightGrayColor];
            [self.contentView addSubview:_commentLabel];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _iconImageView.image = [UIImage imageNamed:@"user_icon"];
    _nameLabel.text = @"砖头人";
    _timeLabel.text = @"2016-06-06 12:12";
    [_commentLabel setLongString:kContentString withFitWidth:(kScreen_Width - 70)];
}

+ (CGFloat)cellHeight {
    CGFloat height = 60;
    NSString *contentStr = kContentString;
    height += [contentStr getHeightWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreen_Width - 10, CGFLOAT_MAX)] + 10;
    return height;
}

@end
