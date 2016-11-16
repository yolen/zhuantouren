//
//  Notify.h
//  BrickMan
//
//  Created by TZ on 2016/11/15.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notify : NSObject

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSNumber *contentId;
@property (assign, nonatomic) BOOL isRead;

@end
