//
//  MainTableViewCell.m
//  BrickMan
//
//  Created by TZ on 16/7/21.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kContentString @"人生应该如蜡烛一样,从顶燃到底,一直都是光明的.身边总有那么些好人好事,让生活更美好"
#import "MainTableViewCell.h"
#import "BrickPhotoCell.h"

@interface MainTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UIImageView *iconImageView;
@property (strong, nonatomic) UILabel *nameLabel, *timeLabel, *contentLabel;
@property (strong, nonatomic) UIView *separatorLine, *separatorLine2, *bottomView;
@property (strong, nonatomic) UIButton  *reportBtn,*commentBtn, *flowerBtn, *shareBtn;
@property (strong, nonatomic) UICollectionView *myCollectionView;
@property (strong, nonatomic) NSDictionary *dic;
@property (strong, nonatomic) NSArray *imageArray;
@end

@implementation MainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!_iconImageView) {
            _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPaddingLeft, 10, 40, 40)];
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
            [_reportBtn addTarget:self action:@selector(reportAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_reportBtn];
        }
        if (!_separatorLine) {
            _separatorLine = [[UIView alloc] initWithFrame:CGRectMake(kPaddingLeft, _iconImageView.bottom + 10, kScreen_Width - 20, 0.5)];
            _separatorLine.backgroundColor = kLineColor;
            [self.contentView addSubview:_separatorLine];
        }
        if (!_contentLabel) {
            _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPaddingLeft, _separatorLine.bottom + 10, kScreen_Width - 20, 1)];
            _contentLabel.numberOfLines = 0;
            _contentLabel.font = [UIFont systemFontOfSize:12];
            [self.contentView addSubview:_contentLabel];
        }
        if (!_myCollectionView) {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kPaddingLeft, _contentLabel.bottom, kScreen_Width - 2*kPaddingLeft, 1) collectionViewLayout:layout];
            _myCollectionView.delegate = self;
            _myCollectionView.dataSource = self;
            _myCollectionView.scrollEnabled = NO;
            _myCollectionView.backgroundColor = kViewBGColor;
            [_myCollectionView registerClass:[BrickPhotoCell class] forCellWithReuseIdentifier:kCellIdentifier_BrickPhotoCell];
            [self.contentView addSubview:_myCollectionView];
        }
        if (!_separatorLine2) {
            _separatorLine2 = [[UIView alloc] initWithFrame:CGRectMake(kPaddingLeft, _contentLabel.bottom + 5, kScreen_Width - 20, 0.5)];
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
            [_commentBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
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
            [_flowerBtn addTarget:self action:@selector(flowerAction:) forControlEvents:UIControlEventTouchUpInside];
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
            [_shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)setData:(NSDictionary *)dataDic {
    self.dic = dataDic;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat curY = 61+20;
    if (!self.dic) {
        return;
    }
    self.imageArray = self.dic[@"photo"];
    
    _iconImageView.image = [UIImage imageNamed:@"user_icon"];
    _nameLabel.text = self.dic[@"name"];
    _timeLabel.text = self.dic[@"date"];
    [_contentLabel setLongString:self.dic[@"content"] withFitWidth:(kScreen_Width - 10)];
    curY += [kContentString getHeightWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreen_Width - 20, CGFLOAT_MAX)];
    [_separatorLine2 setY:curY];
    
    //collection height
    CGFloat collectionViewHeight = 0;
    if (self.imageArray.count == 1) {
        collectionViewHeight = kBrickPhotoCellHeight_One;
    }else if (self.imageArray.count == 2) {
        collectionViewHeight = kBrickPhotoCellHeight_Two;
    }else if (self.imageArray.count == 3) {
        collectionViewHeight = kBrickPhotoCellHeight_One + kBrickPhotoCellHeight_Two;
    }else if (self.imageArray.count == 4) {
        collectionViewHeight = kBrickPhotoCellHeight_One + kBrickPhotoCellWidth_Three;
    }else if (self.imageArray.count == 5) {
        collectionViewHeight = kBrickPhotoCellHeight_Two + kBrickPhotoCellWidth_Three;
    }else if (self.imageArray.count == 6) {
        collectionViewHeight =  kBrickPhotoCellWidth_Three * 2;
    }else if (self.imageArray.count == 7) {
        collectionViewHeight = kBrickPhotoCellHeight_One + kBrickPhotoCellWidth_Three * 2;
    }else if (self.imageArray.count == 8) {
        collectionViewHeight = kBrickPhotoCellHeight_Two + kBrickPhotoCellWidth_Three * 2;
    }else if (self.imageArray.count == 9) {
        collectionViewHeight = kBrickPhotoCellWidth_Three * 3;
    }
    _myCollectionView.height = collectionViewHeight;
    [_myCollectionView reloadData];
    [_myCollectionView setY:curY];
    curY += collectionViewHeight;
    
    curY += 3;
    [_commentBtn setY:curY];
    [_flowerBtn setY:curY];
    [_shareBtn setY:curY];
    
    curY += 30;
    [_bottomView setY:curY];
}

#pragma mark - collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BrickPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_BrickPhotoCell forIndexPath:indexPath];
    cell.photoImage = [UIImage imageNamed:self.imageArray[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    if (self.imageArray.count == 1) {
        size = CGSizeMake(kBrickPhotoCellWidth_One, kBrickPhotoCellHeight_One);
    }else if (self.imageArray.count == 2) {
        size = CGSizeMake(kBrickPhotoCellWidth_Two, kBrickPhotoCellHeight_Two);
    }else if (self.imageArray.count == 3) {
        if (indexPath.row == 0) {
            size = CGSizeMake(kBrickPhotoCellWidth_One, kBrickPhotoCellHeight_One);
        }else {
            size = CGSizeMake(kBrickPhotoCellWidth_Two, kBrickPhotoCellWidth_Two);
        }
    }else if (self.imageArray.count == 4) {
        if (indexPath.row == 0) {
            size = CGSizeMake(kBrickPhotoCellWidth_One, kBrickPhotoCellHeight_One);
        }else {
            size = CGSizeMake(kBrickPhotoCellWidth_Three, kBrickPhotoCellWidth_Three);
        }
    }else if (self.imageArray.count == 5) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            size = CGSizeMake(kBrickPhotoCellWidth_Two, kBrickPhotoCellHeight_Two);
        }else {
            size = CGSizeMake(kBrickPhotoCellWidth_Three, kBrickPhotoCellWidth_Three);
        }
    }else if (self.imageArray.count == 6) {
        size = CGSizeMake(kBrickPhotoCellWidth_Three, kBrickPhotoCellWidth_Three);
    }else if (self.imageArray.count == 7) {
        if (indexPath.row == 0) {
            size = CGSizeMake(kBrickPhotoCellWidth_One, kBrickPhotoCellHeight_One);
        }else {
            size = CGSizeMake(kBrickPhotoCellWidth_Three, kBrickPhotoCellWidth_Three);
        }
    }else if (self.imageArray.count == 8) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            size = CGSizeMake(kBrickPhotoCellWidth_Two, kBrickPhotoCellHeight_Two);
        }else {
            size = CGSizeMake(kBrickPhotoCellWidth_Three, kBrickPhotoCellWidth_Three);
        }
    }else {
        size = CGSizeMake(kBrickPhotoCellWidth_Three, kBrickPhotoCellWidth_Three);
    }
    
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 3.8;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 3.8;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Btn Action
- (void)commentAction:(id)sender {
    if (self.commentBlock) {
        self.commentBlock();
    }
}

