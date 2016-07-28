//
//  BMUserInfo.m
//  BrickMan
//
//  Created by TobyoTenma on 7/28/16.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import "BMUserInfo.h"

static NSString *userInfo = @"userInfo";

@implementation BMUserInfo
/**
 *  用户信息单例
 *
 *  @return 返回一个用户单例实例
 */
+ (instancetype)sharedUserInfo {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(instancetype)init{
    if (self = [super init]) {
        [self loadUserInfo];
    }
    return self;
}

/**
 *  将传进来的 字典 数据转换为 userInfo模型并保存到本地
 *
 *  @param userInfoJson 传递进来的 json 数据
 */
- (void)saveUserInfoWithDict:(NSDictionary *)userInfoDict {
    // 将字典转为模型
    [[BMUserInfo sharedUserInfo] setValuesForKeysWithDictionary:userInfoDict];

    // 将模型转为字典,再保存
    NSDictionary *userInfoNew = [self dictionaryWithValuesForKeys:@[@"nickname", @"gender", @"figureurl_qq_1", @"figureurl_qq_2", @"openId", @"accessToken", @"expirationDate"]];
    // 保存数据
    [[NSUserDefaults standardUserDefaults] setValue:userInfoNew forKey:userInfo];
}
/**
 *  从本地加载用户数据
 */
-(void)loadUserInfo {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:userInfo];
    [self setValuesForKeysWithDictionary:dic];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

#pragma mark - Getter && Setter
-(BOOL)isLogin{
    return _accessToken != nil;
}


@end
