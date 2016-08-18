//
//  BrickManAPIManager.m
//  BrickMan
//
//  Created by TZ on 16/7/19.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BrickManAPIManager.h"
#import "BrickManNetClient.h"
#import <YYModel/YYModel.h>
#define CustomErrorDomain @"com.zhuantouren.error"
@implementation BrickManAPIManager

+ (id)shareInstance {
    static BrickManAPIManager *share_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share_instance = [[BrickManAPIManager alloc] init];
    });
    return share_instance;
}

- (void)requestWithParams:(id)params andBlock:(void (^)(id data, NSError *error))block {
    [[BrickManNetClient sharedJsonClient] requestJsonDataWithPath:@"/content/test.json" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if (error) {
            block(nil,error);
        }else {
            block(data,error);
        }
    }];
}

//获取内容列表
- (void)requestContentListWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block {
    NSDictionary *dic = @{@"pageNo" : @"1",
                          @"pageSize" : @"10",
                          @"orderType" : @"0"};
    [[BrickManNetClient sharedJsonClient] requestJsonDataWithPath:@"content/list_content.json" withParams:dic withMethodType:Get andBlock:^(id data, NSError *error) {
        if (error) {
            block(nil,error);
        }else {
            NSDictionary *list = [data objectForKey:@"body"];
            
            block(data,nil);
        }
    }];
}

//获取内容详情
- (void)requestDetailContentWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block {
    
}

- (void)requestMyBrickFlowerWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block {
    [[BrickManNetClient sharedJsonClient] requestJsonDataWithPath:@"/user/top_users.json" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if (error) {
            block(nil,error);
        }else {
//            if ([[BrickManNetClient sharedJsonClient] checkoutJsonData:data]) {
//                block(data,nil);
//            }
//            NSError *newError = [NSError errorWithDomain:CustomErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey:@"verify failed"}];
//            block(nil,newError);
            block(data,nil);
        }
    }];
}



@end
