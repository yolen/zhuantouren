//
//  BMContentModel.h
//  BrickMan
//
//  Created by TZ on 16/8/15.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMContentModel : NSObject

@property (strong, nonatomic) NSNumber *contentBricks, *contentFlowors, *contentReports, *contentShares, *createdTime, *id;
@property (strong, nonatomic) NSString *contentPlace, *contentStatus, *contentTitle, *contentType, *userId;

@end
