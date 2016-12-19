//
//  MainTableViewCell.m
//  BrickMan
//
//  Created by TZ on 16/7/21.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kBrickPhotoCellWidth_One (kScreen_Width - 20.0)
#import "MainTableViewCell.h"
#import "BrickPhotoCell.h"
#import "BrickPhotoSingleCell.h"
#import "BMAttachment.h"
#import "UICustomCollectionView.h"
#import "GalleryController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface MainTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UIImageView *iconImageView, *sexIcon;
@property (strong, nonatomic) UILabel *nameLabel, *timeLabel, *contentLabel, *locationLabel;
@property (strong, nonatomic) UIView *separatorLine, *separatorLine2, *bottomView;
@property (strong, nonatomic) UIButton *flowerBtn;
@property (strong, nonatomic) UICustomCollectionView *myCollectionView;

@property (strong, nonatomic) NSDictionary *dic;
@property (strong, nonatomic) NSArray *imageArray;
@end

@implementation MainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        __weak typeof(self) weakSelf = self;
        if (!_iconImageView) {
            _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPaddingLeft, 10, 40, 40)];
            _iconImageView.layer.cornerRadius = _iconImageView.width/2;
            _iconImageView.layer.masksToBounds = YES;
            _iconImageView.userInteractionEnabled = YES;
            [_iconImageView tta_addTapGestureWithTarget:_iconImageView action:^(UITapGestureRecognizer *tap){
                if (weakSelf.pushGalleryBlock) {
                    weakSelf.pushGalleryBlock();
                }
            }];
            [self.contentView addSubview:_iconImageView];
        }
        if (!_nameLabel) {
            _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.right + 10, 15, 1, 20)];
            _nameLabel.font = [UIFont systemFontOfSize:14];
            _nameLabel.userInteractionEnabled = YES;
            [_nameLabel tta_addTapGestureWithTarget:_nameLabel action:^(UITapGestureRecognizer *tap){
                if (weakSelf.pushGalleryBlock) {
                    weakSelf.pushGalleryBlock();
                }
            }];
            [self.contentView addSubview:_nameLabel];
        }
        if (!_sexIcon) {
            _sexIcon = [[UIImageView alloc] initWithFrame:CGRectMake(_nameLabel.right + 5, 17, 16, 16)];
            [self.contentView addSubview:_sexIcon];
        }
        if (!_timeLabel) {
            _timeLabel  = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.right + 10, _nameLabel.bottom - 5, 150, 20)];
            _timeLabel.font = [UIFont systemFontOfSize:12];
            _timeLabel.textColor = [UIColor lightGrayColor];
            _timeLabel.userInteractionEnabled = YES;
            [_timeLabel tta_addTapGestureWithTarget:_timeLabel action:^(UITapGestureRecognizer *tap){
                if (weakSelf.pushGalleryBlock) {
                    weakSelf.pushGalleryBlock();
                }
            }];
            [self.contentView addSubview:_timeLabel];
        }
        if (!_separatorLine) {
            _separatorLine = [[UIView alloc] initWithFrame:CGRectMake(kPaddingLeft, _iconImageView.bottom + 10, kScreen_Width - 20, 0.5)];
            _separatorLine.backgroundColor = kLineColor;
            [self.contentView addSubview:_separatorLine];
        }
        if (!_contentLabel) {
            _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPaddingLeft, _separatorLine.bottom + 10, kScreen_Width - 20, 1)];
            _contentLabel.numberOfLines = 0;
            _contentLabel.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:_contentLabel];
        }
        if (!_myCollectionView) {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            _myCollectionView = [[UICustomCollectionView alloc] initWithFrame:CGRectMake(kPaddingLeft, _contentLabel.bottom, kScreen_Width - 2*kPaddingLeft, 1) collectionViewLayout:layout];
            _myCollectionView.delegate = self;
            _myCollectionView.dataSource = self;
            _myCollectionView.scrollEnabled = NO;
            _myCollectionView.backgroundView = nil;
            _myCollectionView.backgroundColor = [UIColor clearColor];
            [_myCollectionView registerClass:[BrickPhotoCell class] forCellWithReuseIdentifier:kCellIdentifier_BrickPhotoCell];
            [_myCollectionView registerClass:[BrickPhotoSingleCell class] forCellWithReuseIdentifier:kCellIdentifier_BrickPhotoSingleCell];
            [self.contentView addSubview:_myCollectionView];
        }
        
        if (!_locationLabel) {
            _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPaddingLeft, _myCollectionView.bottom + 3, kScreen_Width - 2*kPaddingLeft, 10)];
            _locationLabel.textColor = [UIColor lightGrayColor];
            _locationLabel.font = [UIFont systemFontOfSize:12];
            [self.contentView addSubview:_locationLabel];
        }
        if (!_commentBtn) {
            _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _commentBtn.frame = CGRectMake(15, _myCollectionView.bottom + 3, 75*SCALE, 30);
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
            _flowerBtn.frame = CGRectMake(_commentBtn.right, _separatorLine2.bottom + 3, 75*SCALE, 30);
            _flowerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _flowerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
            [_flowerBtn setImage:[UIImage imageNamed:@"flower_nor"] forState:UIControlStateNormal];
            [_flowerBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _flowerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [_flowerBtn setTitle:@"鲜花" forState:UIControlStateNormal];
            [_flowerBtn addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_flowerBtn];
        }
        if (!_brickBtn) {
            _brickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _brickBtn.tag = 104;
            _brickBtn.frame = CGRectMake(_flowerBtn.right, _separatorLine2.bottom + 3, 75*SCALE, 30);
            _brickBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            _brickBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
            [_brickBtn setImage:[UIImage imageNamed:@"brick_nor"] forState:UIControlStateNormal];
            [_brickBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            _brickBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [_brickBtn setTitle:@"拍砖" forState:UIControlStateNormal];
            [_brickBtn addTarget:self action:@selector(operationAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_brickBtn];
        }
        
        if (!_shareBtn) {
            _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _shareBtn.tag = 103;
            _shareBtn.frame = CGRectMake(kScreen_Width - 75*SCALE, _separatorLine2.bottom + 3, 75*SCALE, 30);
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
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.user.userHead ? self.model.user.userHead : [BMUser getUserModel].userHead] placeholderImage:[UIImage imageNamed:@"icon"]];
    
    NSString *name = self.model.user.userAlias ? self.model.user.userAlias : [BMUser getUserModel].userAlias;
    CGFloat nameWidth = [name getWidthWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(150, 20)];
    _nameLabel.text = name;
    _nameLabel.width = nameWidth;
    
    _sexIcon.left = kPaddingLeft + 55 + nameWidth;
    _sexIcon.image = [UIImage imageNamed:([self.model.user.userSex isEqualToString:@"USER_SEX01"] ? @"man" : @"woman")];
    
    _timeLabel.text = [self.model.date stringDisplay_HHmm];
    [_contentLabel setLongString:[self.model.contentTitle stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withFitWidth:(kScreen_Width - 10)];
    curY += [self.model.contentTitle getHeightWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 20, CGFLOAT_MAX)];
    [_separatorLine2 setY:curY];
    
    if (self.model.brickContentAttachmentList.count > 0) {
        [self.myCollectionView reloadData];
        self.myCollectionView.hidden = NO;
    }else {
        if (self.myCollectionView) {
            self.myCollectionView.hidden = YES;
        }
    }
    //collection height
    CGFloat collectionViewHeight = 0;
    NSArray *attachmentArray = self.model.brickContentAttachmentList;
    if (attachmentArray.count == 1) {
        collectionViewHeight = [BrickPhotoSingleCell cellHeithWithAttachment:attachmentArray.firstObject].height;
    }else {
        collectionViewHeight = [BrickPhotoCell cellHeithWithAttachment:attachmentArray.firstObject].height * ceilf((float)attachmentArray.count/3);
    }

    _myCollectionView.height = collectionViewHeight;
    [_myCollectionView reloadData];
    [_myCollectionView setY:curY];
    curY += collectionViewHeight;
    
    [_locationLabel setY:curY+4];
    _locationLabel.text = self.model.contentPlace;
    curY += 16;
    
    [_reportBtn setImage:[UIImage imageNamed:(self.model.contentReports.integerValue > 0 ? @"report_sel" : @"report_nor")] forState:UIControlStateNormal];
    curY += 3;
    [_commentBtn setY:curY];
    [_commentBtn setTitle:(self.model.commentCount.integerValue > 0 ? [NSString stringWithFormat:@"评论 %@",self.model.commentCount] : @"评论 0") forState:UIControlStateNormal];
    [_commentBtn setImage:[UIImage imageNamed:(self.model.commentCount.integerValue > 0 ? @"comment_sel" : @"commnet_nor")] forState:UIControlStateNormal];
    [_flowerBtn setY:curY];
    [_flowerBtn setTitle:(self.model.contentFlowors.integerValue > 0 ? [NSString stringWithFormat:@"鲜花 %@",self.model.contentFlowors] : @"鲜花 0") forState:UIControlStateNormal];
    [_flowerBtn setImage:[UIImage imageNamed:(self.model.contentFlowors.integerValue > 0 ? @"flower_sel" : @"flower_nor")] forState:UIControlStateNormal];
    [_shareBtn setY:curY];
    [_shareBtn setTitle:(self.model.contentShares.integerValue > 0 ? [NSString stringWithFormat:@"分享 %@",self.model.contentShares] : @"分享 0") forState:UIControlStateNormal];
    [_shareBtn setImage:[UIImage imageNamed:(self.model.contentShares.integerValue > 0 ? @"share_sel" : @"share_nor")] forState:UIControlStateNormal];
    [_brickBtn setY:curY];
    [_brickBtn setTitle:(self.model.contentBricks.integerValue > 0 ? [NSString stringWithFormat:@"拍砖 %@",self.model.contentBricks] : @"拍砖 0") forState:UIControlStateNormal];
    [_brickBtn setImage:[UIImage imageNamed:(self.model.contentBricks.integerValue > 0 ? @"brick_sel" : @"brick_nor")] forState:UIControlStateNormal];
    curY += 30;

    [_bottomView setY:curY];
}

#pragma mark - collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.brickContentAttachmentList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *attachmentArray = self.model.brickContentAttachmentList;
    if (attachmentArray.count == 1) { //单张图片
        BrickPhotoSingleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_BrickPhotoSingleCell forIndexPath:indexPath];
        cell.attachmentModel = attachmentArray[indexPath.row];
        cell.refreshCellBlock = ^(){
            if (self.refreshCellBlock) {
                self.refreshCellBlock();
            }
        };
        cell.photoImgView.tag = indexPath.row + 1000;
        return cell;
    }else { //多张图片
        BrickPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier_BrickPhotoCell forIndexPath:indexPath];
        cell.attachmentModel = attachmentArray[indexPath.row];
        cell.photoImgView.tag = indexPath.row + 100;
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *attachmentArray = self.model.brickContentAttachmentList;
    CGSize size;
    if (attachmentArray.count == 1) {
        size = [BrickPhotoSingleCell cellHeithWithAttachment:attachmentArray.firstObject];
    }else {
        size = [BrickPhotoCell cellHeithWithAttachment:attachmentArray.firstObject];
    }
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    NSArray *attachmentArray = self.model.brickContentAttachmentList;
    UIEdgeInsets edgeInsets;
    if (attachmentArray.count == 1) {
        CGSize size = [BrickPhotoSingleCell cellHeithWithAttachment:attachmentArray.firstObject];
        edgeInsets = UIEdgeInsetsMake(0, 0, 0, kBrickPhotoCellWidth_One - size.width);
    }else {
        edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return edgeInsets;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 4.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *photos = [NSMutableArray array];
    NSInteger count = self.model.brickContentAttachmentList.count;
    for (int i = 0; i < count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        BMAttachment *attachment = self.model.brickContentAttachmentList[i];
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kImageUrl,attachment.attachmentPath]];
        [photos addObject:photo];
    }
    MJPhotoBrowser *photoBrowser = [[MJPhotoBrowser alloc] init];
    photoBrowser.currentPhotoIndex = indexPath.row;
    photoBrowser.photos = photos;
    [photoBrowser show];
}

#pragma mark - Btn Action
- (void)operationAction:(UIButton *)button {
    if (self.pushDetailBlock) {
        self.pushDetailBlock();;
    }
}

#pragma mark - cellHeight
+ (CGFloat)cellHeightWithModel:(BMContent *)contentModel {
    
    CGFloat height = 60;
    height += [contentModel.contentTitle getHeightWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreen_Width - 20, CGFLOAT_MAX)] + 10;
    height += 30 + 3;
    
    CGFloat collectionViewHeight = 0;
    NSArray *attachmentArray = contentModel.brickContentAttachmentList;
    if (attachmentArray.count == 1) {
        collectionViewHeight = [BrickPhotoSingleCell cellHeithWithAttachment:attachmentArray.firstObject].height;
    }else {
        collectionViewHeight = [BrickPhotoCell cellHeithWithAttachment:attachmentArray.firstObject].height * ceilf((float)attachmentArray.count/3);
    }
    height += collectionViewHeight + 20 + 16;
    return height;
}

@end
