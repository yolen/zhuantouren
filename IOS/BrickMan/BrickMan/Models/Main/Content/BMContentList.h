//
//  BMContentList.h
//  BrickMan
//
//  Created by TZ on 16/8/18.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMPage.h"

@class BMUser;

@interface BMContentList : NSObject

@property (nonatomic, copy) NSString *userID;

@property (assign, nonatomic) BOOL canLoadMore, willLoadMore, isLoading;
@property (strong, nonatomic) NSNumber *pageNo, *orderType;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) BMPage *page;
/** 此条列表的发布人信息 */
@property (nonatomic, strong) BMUser *user;

+ (BMContentList *)contentListlWithType:(NSInteger)type;

- (NSDictionary *)getContentListParams;
- (NSDictionary *)getUserContentListParams;
- (NSDictionary *)getContentListParamsWithComment;

- (void)configWithData:(BMContentList *)model;

@end


