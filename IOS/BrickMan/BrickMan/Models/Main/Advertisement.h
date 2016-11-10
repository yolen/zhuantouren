//
//  Advertisement.h
//  BrickMan
//
//  Created by TZ on 16/9/2.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Advertisement : NSObject

@property (strong, nonatomic) NSNumber *advertisementId, *advertisementStatus, *advertisementType;
@property (strong, nonatomic) NSString *advertisementTitle, *advertisementUrl;

@end
