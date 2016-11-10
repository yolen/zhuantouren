//
//  StartImageManager.h
//  BrickMan
//
//  Created by TZ on 16/9/1.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StartImage;

@interface StartImageManager : NSObject

+ (instancetype)sharedInstance;

- (StartImage *)randomImage;

@end

@interface StartImage : NSObject
@property (strong, nonatomic) NSNumber *advertisementId, *advertisementStatus, *advertisementType;
@property (strong, nonatomic) NSString *advertisementTitle, *advertisementUrl, *pathDisk, *fileName;

- (UIImage *)image;
- (void)startDownloadImage;

@end
