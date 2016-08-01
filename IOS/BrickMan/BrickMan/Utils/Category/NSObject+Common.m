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
        if ([error.userInfo objectForKey:@""]) {
            
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


@end
