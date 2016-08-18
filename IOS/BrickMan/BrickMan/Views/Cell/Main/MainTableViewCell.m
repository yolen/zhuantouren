//
//  MainTableViewCell.m
//  BrickMan
//
//  Created by TZ on 16/7/21.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "MainTableViewCell.h"
#import "BrickPhotoCell.h"
#import "BMAttachmentModel.h"

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
            _reportBtn.tag = 100;
            _reportBtn.frame = CGRectMake(kScreen_Width - 40, 15, 30, 30);
            [_reportBtn setImage:[UIImage imageNamed:@"report_nor"] forState:UIControlStateNormal];
            [_reportBtn addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
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
            _commentBtn.frame = CGRectMake(10, _separatorLine2.bottom + 3, 60, 30);
            _commentBtn.tag = 101;
            _commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
            [_commentBtn setImage:[UIImage imageNamed:@"commnet_nor"] forState:UIControlStateNormal];
            [_commentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _commentBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [_commentBtn setTitle:@"评论" forState:UIControlStateNormal];
            [_commentBtn addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_commentBtn];
        }
        if (!_flowerBtn) {
            _flowerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _flowerBtn.tag = 102;
            _flowerBtn.frame = CGRectMake(kScreen_Width/2 - 20, _separatorLine2.bottom + 3, 60, 30);
            _flowerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _flowerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
            [_flowerBtn setImage:[UIImage imageNamed:@"flower_nor"] forState:UIControlStateNormal];
            [_flowerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _flowerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [_flowerBtn setTitle:@"鲜花" forState:UIControlStateNormal];
            [_flowerBtn addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_flowerBtn];
        }
        if (!_shareBtn) {
            _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _shareBtn.tag = 103;
            _shareBtn.frame = CGRectMake(kScreen_Width - 60, _separatorLine2.bottom + 3, 60, 30);
            _shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
            [_shareBtn setImage:[UIImage imageNamed:@"share_nor"] forState:UIControlStateNormal];
            [_shareBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _shareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
            [_shareBtn addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)setIsGallery:(BOOL)isGallery {
    _isGallery = isGallery;
    if (_isGallery) {
        [self.reportBtn setUserInteractionEnabled:NO];
        [self.commentBtn setUserInteractionEnabled:NO];
        [self.flowerBtn setUserInteractionEnabled:NO];
        [self.shareBtn setUserInteractionEnabled:NO];
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat curY = 61+20;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.user.userHead] placeholderImage:[UIImage imageNamed:@"user_icon"]];
    _nameLabel.text = self.model.user.userAlias;
    _timeLabel.text = [NSString stringWithFormat:@"%@  %@",[self.model.date stringDisplay_HHmm],self.model.contentPlace];
    [_contentLabel setLongString:self.model.contentTitle withFitWidth:(kScreen_Width - 10)];
    curY += [self.model.contentTitle getHeightWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreen_Width - 20, CGFLOAT_MAX)];
    [_separatorLine2 setY:curY];
    [self.myCollectionView reloadData];
    
    if (self.model.brickContentAttachmentList.count > 0) {
        
        self.myCollectionView.hidden = NO;
    }else {
        if (self.myCollectionView) {
            self.myCollectionView.hidden = YES;
        }
    }
    //collection height
    CGFloat collectionViewHeight = 0;
    NSInteger attachmentCount = self.model.brickContentAttachmentList.count;
    if (attachmentCount == 1) {
        collectionViewHeight = kBrickPhotoCellHeight_One;
    }else if (attachmentCount == 2) {
        collectionViewHeight = kBrickPhotoCellHeight_Two;
    }else if (attachmentCount == 3) {
        collectionViewHeight = kBrickPhotoCellHeight_One + kBrickPhotoCellHeight_Two;
    }else if (attachmentCount == 4) {
        collectionViewHeight = kBrickPhotoCellHeight_One + kBrickPhotoCellWidth_Three;
    }else if (attachmentCount == 5) {
        collectionViewHeight = kBrickPhotoCellHeight_Two + kBrickPhotoCellWidth_Three;
    }else if (attachmentCount == 6) {
        collectionViewHeight =  kBrickPhotoCellWidth_Three * 2;
    }else if (attachmentCount == 7) {
        collectionViewHeight = kBrickPhotoCellHeight_One + kBrickPhotoCellWidth_Three * 2;
    }else if (attachmentCount == 8) {
        collectionViewHeight = kBrickPhotoCellHeight_Two + kBrickPhotoCellWidth_Three * 2;
    }else if (attachmentCount == 9) {
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
    return self.model.brickContentAttachmentList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BrickPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_BrickPhotoCell forIndexPath:indexPath];
    cell.attachmentModel = self.model.brickContentAttachmentList[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    NSInteger attachmentCount = self.model.brickContentAttachmentList.count;
    if (attachmentCount == 1) {
        size = CGSizeMake(kBrickPhotoCellWidth_One, kBrickPhotoCellHeight_One);
    }else if (attachmentCount == 2) {
        size = CGSizeMake(kBrickPhotoCellWidth_Two, kBrickPhotoCellHeight_Two);
    }else if (attachmentCount == 3) {
        if (indexPath.row == 0) {
            size = CGSizeMake(kBrickPhotoCellWidth_One, kBrickPhotoCellHeight_One);
        }else {
            size = CGSizeMake(kBrickPhotoCellWidth_Two, kBrickPhotoCellWidth_Two);
        }
    }else if (attachmentCount == 4) {
        if (indexPath.row == 0) {
            size = CGSizeMake(kBrickPhotoCellWidth_One, kBrickPhotoCellHeight_One);
        }else {
            size = CGSizeMake(kBrickPhotoCellWidth_Three, kBrickPhotoCellWidth_Three);
        }
    }else if (attachmentCount == 5) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            size = CGSizeMake(kBrickPhotoCellWidth_Two, kBrickPhotoCellHeight_Two);
        }else {
            size = CGSizeMake(kBrickPhotoCellWidth_Three, kBrickPhotoCellWidth_Three);
        }
    }else if (attachmentCount == 6) {
        size = CGSizeMake(kBrickPhotoCellWidth_Three, kBrickPhotoCellWidth_Three);
    }else if (attachmentCount == 7) {
        if (indexPath.row == 0) {
            size = CGSizeMake(kBrickPhotoCellWidth_One, kBrickPhotoCellHeight_One);
        }else {
            size = CGSizeMake(kBrickPhotoCellWidth_Three, kBrickPhotoCellWidth_Three);
        }
    }else if (attachmentCount == 8) {
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
- (void)operationAction:(UIButton *)button {
    NSInteger tag = button.tag;
    BMAttachmentModel *attachmentModel = self.model.brickContentAttachmentList[0];
    NSString *contentId = [attachmentModel.contentId stringValue];
    __weak typeof(self) weakSelf = self;
    
    switch (tag) {
        case 100:{ //举报
            BOOL preReportSel = [self.model.contentReports boolValue];
            [[BrickManAPIManager shareInstance] requestOperContentWithParams:@{@"contentId" : contentId, @"operType" : @"3"} andBlock:^(id data, NSError *error) {
                if (data) {
                    weakSelf.reportBtn.selected = !preReportSel;
                }else {
                    weakSelf.reportBtn.selected = preReportSel;
                }
                [self.reportBtn setImage:[UIImage imageNamed:(self.reportBtn.selected == YES ? @"report_sel" : @"report_nor")] forState:UIControlStateNormal];
            }];
        }
            break;
        case 101:{ //评论
            if (self.commentBlock) {
                self.commentBlock();
            }
        }
            break;
        case 102:{ //鲜花
            BOOL preFlowerSel = [self.model.contentFlowors boolValue];
            [[BrickManAPIManager shareInstance] requestOperContentWithParams:@{@"contentId" : contentId, @"operType" : @"1"} andBlock:^(id data, NSError *error) {
                if (data) {
                    weakSelf.flowerBtn.selected = !preFlowerSel;
                }else {
                    weakSelf.flowerBtn.selected = preFlowerSel;
                }
                [weakSelf.flowerBtn setImage:[UIImage imageNamed:(self.flowerBtn.selected == YES ? @"flower_sel" : @"flower_nor")] forState:UIControlStateNormal];
            }];
        }
            break;
        case 103:{ //分享
            if (self.shareBlock) {
                self.shareBlock();
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)flowerAction:(id)sender {
    self.flowerBtn.selected = !self.flowerBtn.selected;
    [self.flowerBtn setImage:[UIImage imageNamed:(self.flowerBtn.selected == YES ? @"flower_sel" : @"flower_nor")] forState:UIControlStateNormal];
}

- (void)reportAction:(id)sender {
    self.reportBtn.selected = !self.reportBtn.selected;
    [self.reportBtn setImage:[UIImage imageNamed:(self.reportBtn.selected == YES ? @"report_sel" : @"report_nor")] forState:UIControlStateNormal];
}

#pragma mark - cellHeight
+ (CGFloat)cellHeightWithModel:(BMContentModel *)contentModel {
    
    CGFloat height = 60;
    height += [contentModel.contentTitle getHeightWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(kScreen_Width - 10, 200)] + 20;
    height += 30 + 3;
    CGFloat collectionViewHeight = 0;
    NSInteger attachmentCount = contentModel.brickContentAttachmentList.count;
    if (attachmentCount == 1) {
        collectionViewHeight = kBrickPhotoCellHeight_One;
    }else if (attachmentCount == 2) {
        collectionViewHeight = kBrickPhotoCellHeight_Two;
    }else if (attachmentCount == 3) {
        collectionViewHeight = kBrickPhotoCellHeight_One + kBrickPhotoCellHeight_Two;
    }else if (attachmentCount == 4) {
        collectionViewHeight = kBrickPhotoCellHeight_One + kBrickPhotoCellWidth_Three;
    }else if (attachmentCount == 5) {
        collectionViewHeight = kBrickPhotoCellHeight_Two + kBrickPhotoCellWidth_Three;
    }else if (attachmentCount == 6) {
        collectionViewHeight = kBrickPhotoCellWidth_Three * 2;
    }else if (attachmentCount == 7) {
        collectionViewHeight = kBrickPhotoCellHeight_One + kBrickPhotoCellWidth_Three * 2;
    }else if (attachmentCount == 8) {
        collectionViewHeight = kBrickPhotoCellHeight_Two + kBrickPhotoCellWidth_Three * 2;
    }else if(attachmentCount == 9) {
        collectionViewHeight = kBrickPhotoCellWidth_Three * 3;
    }
    height += collectionViewHeight + 20;
    return height;
}

@end
