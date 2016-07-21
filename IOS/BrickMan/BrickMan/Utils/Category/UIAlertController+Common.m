//
//  UIAlertController+Common.m
//  BrickMan
//
//  Created by TobyoTenma on 7/21/16.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import "UIAlertController+Common.h"

@implementation UIAlertController (Common)

+ (instancetype)errorAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"错误" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *comfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:comfirm];
    return alert;
}

@end
