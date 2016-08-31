//
//  NSObject+Common.m
//  BrickMan
//
//  Created by TZ on 16/7/19.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "NSObject+Common.h"
#import <MBProgressHUD/MBProgressHUD.h>

#define kResponseCache_path  @"ResponseCache"

@implementation NSObject (Common)

+ (BOOL)showError:(NSError *)error{
    NSString *tipStr = [self tipFromError:error];
    [self showHudTipStr:tipStr];
    return YES;
}

+ (void)showSuccessMsg:(NSString *)success {
    MBProgressHUD *hud = [self createCustomeHud];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert_success_icon"]];
    hud.labelText = success;
    [hud hide:YES afterDelay:1];
}

+ (void)showErrorMsg:(NSString *)error {
    MBProgressHUD *hud = [self createCustomeHud];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alert_error_icon"]];
    hud.labelText = error;
    [hud hide:YES afterDelay:1];
}

+ (MBProgressHUD *)createCustomeHud {
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:window];
    hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    hud.mode = MBProgressHUDModeCustomView;
    [window addSubview:hud];
    [hud show:YES];
    
    return hud;
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

#pragma mark - 缓存
+ (void)saveResponseData:(NSDictionary *)data toPath:(NSString *)requestPath {
    if ([self createDirInCache:kResponseCache_path] && ![data isKindOfClass:[NSNull class]]) {
        NSString *abslutePath = [NSString stringWithFormat:@"%@/%@.plist", [self pathInCacheDirectory:kResponseCache_path], [requestPath md5Str]];
        [data writeToFile:abslutePath atomically:YES];
    }
}

+ (id)loadResponseWithPath:(NSString *)requestPath {
    NSString *abslutePath = [NSString stringWithFormat:@"%@/%@.plist", [self pathInCacheDirectory:kResponseCache_path], [requestPath md5Str]];
    return [NSMutableDictionary dictionaryWithContentsOfFile:abslutePath];
}

+ (NSString* )pathInCacheDirectory:(NSString *)fileName {
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths objectAtIndex:0];
    return [cachePath stringByAppendingPathComponent:fileName];
}

+ (BOOL) createDirInCache:(NSString *)dirName {
    NSString *dirPath = [self pathInCacheDirectory:dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
    BOOL isCreated = NO;
    if ( !(isDir == YES && existed == YES) )
    {
        isCreated = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (existed) {
        isCreated = YES;
    }
    return isCreated;
}



@end
