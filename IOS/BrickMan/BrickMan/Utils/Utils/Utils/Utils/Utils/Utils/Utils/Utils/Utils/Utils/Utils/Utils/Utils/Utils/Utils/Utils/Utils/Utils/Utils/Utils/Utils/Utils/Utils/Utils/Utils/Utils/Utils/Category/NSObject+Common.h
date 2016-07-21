//
//  NSObject+Common.h
//  BrickMan
//
//  Created by TZ on 16/7/19.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Common)

#pragma mark - error 
+ (BOOL)showError:(NSError *)error;
- (id)handleResponse:(id)responseJSON autoShowError:(BOOL)autoShowError;

@end
