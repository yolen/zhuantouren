//
//  BMContentListModel.h
//  BrickMan
//
//  Created by TZ on 16/8/18.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMPage.h"

@interface BMContentListModel : NSObject

@property (assign, nonatomic) BOOL canLoadMore, willLoadMore, isLoading;
@property (strong, nonatomic) NSNumber *pageNo, *pageSize, *orderType;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) BMPage *page;

+ (BMContentListModel *)contentListlWithType:(NSInteger)type;

- (NSDictionary *)getContentListParams;
- (NSDictionary *)getUserContentListParams;

- (void)configWithData:(BMContentListModel *)model;

@end