- (void)flowerAction:(id)sender {
    self.flowerBtn.selected = !self.flowerBtn.selected;
    [self.flowerBtn setImage:[UIImage imageNamed:(self.flowerBtn.selected == YES ? @"flower_sel" : @"flower_nor")] forState:UIControlStateNormal];
}

- (void)shareAction:(id)sender {
    if (self.shareBlock) {
        self.shareBlock();
    }
}

- (void)reportAction:(id)sender {
    self.reportBtn.selected = !self.reportBtn.selected;
    [self.reportBtn setImage:[UIImage imageNamed:(self.reportBtn.selected == YES ? @"report_sel" : @"report_nor")] forState:UIControlStateNormal];
}

#pragma mark - cellHeight
+ (CGFloat)cellHeightWithImageArray:(NSDictionary *)dataDic {
    NSArray *imageArray = dataDic[@"photo"];
    
    CGFloat height = 60;
    NSString *contentStr = dataDic[@"content"];
    height += [contentStr getHeightWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreen_Width - 10, 200)] + 20;
    height += 30 + 3;
    CGFloat collectionViewHeight = 0;
    if (imageArray.count == 1) {
        collectionViewHeight = kBrickPhotoCellHeight_One;
    }else if (imageArray.count == 2) {
        collectionViewHeight = kBrickPhotoCellHeight_Two;
    }else if (imageArray.count == 3) {
        collectionViewHeight = kBrickPhotoCellHeight_One + kBrickPhotoCellHeight_Two;
    }else if (imageArray.count == 4) {
        collectionViewHeight = kBrickPhotoCellHeight_One + kBrickPhotoCellWidth_Three;
    }else if (imageArray.count == 5) {
        collectionViewHeight = kBrickPhotoCellHeight_Two + kBrickPhotoCellWidth_Three;
    }else if (imageArray.count == 6) {
        collectionViewHeight = kBrickPhotoCellWidth_Three * 2;
    }else if (imageArray.count == 7) {
        collectionViewHeight = kBrickPhotoCellHeight_One + kBrickPhotoCellWidth_Three * 2;
    }else if (imageArray.count == 8) {
        collectionViewHeight = kBrickPhotoCellHeight_Two + kBrickPhotoCellWidth_Three * 2;
    }else if(imageArray.count == 9) {
        collectionViewHeight = kBrickPhotoCellWidth_Three * 3;
    }
    height += collectionViewHeight + 10;
    return height;
}

@end
