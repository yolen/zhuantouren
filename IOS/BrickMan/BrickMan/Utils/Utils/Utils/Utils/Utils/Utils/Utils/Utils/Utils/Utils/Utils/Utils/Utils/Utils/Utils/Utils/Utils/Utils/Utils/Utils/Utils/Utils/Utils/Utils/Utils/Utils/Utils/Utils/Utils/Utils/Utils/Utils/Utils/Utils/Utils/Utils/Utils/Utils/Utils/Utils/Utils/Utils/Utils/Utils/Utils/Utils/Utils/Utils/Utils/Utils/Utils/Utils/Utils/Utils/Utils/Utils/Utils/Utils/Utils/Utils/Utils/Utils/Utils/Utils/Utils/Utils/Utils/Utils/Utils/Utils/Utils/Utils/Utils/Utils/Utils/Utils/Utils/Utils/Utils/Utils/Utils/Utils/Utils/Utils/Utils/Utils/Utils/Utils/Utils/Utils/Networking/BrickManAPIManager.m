//
//  BrickManAPIManager.m
//  BrickMan
//
//  Created by TZ on 16/7/19.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BrickManAPIManager.h"
#import "BrickManNetClient.h"

@implementation BrickManAPIManager

+ (id)shareInstance {
    static BrickManAPIManager *share_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share_instance = [[BrickManAPIManager alloc] init];
    });
    return share_instance;
}

- (void)requestWithParams:(id)params andBlock:(void (^)(id, NSError *))block {
    [[BrickManAPIManager shareInstance] requestJsonDataWithPath:@"" withParams:nil withMethodType:Get andBlock:^(id data, NSError *error) {
        if (error) {
            block(nil,error);
        }else {
            block(data,error);
        }
    }];
}



@end
