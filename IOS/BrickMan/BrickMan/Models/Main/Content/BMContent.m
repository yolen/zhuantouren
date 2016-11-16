//
//  BMContent.m
//  BrickMan
//
//  Created by TZ on 16/8/18.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BMContent.h"
#import "BMAttachment.h"
#import "BMComment.h"

@implementation BMContent

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"user":@"users"};
}

- (void)setCreatedTime:(NSNumber *)createdTime {
    NSTimeInterval timeSince1970TimeInterval = createdTime.doubleValue/1000;
    self.date = [NSDate dateWithTimeIntervalSince1970:timeSince1970TimeInterval];
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"brickContentAttachmentList" : [BMAttachment class],
             @"brickContentCommentList" : [BMComment class]};
}


@end
