//
//  BMCommentList.m
//  BrickMan
//
//  Created by TZ on 16/8/25.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BMCommentList.h"

@implementation BMCommentList

- (instancetype)init {
    if (self = [super init]) {
        _canLoadMore = YES;
        _isLoading = _willLoadMore = NO;
        
        _pageNo = [NSNumber numberWithInteger:1];
    }
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [BMComment class]};
}

- (NSDictionary *)getCommentListParams {
    NSInteger page = self.willLoadMore ? self.page.pageNo.integerValue + 1 : 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:page]] forKey:@"pageNo"];
    [params setObject:kDefaultPageSize forKey:@"pageSize"];
    [params setObject:self.contentId forKey:@"contentId"];
    
    return params;
}

- (void)configWithData:(BMCommentList *)model {
    if (model.data.count == 0) {
        return;
    }
    if (_willLoadMore) {
        [self.data addObjectsFromArray:model.data];
    }else {
        self.data = [NSMutableArray arrayWithArray:model.data];
    }
    self.page = model.page;
    _canLoadMore = model.page.pageNo.integerValue < model.page.totalRecords.integerValue;
}

@end
