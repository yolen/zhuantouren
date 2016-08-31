//
//  BMContent.h
//  BrickMan
//
//  Created by TZ on 16/8/18.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMUser.h"

@interface BMContent : NSObject

@property (strong, nonatomic) NSNumber *commentCount, *contentBricks, *contentFlowors, *contentReports, *contentShares, *id, *createdTime;
@property (strong, nonatomic) NSString *contentStatus, *contentTitle, *userId, *contentPlace;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) BMUser *user;
@property (strong, nonatomic) NSArray *brickContentAttachmentList;

@end


