//
//  ComposePictureCell.h
//  BrickMan
//
//  Created by TobyoTenma on 7/22/16.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ComposePictureCell;

@protocol ComposePictureCellDelegate <NSObject>

-(void)composePictureCellAddPicture:(ComposePictureCell *)composePictureCell;
-(void)composePictureCellDeletePicture:(ComposePictureCell *)composePictureCell;

@end



@interface ComposePictureCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id<ComposePictureCellDelegate> composePictureCellDelegate;

@end
