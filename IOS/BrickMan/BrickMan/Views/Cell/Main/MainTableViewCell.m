//
//  MainTableViewCell.m
//  BrickMan
//
//  Created by TZ on 16/7/21.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kContentString @"人生应该如蜡烛一样,从顶燃到底,一直都是光明的.身边总有那么些好人好事,让生活更美好"
#define kLineColor RGBCOLOR(213, 214, 215)
#import "MainTableViewCell.h"

@interface MainTableViewCell()
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *nameLabel, *timeLabel, *contentLabel;
@property (strong, nonatomic) UIView *separatorLine, *separatorLine2, *bottomView;
@property (strong, nonatomic) UIButton  *reportBtn,*commentBtn, *flowerBtn, *shareBtn;
@end

@implementation MainTableViewCell

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
        if (!_separatorLine2) {
            _separatorLine2 = [[UIView alloc] initWithFrame:CGRectMake(10, _contentLabel.bottom + 5, kScreen_Width - 20, 0.5)];
            _separatorLine2.backgroundColor = kLineColor;
            [self.contentView addSubview:_separatorLine2];
        }
        if (!_commentBtn) {
            _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _commentBtn.frame = CGRectMake(10, _separatorLine2.bottom + 3, 50, 30);
            _commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
            [_commentBtn setImage:[UIImage imageNamed:@"commnet_nor"] forState:UIControlStateNormal];
            [_commentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _commentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [_commentBtn setTitle:@"评论" forState:UIControlStateNormal];
            [self.contentView addSubview:_commentBtn];
        }
        if (!_flowerBtn) {
            _flowerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _flowerBtn.frame = CGRectMake(kScreen_Width/2 - 20, _separatorLine2.bottom + 3, 50, 30);
            _flowerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _flowerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
            [_flowerBtn setImage:[UIImage imageNamed:@"flower_nor"] forState:UIControlStateNormal];
            [_flowerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _flowerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [_flowerBtn setTitle:@"鲜花" forState:UIControlStateNormal];
            [self.contentView addSubview:_flowerBtn];
        }
        if (!_shareBtn) {
            _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _shareBtn.frame = CGRectMake(kScreen_Width - 60, _separatorLine2.bottom + 3, 50, 30);
            _shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
            [_shareBtn setImage:[UIImage imageNamed:@"share_nor"] forState:UIControlStateNormal];
            [_shareBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _shareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
            [self.contentView addSubview:_shareBtn];
        }
        if (!_bottomView) {
            _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _shareBtn.bottom, kScreen_Width, 10)];
            _bottomView.backgroundColor = RGBCOLOR(244, 245, 246);
            [self.contentView addSubview:_bottomView];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat curY = 61+20;
    
    _iconImageView.image = [UIImage imageNamed:@"user_icon"];
    _nameLabel.text = @"老马";
    _timeLabel.text = @"2016-06-06 12:12 北京市";
    [_contentLabel setLongString:kContentString withFitWidth:(kScreen_Width - 10)];
    curY += [kContentString getHeightWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreen_Width - 20, 200)];
    [_separatorLine2 setY:curY];
    
    curY += 3;
    [_commentBtn setY:curY];
    [_flowerBtn setY:curY];
    [_shareBtn setY:curY];
    
    curY += 30;
    [_bottomView setY:curY];
}

+ (CGFloat)cellHeight {
    CGFloat height = 60 + 1;
    NSString *contentStr = kContentString;
    height += [contentStr getHeightWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreen_Width - 10, 200)];
    height += 30 + 1;
    return 150;
}

@end
