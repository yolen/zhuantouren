//
//  CommentCell.m
//  BrickMan
//
//  Created by TZ on 16/7/21.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "CommentCell.h"
#import "NSDate+Common.h"
#import "UILabel+Common.h"

@interface CommentCell()
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *nameLabel, *timeLabel, *commentLabel;
@end

@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak typeof(self) weakSelf = self;
        if (!_iconImageView) {
            _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
            _iconImageView.layer.cornerRadius = _iconImageView.width/2;
            _iconImageView.layer.masksToBounds = YES;
            _iconImageView.userInteractionEnabled = YES;
            [self.contentView addSubview:_iconImageView];
            
            [_iconImageView tta_addTapGestureWithTarget:_iconImageView action:^(UITapGestureRecognizer *tap){
                if (weakSelf.pushGalleryBlock) {
                    weakSelf.pushGalleryBlock();
                }
            }];
        }
        if (!_nameLabel) {
            _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.right + 10, 15, 100, 20)];
            _nameLabel.font = [UIFont systemFontOfSize:14];
            _nameLabel.textColor = [UIColor lightGrayColor];
            _nameLabel.userInteractionEnabled = YES;
            [self.contentView addSubview:_nameLabel];
            [_nameLabel tta_addTapGestureWithTarget:_nameLabel action:^(UITapGestureRecognizer *tap){
                if (weakSelf.pushGalleryBlock) {
                    weakSelf.pushGalleryBlock();
                }
            }];
        }
        if (!_timeLabel) {
            _timeLabel  = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.right + 10, _nameLabel.bottom - 5, 150, 20)];
            _timeLabel.font = [UIFont systemFontOfSize:12];
            _timeLabel.textColor = [UIColor lightGrayColor];
            [self.contentView addSubview:_timeLabel];
        }
        if (!_commentLabel) {
            _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.right + 10, _timeLabel.bottom + 10, kScreen_Width - 70, 1)];
//            _commentLabel.lineBreakMode = NSLineBreakByCharWrapping;
            _commentLabel.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:_commentLabel];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:self.comment.user.userHead] placeholderImage:[UIImage imageNamed:@"icon"]];
    _nameLabel.text = self.comment.user.userAlias;
    _timeLabel.text = [self.comment.date stringDisplay_HHmm];
    [_commentLabel setLongString:self.comment.commentContent withFitWidth:(kScreen_Width - 70)];
}

+ (CGFloat)cellHeightWithModel:(BMComment *)comment {
    CGFloat height = 60;
    height += [comment.commentContent getHeightWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 70, CGFLOAT_MAX)] + 10;
    return height;
}

@end
