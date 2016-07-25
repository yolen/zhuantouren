//
//  MyLog.h
//  MyLog
//
//  Created by 张泽楠 on 15/11/19.
//  Copyright © 2015年 张泽楠. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define NSLog(format, ...) ([MyLog output:__FILE__ lineNumber:__LINE__ input:(format), ## __VA_ARGS__])
#else
#define NSLog(format, ...)
#endif

/**
 *  基准测试必须先extern申明
 *
 *  @param count  执行次数
 *  @param ^block 待执行代码块
 *
 *  @return 消耗时间(单位纳秒)
 */
#ifdef DEBUG

#else
#define dispatch_benchmark(a,b) -1
#endif

@interface MyLog : NSObject

+ (void)output:(const char*)fileName lineNumber:(int)lineNumber input:(NSString*)input, ...;

@end
