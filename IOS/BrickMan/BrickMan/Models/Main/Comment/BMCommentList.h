//
//  BMCommentList.h
//  BrickMan
//
//  Created by TZ on 16/8/25.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMPage.h"
#import "BMComment.h"

@interface BMCommentList : NSObject

@property (assign, nonatomic) BOOL canLoadMore, willLoadMore, isLoading;
@property (strong, nonatomic) NSNumber *pageNo;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSString *contentId;
@property (strong, nonatomic) BMPage *page;

- (NSDictionary *)getCommentListParams;

- (void)configWithData:(BMCommentList *)model;

@end
