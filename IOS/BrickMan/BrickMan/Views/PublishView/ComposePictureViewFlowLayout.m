//
//  ComposePictureViewFlowLayout.m
//  BrickMan
//
//  Created by TobyoTenma on 7/22/16.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import "ComposePictureViewFlowLayout.h"

#define PICTURE_MARGIN 15
#define PICTURE_COL_NUM 3
#define PICTURE_WIDTH (kScreen_Width - (PICTURE_COL_NUM + 1) * PICTURE_MARGIN) / PICTURE_COL_NUM

@implementation ComposePictureViewFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 10;
    self.itemSize = CGSizeMake(PICTURE_WIDTH, PICTURE_WIDTH);

}

@end
