//
//  BMUser.m
//  BrickMan
//
//  Created by TZ on 16/8/18.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BMUser.h"
#import <YYModel/YYModel.h>

#define kUserInfo @"UserInfo"

@implementation BMUser

#pragma mark - user
+ (void)saveUserInfo:(NSDictionary *)data {
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:data];
    [[NSUserDefaults standardUserDefaults] setObject:dataDic forKey:kUserInfo];
}

+ (BMUser *)getUserModel {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
    return [BMUser yy_modelWithDictionary:userInfo];
}

+ (BOOL)isLogin {
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
    return userInfo ? YES : NO;
}

+ (void)removeUserInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserInfo];
}

@end
