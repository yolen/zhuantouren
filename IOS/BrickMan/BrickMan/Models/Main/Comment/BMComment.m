//
//  BMComment.m
//  BrickMan
//
//  Created by TZ on 16/8/25.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BMComment.h"

@implementation BMComment

- (void)setCreatedTime:(NSNumber *)createdTime {
    NSTimeInterval timeSince1970TimeInterval = createdTime.doubleValue/1000;
    self.date = [NSDate dateWithTimeIntervalSince1970:timeSince1970TimeInterval];
}



@end
