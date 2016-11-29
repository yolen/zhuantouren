//
//  BMGalleryTableHeaderView.m
//  BrickMan
//
//  Created by ys on 16/11/11.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BMGalleryTableHeaderView.h"

#define kHEAD_WIDTH_BG kScreen_Width / 5
#define kPADDING 3
#define kHEAD_WIDTH (kHEAD_WIDTH_BG - 2 * kPADDING)

@implementation BMGalleryTableHeaderView {
    UIImageView *_bgImageView;
    /** 用户头像 */
    UIImageView *_headerImageView;
    UIView *_headerImageBgView;
    /** 用户昵称 */
    UILabel *_nickNameLabel;
    /** 用户性别 */
    UIImageView *_ganderImageView;
    /** 用户座右铭 */
    UILabel *_mottoLabel;
    /** 返回按钮 */
    UIButton *_backButton;
    /** 标题,显示为:XX 的砖集 */
    UILabel *_titleLable;
    
    UIView *_navCustomBgView;
    BOOL _isAnimation;
    CGFloat _lastOffset;
    BOOL _isScrollUp;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zhuanji_bg"]];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundColor = kNavigationBarColor;
    
    // creat
    _headerImageBgView = [[UIView alloc] init];
    _headerImageView = [[UIImageView alloc] init];
    _nickNameLabel = [[UILabel alloc] init];
    _ganderImageView = [[UIImageView alloc] init];
    _mottoLabel = [[UILabel alloc] init];
    _backButton = [[UIButton alloc] init];
    _titleLable = [[UILabel alloc] init];
    
    _navCustomBgView = [[UIView alloc] init];
    
    // config
    _headerImageBgView.backgroundColor = [UIColor whiteColor];
    _headerImageBgView.frame = CGRectMake(0, 0, kHEAD_WIDTH_BG, kHEAD_WIDTH_BG);
    _headerImageBgView.layer.cornerRadius = kHEAD_WIDTH_BG / 2;
    _headerImageBgView.layer.masksToBounds = YES;
    _headerImageBgView.contentMode = UIViewContentModeScaleAspectFill;
    
    [_headerImageView setImage:[UIImage imageNamed:@"icon"]];
    _headerImageView.backgroundColor = [UIColor whiteColor];
    _headerImageView.frame = CGRectMake(0, 0, kHEAD_WIDTH, kHEAD_WIDTH);
    _headerImageView.layer.cornerRadius  =kHEAD_WIDTH / 2;
    _headerImageView.layer.masksToBounds = YES;
    _ganderImageView.image = [UIImage imageNamed:@"man"];
    _nickNameLabel.textAlignment = NSTextAlignmentCenter;
    _nickNameLabel.textColor = [UIColor whiteColor];
    _nickNameLabel.font = [UIFont boldSystemFontOfSize:17];
    
    _mottoLabel.textAlignment = NSTextAlignmentCenter;
    _mottoLabel.textColor = [UIColor whiteColor];
    _mottoLabel.font = [UIFont systemFontOfSize:16];
    
    [_backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(didClickBackButton) forControlEvents:UIControlEventTouchUpInside];
    _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    _backButton.alpha = 0;
    
    _titleLable.textColor = [UIColor whiteColor];
    _titleLable.font = [UIFont boldSystemFontOfSize:18];
//    _titleLable.alpha = 0;
    _titleLable.text = @"砖集";
    
    _navCustomBgView.backgroundColor = kNavigationBarColor;
    _navCustomBgView.alpha = 0.0;
    
    _mottoLabel.text=@"motto";
    _nickNameLabel.text = @"nick name";
    
    // add
    [self addSubview:_bgImageView];
    [self addSubview:_headerImageBgView];
    [self addSubview:_headerImageView];
    [self addSubview:_nickNameLabel];
    [self addSubview:_ganderImageView];
    [self addSubview:_mottoLabel];
    [self addSubview:_navCustomBgView];
    [self addSubview:_backButton];
    [self addSubview:_titleLable];
    
    [_headerImageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.mas_width).dividedBy(5);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-10 * SCALE);
    }];
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(_headerImageBgView).offset(kPADDING);
        make.right.bottom.mas_equalTo(_headerImageBgView).offset(-kPADDING);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _bgImageView.frame = self.bounds;
    
    // layout
    [_mottoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-15 * SCALE);
    }];
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).offset(-10);
        make.bottom.mas_equalTo(_mottoLabel.mas_top).offset(-15 * SCALE);
    }];
    [_ganderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_nickNameLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(_nickNameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(8);
        make.top.mas_equalTo([UIApplication sharedApplication].keyWindow.mas_top).offset(26);
        make.size.mas_equalTo(CGSizeMake(38, 30));
    }];
    
    [_titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo([UIApplication sharedApplication].keyWindow.mas_top).offset(28);
    }];
    
    [_navCustomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo([UIApplication sharedApplication].keyWindow);
        make.height.mas_equalTo(64);
    }];
}

- (void)configHeaderViewWithUser:(BMUser *)user  {
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:user.userHead] placeholderImage:[UIImage imageNamed:@"icon"]];
    _ganderImageView.image = [user.userSexStr isEqualToString:@"男"] ? [UIImage imageNamed:@"man"] : [UIImage imageNamed:@"woman"];
    
    _nickNameLabel.text = user.userAlias;
    _titleLable.text = user.userAlias ? [NSString stringWithFormat:@"%@的砖集", [user.userAlias isEqualToString: [BMUser getUserModel].userAlias] ? @"我" : user.userAlias] : @"砖集";
    _mottoLabel.text = user.motto.length == 0 ? @"路见不平,拍砖相助!" : user.motto;
}

- (void)configItemsWith:(CGFloat)offset {
    _isScrollUp = offset > _lastOffset ? YES : NO;
    _lastOffset = offset;
    if (offset > 0) {
        CGFloat min = self.height - 64;
        CGFloat progress = 1 - (offset / min);
//        if (progress < 0.5) {
//            if (!_isAnimation && _isScrollUp) {
//                _isAnimation = YES;
//                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenNavAnimation) object:nil];
//                [self performSelector:@selector(showNavAnimation) withObject:nil];
//            } else if (progress > 0 && !_isAnimation && ! _isScrollUp) {
//                _isAnimation = YES;
//                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showNavAnimation) object:nil];
//                [self performSelector:@selector(hiddenNavAnimation) withObject:nil];
//            }
//        }
//        _backButton.alpha = 1 - progress - 0.1;
        _titleLable.alpha = 1 - progress - 0.1;
        _bgImageView.alpha = progress + 0.1;
        _nickNameLabel.alpha = progress;
        _ganderImageView.alpha = progress;
        _mottoLabel.alpha = progress;
    } else {
        _bgImageView.alpha = 1.0;
//        _backButton.alpha = 0.0;
        _titleLable.alpha = 0.0;
//        [UIView animateWithDuration:0.5 animations:^{
//            _navCustomBgView.alpha = 1.0;
//        }];
    }
}

- (void)showNavAnimation {
    [UIView animateWithDuration:1.0 animations:^{
        _navCustomBgView.alpha = 1.0;
    } completion:^(BOOL finished) {
        _isAnimation = NO;
    }];
}

- (void)hiddenNavAnimation {
    [UIView animateWithDuration:0.5 animations:^{
        _navCustomBgView.alpha = 0.0;
    } completion:^(BOOL finished) {
        _isAnimation = NO;
    }];
}

#pragma mark - Actions
- (void)didClickBackButton {
    if (self.popGalleryBlock) {
        self.popGalleryBlock();
    }
}

#pragma mark - Getter && Setter

@end
