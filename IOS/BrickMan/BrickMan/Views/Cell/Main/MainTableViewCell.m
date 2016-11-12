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
#import "MSSBrowseModel.h"
#import "UICustomCollectionView.h"
#import "MSSBrowseNetworkViewController.h"
#import "NSDate+Common.h"
#import "UILabel+Common.h"

@interface MainTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UIImageView *iconImageView;
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
        
        if (!_iconImageView) {
            _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPaddingLeft, 10, 40, 40)];
            _iconImageView.layer.cornerRadius = _iconImageView.width/2;
            _iconImageView.layer.masksToBounds = YES;
            [self.contentView addSubview:_iconImageView];
        }
        if (!_nameLabel) {
            _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_iconImageView.right + 10, 15, 150, 20)];
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
            [_brickBtn setTitle:@"鲜花" forState:UIControlStateNormal];
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
    _nameLabel.text = self.model.user.userAlias ? self.model.user.userAlias : [BMUser getUserModel].userAlias;
    _timeLabel.text = [self.model.date stringDisplay_HHmm];
    [_contentLabel setLongString:self.model.contentTitle withFitWidth:(kScreen_Width - 10)];
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
    [_commentBtn setTitle:(self.model.commentCount.integerValue > 0 ? [NSString stringWithFormat:@"评论 %@",self.model.commentCount] : @"评论") forState:UIControlStateNormal];
    [_commentBtn setImage:[UIImage imageNamed:(self.model.commentCount.integerValue > 0 ? @"comment_sel" : @"commnet_nor")] forState:UIControlStateNormal];
    [_flowerBtn setY:curY];
    [_flowerBtn setTitle:(self.model.contentFlowors.integerValue > 0 ? [NSString stringWithFormat:@"鲜花 %@",self.model.contentFlowors] : @"鲜花") forState:UIControlStateNormal];
    [_flowerBtn setImage:[UIImage imageNamed:(self.model.contentFlowors.integerValue > 0 ? @"flower_sel" : @"flower_nor")] forState:UIControlStateNormal];
    [_shareBtn setY:curY];
    [_shareBtn setTitle:(self.model.contentShares.integerValue > 0 ? [NSString stringWithFormat:@"分享 %@",self.model.contentShares] : @"分享") forState:UIControlStateNormal];
    [_shareBtn setImage:[UIImage imageNamed:(self.model.contentShares.integerValue > 0 ? @"share_sel" : @"share_nor")] forState:UIControlStateNormal];
    [_brickBtn setY:curY];
    [_brickBtn setTitle:(self.model.contentBricks.integerValue > 0 ? [NSString stringWithFormat:@"拍砖 %@",self.model.contentBricks] : @"拍砖") forState:UIControlStateNormal];
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
    if (self.inputView) {
        [self.inputView p_dismiss];
    }
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    NSArray *attachmentArray = self.model.brickContentAttachmentList;
    for (int i = 0; i < attachmentArray.count; i++) {
        BMAttachment *attachment = self.model.brickContentAttachmentList[i];
        NSString *imageStr = [NSString stringWithFormat:@"%@/%@",kImageUrl,attachment.attachmentPath];
        UIImageView *imageView;
        if (attachmentArray.count == 1) {
            imageView = [collectionView viewWithTag:i + 1000];
        }else {
            imageView = [collectionView viewWithTag:i + 100];
        }
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = imageStr;
        browseItem.smallImageView = imageView;
        [browseItemArray addObject:browseItem];
    }
    BrickPhotoCell *cell = (BrickPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    MSSBrowseNetworkViewController *bvc = [[MSSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:cell.photoImgView.tag - 100];
    if (self.inputView) {
        bvc.tapBlock = ^(){
            [self.inputView p_show];
        };
    }
    [bvc showBrowseViewController];
}

#pragma mark - Btn Action
- (void)operationAction:(UIButton *)button {
    if (self.isDetail == NO) { //首页直接跳转详情页
        if (self.pushDetailBlock) {
            self.pushDetailBlock();;
        }
        return;
    }
    if (![BMUser isLogin]) {
        if (self.pushLoginBlock) {
            self.pushLoginBlock();
        }
        return;
    }
    NSInteger tag = button.tag;
    BMAttachment *attachmentModel = self.model.brickContentAttachmentList[0];
    NSString *contentId = [attachmentModel.contentId stringValue];
    __weak typeof(self) weakSelf = self;
    
    if (button.selected == NO) {
        switch (tag) {
            case 100:{ //举报
                if (self.reportBlock) {
                    self.reportBlock();
                }
            }
                break;
            case 101:{ //评论
                if (self.commentBlock) {
                    self.commentBlock();
                }
            }
                break;
            case 102:{ //鲜花
                [[BrickManAPIManager shareInstance] requestOperContentWithParams:@{@"contentId" : contentId, @"operType" : @"1", @"userId" : [BMUser getUserModel].userId} andBlock:^(id data, NSError *error) {
                    if (data) {
                        [NSObject showSuccessMsg:@"送花成功"];
                        [weakSelf.flowerBtn setTitle:[NSString stringWithFormat:@"鲜花 %ld",(long)(weakSelf.model.contentFlowors.integerValue + 1)] forState:UIControlStateNormal];
                        [weakSelf.flowerBtn setImage:[UIImage imageNamed:@"flower_sel"] forState:UIControlStateNormal];
                    }
                }];
            }
                break;
            case 103:{ //分享
                if (self.shareBlock) {
                    self.shareBlock(self.model);
                }
            }
                break;
            case 104:{ //拍砖
                [[BrickManAPIManager shareInstance] requestOperContentWithParams:@{@"contentId" : contentId, @"operType" : @"2", @"userId" : [BMUser getUserModel].userId} andBlock:^(id data, NSError *error) {
                    if (data) {
                        [NSObject showSuccessMsg:@"拍砖成功"];
                        [weakSelf.brickBtn setTitle:[NSString stringWithFormat:@"拍砖 %ld",(long)(weakSelf.model.contentBricks.integerValue + 1)] forState:UIControlStateNormal];
                        [weakSelf.brickBtn setImage:[UIImage imageNamed:@"brick_sel"] forState:UIControlStateNormal];
                    }
                }];
            }
            default:
                break;
        }
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
