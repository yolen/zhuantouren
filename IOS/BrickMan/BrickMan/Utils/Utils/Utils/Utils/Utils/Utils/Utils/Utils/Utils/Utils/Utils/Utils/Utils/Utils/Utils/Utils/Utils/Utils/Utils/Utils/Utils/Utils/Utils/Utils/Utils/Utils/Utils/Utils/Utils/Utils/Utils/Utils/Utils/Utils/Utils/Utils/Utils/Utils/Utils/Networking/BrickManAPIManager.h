//
//  BrickManAPIManager.h
//  BrickMan
//
//  Created by TZ on 16/7/19.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrickManAPIManager : NSObject

+ (id)shareInstance;
- (void)requestWithParams:(id)params andBlock:(void (^)(id, NSError *))block;

@end
