//
//  NSDate+Common.m
//  BrickMan
//
//  Created by TZ on 16/8/18.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "NSDate+Common.h"
#import "NSDate+Helper.h"

@implementation NSDate (Common)

- (NSString *)stringDisplay_HHmm{
    NSString *displayStr = @"";
    if ([self year] != [[NSDate date] year]) {
        displayStr = [self stringWithFormat:@"yy/MM/dd HH:mm"];
    }else if ([self leftDayCount] != 0){
        displayStr = [self stringWithFormat:@"MM/dd HH:mm"];
    }else if ([self hoursAgo] > 0){
        displayStr = [self stringWithFormat:@"今天 HH:mm"];
    }else if ([self minutesAgo] > 0){
        displayStr = [NSString stringWithFormat:@"%ld 分钟前", (long)[self minutesAgo]];
    }else if ([self secondsAgo] > 10){
        displayStr = [NSString stringWithFormat:@"%ld 秒前", (long)[self secondsAgo]];
    }else{
        displayStr = @"刚刚";
    }
    return displayStr;
}

- (NSInteger)secondsAgo{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitSecond)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    return [components second];
}
- (NSInteger)minutesAgo{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMinute)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    return [components minute];
}
- (NSInteger)hoursAgo{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    return [components hour];
}
- (NSInteger)monthsAgo{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    return [components month];
}

- (NSInteger)yearsAgo{
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    return [components year];
}

- (NSInteger)leftDayCount{
    NSDate *today = [NSDate dateFromString:[[NSDate date] stringWithFormat:@"yyyy-MM-dd"] withFormat:@"yyyy-MM-dd"];//时分清零
    NSDate *selfCopy = [NSDate dateFromString:[self stringWithFormat:@"yyyy-MM-dd"] withFormat:@"yyyy-MM-dd"];//时分清零
    
    NSCalendar *calendar = [[self class] sharedCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay)
                                               fromDate:today
                                                 toDate:selfCopy
                                                options:0];
    return [components day];
}


@end
