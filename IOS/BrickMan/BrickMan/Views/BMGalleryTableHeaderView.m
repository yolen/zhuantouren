//
//  BMGalleryTableHeaderView.m
//  BrickMan
//
//  Created by ys on 16/11/11.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BMGalleryTableHeaderView.h"

#define kHEAD_WIDTH_BG kScreen_Width / 5
#define kHEAD_WIDTH (kHEAD_WIDTH_BG - 10)

@implementation BMGalleryTableHeaderView {
    /** 用户头像 */
    UIImageView *_headerImageView;
    /** 用户昵称 */
    UILabel *_nickNameLabel;
    /** 用户性别 */
    UIImageView *_ganderImageView;
    /** 用户座右铭 */
    UILabel *_motoLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"zhuanji_bg"].CGImage);
    
    // creat
    UIView *headerImageBgView = [[UIView alloc] init];
    _headerImageView = [[UIImageView alloc] init];
    _nickNameLabel = [[UILabel alloc] init];
    _ganderImageView = [[UIImageView alloc] init];
    _motoLabel = [[UILabel alloc] init];
    
    // config
    headerImageBgView.backgroundColor = [UIColor whiteColor];
    headerImageBgView.frame = CGRectMake(0, 0, kHEAD_WIDTH_BG, kHEAD_WIDTH_BG);
    headerImageBgView.layer.cornerRadius = kHEAD_WIDTH_BG / 2;
    headerImageBgView.layer.masksToBounds = YES;
    
    [_headerImageView setImage:[UIImage imageNamed:@"icon"]];
    _headerImageView.backgroundColor = [UIColor whiteColor];
    _headerImageView.frame = CGRectMake(0, 0, kHEAD_WIDTH, kHEAD_WIDTH);
    _headerImageView.layer.cornerRadius  =kHEAD_WIDTH / 2;
    _headerImageView.layer.masksToBounds = YES;
    _ganderImageView.image = [UIImage imageNamed:@"man"];
    _nickNameLabel.textAlignment = NSTextAlignmentCenter;
    _nickNameLabel.textColor = [UIColor whiteColor];
    _nickNameLabel.font = [UIFont boldSystemFontOfSize:17];
    
    _motoLabel.textAlignment = NSTextAlignmentCenter;
    _motoLabel.textColor = [UIColor whiteColor];
    _motoLabel.font = [UIFont systemFontOfSize:16];
    
    
    _motoLabel.text=@"moto";
    _nickNameLabel.text = @"nick name";
    
    // add
    [self addSubview:headerImageBgView];
    [self addSubview:_headerImageView];
    [self addSubview:_nickNameLabel];
    [self addSubview:_ganderImageView];
    [self addSubview:_motoLabel];
    
    // layout
    [headerImageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.mas_width).dividedBy(5);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-10);
    }];
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(headerImageBgView.center);
        make.top.left.mas_equalTo(headerImageBgView).offset(5);
        make.right.bottom.mas_equalTo(headerImageBgView).offset(-5);
    }];
    
    [_motoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
    }];
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(-10);
        make.bottom.mas_equalTo(_motoLabel.mas_top).offset(-15);
    }];
    [_ganderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nickNameLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(_nickNameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)configHeaderViewWithUser:(BMUser *)user  {
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:user.userHead] placeholderImage:[UIImage imageNamed:@"icon"]];
    _ganderImageView.image = [user.userSexStr isEqualToString:@"男"] ? [UIImage imageNamed:@"man"] : [UIImage imageNamed:@"woman"];
    
    _nickNameLabel.text = user.userName;
    _motoLabel.text = user.motto;
}

@end
