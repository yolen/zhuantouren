//
//  Mine_BrickCell.m
//  BrickMan
//
//  Created by 段永瑞 on 16/7/26.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "Mine_BrickCell.h"

@interface Mine_BrickCell ()

@property (nonatomic, strong) UILabel *rankingLbl;

@property (nonatomic, strong) UIImageView *headImgView;

@property (nonatomic, strong) UILabel *nicknameLbl;

@property (nonatomic, strong) UILabel *gradeLbl;

@property (nonatomic, strong) UILabel *numberLbl;

@end

@implementation Mine_BrickCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _rankingLbl = [[UILabel alloc]init];
        _rankingLbl.textAlignment = NSTextAlignmentCenter;
        _rankingLbl.backgroundColor = RGBCOLOR(240, 239, 254);
        UIView *headBackView = [[UIView alloc]init];
        _headImgView = [[UIImageView alloc]init];
        _headImgView.layer.masksToBounds = YES;
        _headImgView.layer.cornerRadius = 49.f/2;
        headBackView.backgroundColor = RGBCOLOR(224, 255, 249);
        [headBackView addSubview:_headImgView];
        _headImgView.translatesAutoresizingMaskIntoConstraints = NO;
        _nicknameLbl = [[UILabel alloc]init];
        _nicknameLbl.textAlignment = NSTextAlignmentCenter;
        _nicknameLbl.numberOfLines = 0;
        _nicknameLbl.backgroundColor = RGBCOLOR(249, 246, 229);
        _gradeLbl = [[UILabel alloc]init];
        _gradeLbl.textAlignment = NSTextAlignmentCenter;
        _gradeLbl.backgroundColor = RGBCOLOR(253, 238, 240);
        _numberLbl = [[UILabel alloc]init];
        _numberLbl.textAlignment = NSTextAlignmentCenter;
        _numberLbl.backgroundColor = RGBCOLOR(196, 226, 240);
        [self.contentView addSubview:_rankingLbl];
        _rankingLbl.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:headBackView];
        headBackView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_nicknameLbl];
        _nicknameLbl.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_gradeLbl];
        _gradeLbl.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_numberLbl];
        _numberLbl.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *viewMetrics = NSDictionaryOfVariableBindings(_rankingLbl,headBackView,_nicknameLbl,_gradeLbl,_numberLbl);
        CGFloat cellWidth = kScreen_Width - 20;
        NSNumber *rankingLblWidth = @(cellWidth * 148/1185.f);
        NSNumber *headBackViewWidth = @(cellWidth * 258/1185.f);
        NSNumber *nicknameLblWidth = @(cellWidth * 258/1185.f);
        NSNumber *gradeLblWidth = @(cellWidth * 260/1185.f);
        NSNumber *numberLblWidth = @(cellWidth * 261/1185.f);
        NSDictionary *widthMetrics = NSDictionaryOfVariableBindings(rankingLblWidth,headBackViewWidth,nicknameLblWidth,gradeLblWidth,numberLblWidth);
        NSArray *hContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_rankingLbl(rankingLblWidth)][headBackView(headBackViewWidth)][_nicknameLbl(nicknameLblWidth)][_gradeLbl(gradeLblWidth)][_numberLbl(numberLblWidth)]" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:widthMetrics views:viewMetrics];
        NSNumber *space = @(5);
        NSDictionary *spaceMetrics = NSDictionaryOfVariableBindings(space);
        NSArray *vContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_rankingLbl]-space-|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:spaceMetrics views:viewMetrics];
        [self addConstraints:hContraints];
        [self addConstraints:vContraints];
        [_headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(headBackView.mas_centerX);
            make.centerY.mas_equalTo(headBackView.mas_centerY);
            make.height.equalTo(@(49));
            make.width.equalTo(@(49));
        }];
    }
    return self;
}

- (void)setModel:(Mine_BrickModel *)model {
    if (model) {
        _model = model;
        self.rankingLbl.text = _model.ranking;
        self.headImgView.image = [UIImage imageNamed:@"about_icon"];
        self.nicknameLbl.text = _model.nickname;
        self.gradeLbl.text = _model.grade;
        if ([NSString isNULLString:_model.numberOfFlower]) {
            self.numberLbl.text = _model.numberOfBrick;
            return;
        }
        self.numberLbl.text = _model.numberOfFlower;
    }
}

+ (CGFloat)cellHeight {
    return 67.f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
