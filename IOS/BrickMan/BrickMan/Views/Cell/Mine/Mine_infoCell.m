//
//  Mine_infoCell.m
//  BrickMan
//
//  Created by 段永瑞 on 16/7/22.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "Mine_infoCell.h"

@implementation Mine_infoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.bounds = CGRectMake(0, 0, 100, 35);
        _titleLabel.center = CGPointMake(10 + _titleLabel.width/2, [[self class] cellHeight]/2);
        [self.contentView addSubview:_titleLabel];
        _subLabel = [[UILabel alloc]init];
        _subLabel.enabled = NO;
        _subLabel.textAlignment = NSTextAlignmentRight;
        _subLabel.bounds = CGRectMake(0, 0, 250, 30);
        _subLabel.center = CGPointMake(kScreen_Width - _subLabel.width/2 - 30, [[self class] cellHeight]/2);
        [self.contentView addSubview:_subLabel];
        _subImgView = [[UIImageView alloc]init];
        _subImgView.bounds = CGRectMake(0, 0, 40, 40);
        _subImgView.layer.masksToBounds = YES;
        _subImgView.layer.cornerRadius = _subImgView.width/2;
        _subImgView.center = CGPointMake(kScreen_Width - _subImgView.width/2 - 30, [[self class] cellHeight]/2);
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:_subImgView];
        self.backgroundColor = [UIColor whiteColor];
    };
    return self;
}

+ (CGFloat)cellHeight {
    return 74.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
