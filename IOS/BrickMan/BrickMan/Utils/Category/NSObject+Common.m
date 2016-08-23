//
//  NSObject+Common.m
//  BrickMan
//
//  Created by TZ on 16/7/19.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "NSObject+Common.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation NSObject (Common)

+ (BOOL)showError:(NSError *)error{
    NSString *tipStr = [self tipFromError:error];
    [self showHudTipStr:tipStr];
    return YES;
}

- (NSString *)tipFromError:(NSError *)error{
    if (error && error.userInfo) {
        NSMutableString *tipStr = [[NSMutableString alloc] init];
        if ([error.userInfo objectForKey:@"body"]) {
            tipStr = error.userInfo[@"body"];
        }else{
            if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
                tipStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            }else{
                [tipStr appendFormat:@"ErrorCode%ld", (long)error.code];
            }
        }
        return tipStr;
    }
    return nil;
}

- (void)showHudTipStr:(NSString *)tipStr{
    if (tipStr && tipStr.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:15.0];
        hud.detailsLabelText = tipStr;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.0];
    }
}

//此处根据返回码做一些业务逻辑判断
-(id)handleResponse:(id)responseJSON autoShowError:(BOOL)autoShowError {
    NSError *error = nil;
    NSNumber *resultCode = [responseJSON valueForKeyPath:@"code"];
    if (resultCode.intValue == 101) { //正常返回
        
    }else if (resultCode.integerValue == 102 || resultCode.integerValue == 104) { //102:发生业务逻辑错误时返回 104:发生校验身份错误或者系统内部错误时返回
        error = [NSError errorWithDomain:kBaseUrl code:resultCode.intValue userInfo:responseJSON];
        if (autoShowError) {
            [NSObject showError:error];
        }
    }
    return error;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    return [[self class] modelWithDictionary:dictionary];
}

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    id obj = [[self alloc]init];
    [obj setValuesForKeysWithDictionary:dictionary];
    return obj;
}

#pragma mark - 
+ (void)saveLoginData:(NSDictionary *)data {
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:data];
    NSArray *keys = [data allKeys];
    for (NSString *key in keys) {
        if ([data[key] isKindOfClass:[NSNull class]]) {
            [dataDic removeObjectForKey:key];
        }
    }
    [dataDic writeToFile:[self loginDataPath] atomically:YES];
}

+ (NSMutableDictionary *)loginData {
    return [NSMutableDictionary dictionaryWithContentsOfFile:[self loginDataPath]];
}

+ (BOOL)isLogin {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self loginDataPath]];
}

+ (BOOL)removeLoginData {
    return [[NSFileManager defaultManager] removeItemAtPath:[self loginDataPath] error:nil];
}

+ (NSString *)loginDataPath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [documentPath stringByAppendingPathComponent:@"user.plist"];
}

@end
