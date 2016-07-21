//
//  UIAlertController+Common.h
//  BrickMan
//
//  Created by TobyoTenma on 7/21/16.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Common)
/**
 *  错误提示框
 *
 *  @param message 错误提示信息
 *
 *  @return UIAlertController 实例
 */
+ (instancetype)errorAlertWithMessage:(NSString *)message;
@end
