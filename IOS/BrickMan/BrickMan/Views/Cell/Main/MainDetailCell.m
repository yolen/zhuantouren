//
//  MainDetailCell.m
//  BrickMan
//
//  Created by TZ on 16/7/21.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kContentString @"人生应该如蜡烛一样,从顶燃到底,一直都是光明的.身边总有那么些好人好事,让生活更美好"
#import "MainDetailCell.h"

@interface MainDetailCell()
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *nameLabel, *timeLabel, *contentLabel, *commentLabel;
@property (strong, nonatomic) UIView *separatorLine, *separatorLine2, *bottomView;
@property (strong, nonatomic) UIButton  *reportBtn;
@end

@implementation MainDetailCell

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
        if (!_reportBtn) {
            _reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _reportBtn.frame = CGRectMake(kScreen_Width - 40, 15, 30, 30);
            [_reportBtn setImage:[UIImage imageNamed:@"report_nor"] forState:UIControlStateNormal];
            [self.contentView addSubview:_reportBtn];
        }
        if (!_separatorLine) {
            _separatorLine = [[UIView alloc] initWithFrame:CGRectMake(10, _iconImageView.bottom + 10, kScreen_Width - 20, 0.5)];
            _separatorLine.backgroundColor = kLineColor;
            [self.contentView addSubview:_separatorLine];
        }
        if (!_contentLabel) {
            _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _separatorLine.bottom + 10, kScreen_Width - 20, 1)];
            _contentLabel.numberOfLines = 0;
            _contentLabel.font = [UIFont systemFontOfSize:12];
            [self.contentView addSubview:_contentLabel];
        }
        if (!_bottomView) {
            _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _contentLabel.bottom, kScreen_Width, 10)];
            _bottomView.backgroundColor = RGBCOLOR(244, 245, 246);
            [self.contentView addSubview:_bottomView];
        }
        if (!_commentLabel) {
            _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _bottomView.bottom, 100, 30)];
            [self.contentView addSubview:_commentLabel];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat curY = 70;
    
    _iconImageView.image = [UIImage imageNamed:@"user_icon"];
    _nameLabel.text = @"砖头人";
    _timeLabel.text = @"2016-06-06 12:12 北京市";
    [_contentLabel setLongString:kContentString withFitWidth:(kScreen_Width - 10)];
    curY += [kContentString getHeightWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreen_Width - 20, CGFLOAT_MAX)];
    curY += 10;
    [_bottomView setY:curY];
    
    curY += 10;
    _commentLabel.text = @"评论 123";
    [_commentLabel setY:curY];
}

+ (CGFloat)cellHeight {
    CGFloat height = 70;
    NSString *contentStr = kContentString;
    height += [contentStr getHeightWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreen_Width - 10, 200)] + 20;
    height += 30;
    return height;
}

@end
