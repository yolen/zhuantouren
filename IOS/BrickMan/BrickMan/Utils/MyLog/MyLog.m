//
//  MyLog.m
//  MyLog
//
//  Created by 张泽楠 on 15/11/19.
//  Copyright © 2015年 张泽楠. All rights reserved.
//

#import "MyLog.h"

@implementation MyLog
+ (void)output:(const char*)fileName
       lineNumber:(int)lineNumber
            input:(NSString*)input, ...{
    va_list argList;
    NSString *filePath, *formatStr;
    filePath = [[NSString alloc] initWithBytes:fileName
                                        length:strlen(fileName)
                                      encoding:NSUTF8StringEncoding];
    va_start(argList, input);
    formatStr = [[NSString alloc] initWithFormat:input
                                       arguments:argList];
    va_end(argList);
    
    printf("%s\n",[[NSString stringWithFormat:@"%@[%d] %@", [filePath lastPathComponent], lineNumber, formatStr] UTF8String]);
}
@end
