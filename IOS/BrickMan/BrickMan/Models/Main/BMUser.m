//
//  BMUser.m
//  BrickMan
//
//  Created by TZ on 16/8/18.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BMUser.h"

#define kUserInfo @"UserInfo"

@implementation BMUser

#pragma mark - user
+ (void)saveUserInfo:(NSDictionary *)data {
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:data];
    NSArray *keys = [data allKeys];
    for (NSString *key in keys) {
        if ([data[key] isKindOfClass:[NSNull class]]) {
            [dataDic removeObjectForKey:key];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:dataDic forKey:kUserInfo];
}

+ (NSDictionary *)getUserInfo {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
}

+ (BOOL)isLogin {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
    return userInfo ? YES : NO;
}

+ (void)removeUserInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserInfo];
}


@end
