//
//  BMUser.h
//  BrickMan
//
//  Created by TZ on 16/8/18.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMUser : NSObject

@property (strong, nonatomic) NSString *motto, *plat, *platId, *token, *userAlias, *userHead, *userId, *userName, *userPhone, *userSex, *userSexStr, *userStatus;

#pragma mark - user
+ (void)saveUserInfo:(NSDictionary *)data;
+ (BMUser *)getUserModel;
+ (void)removeUserInfo;
+ (BOOL)isLogin;

@end
