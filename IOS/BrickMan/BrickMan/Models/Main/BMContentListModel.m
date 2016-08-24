//
//  BMContentListModel.m
//  BrickMan
//
//  Created by TZ on 16/8/18.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BMContentListModel.h"
#import "BMContentModel.h"

@implementation BMContentListModel

- (instancetype)init {
    if (self = [super init]) {
        _canLoadMore = YES;
        _isLoading = _willLoadMore = NO;
        
        _pageNo = [NSNumber numberWithInteger:1];
        _pageSize = [NSNumber numberWithInteger:10];
    }
    return self;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [BMContentModel class]};
}

+ (BMContentListModel *)contentListlWithType:(NSInteger)type {
    BMContentListModel *contentList = [[BMContentListModel alloc] init];
    contentList.orderType = [NSNumber numberWithInteger:type];
    return contentList;
}

- (NSDictionary *)getContentListParams {
    NSInteger page = self.willLoadMore ? self.page.pageNo.integerValue + 1 : 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:page]] forKey:@"pageNo"];
    [params setObject:[NSString stringWithFormat:@"%@",self.pageSize] forKey:@"pageSize"];
    [params setObject:[NSString stringWithFormat:@"%@",self.orderType] forKey:@"orderType"];
    return params;
}

- (NSDictionary *)getUserContentListParams {
    NSInteger page = self.willLoadMore ? self.page.pageNo.integerValue + 1 : 1;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    [params setObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:page]] forKey:@"pageNo"];
    [params setObject:[NSString stringWithFormat:@"%@",self.pageSize] forKey:@"pageSize"];
    [params setObject:[[BMUser getUserInfo] objectForKey:@"userId"] forKey:@"userId"];
    return params;
}

- (void)configWithData:(BMContentListModel *)model {
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
