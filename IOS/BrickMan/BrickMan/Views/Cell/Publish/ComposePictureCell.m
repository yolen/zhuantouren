//
//  ComposePictureCell.m
//  BrickMan
//
//  Created by TobyoTenma on 7/22/16.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import "ComposePictureCell.h"

@interface ComposePictureCell ()
/**
 *  添加图片 button,并显示图片
 */
@property (nonatomic, strong) UIButton *addPictureButton;
/**
 *  删除图片 button
 */
@property (nonatomic, strong) UIButton *deleteButton;

@end


@implementation ComposePictureCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI
- (void)setupUI {
    UIButton *addPictureButton = [[UIButton alloc] init];
    [addPictureButton addTarget:self
                         action:@selector (didClickAddPictureButton:)
               forControlEvents:UIControlEventTouchUpInside];
    [addPictureButton setBackgroundImage:[UIImage imageNamed:@"add_pic"]
                                forState:UIControlStateNormal];
    self.addPictureButton = addPictureButton;
    [self.contentView addSubview:addPictureButton];

    UIButton *deleteButton = [[UIButton alloc] init];
    [deleteButton addTarget:self
                     action:@selector (didClickDeleteButton:)
           forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"delete_image"]
                            forState:UIControlStateNormal];
    self.deleteButton = deleteButton;
    [self.contentView addSubview:deleteButton];

    // 布局
    [addPictureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo (self.contentView).offset (10);
        make.bottom.right.equalTo (self.contentView).offset (-10);
    }];

    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo (self.contentView);
    }];
}

#pragma mark - Getter && Setter
- (void)setImage:(UIImage *)image {
    _image = image;
    if (image == nil) {
        [self.addPictureButton setBackgroundImage:[UIImage imageNamed:@"add_pic"] forState:UIControlStateNormal];
        self.deleteButton.hidden = YES;
    } else {
        [self.addPictureButton setBackgroundImage:image forState:UIControlStateNormal];
        self.deleteButton.hidden = NO;
    }
}

#pragma mark - Action
- (void)didClickAddPictureButton:(UIButton *)button {
    if ([self.composePictureCellDelegate respondsToSelector:@selector (composePictureCellAddPicture:)]) {
        [self.composePictureCellDelegate composePictureCellAddPicture:self];
    }
}

- (void)didClickDeleteButton:(UIButton *)button {
    if ([self.composePictureCellDelegate respondsToSelector:@selector (composePictureCellDeletePicture:)]) {
        [self.composePictureCellDelegate composePictureCellDeletePicture:self];
    }
}


@end
