//
//  DetailBrickViewController.h
//  BrickMan
//
//  Created by TZ on 16/7/21.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BaseViewController.h"
#import "BMContent.h"

@interface DetailBrickViewController : BaseViewController
@property (nonatomic, assign, getter=isComeFromeGallery) BOOL comeFromGallery;

@property (strong, nonatomic) BMContent *model;

@end

