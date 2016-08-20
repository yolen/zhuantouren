//
//  BrickManNetClient.h
//  BrickMan
//
//  Created by TZ on 16/7/19.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef enum {
    Get = 0,
    Post,
    Put,
    Delete
} NetworkMethod;

@interface BrickManNetClient : AFHTTPSessionManager

@property (strong, nonatomic) NSString *token;

+ (id)sharedJsonClient;

/**
 *  请求数据
 *
 *  @param aPath  url
 *  @param params 参数
 *  @param method 请求方式
 *  @param block  block回调
 */
- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(NetworkMethod)method
                       andBlock:(void (^)(id data, NSError *error))block;

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(NetworkMethod)method
                  autoShowError:(BOOL)autoShowError
                       andBlock:(void (^)(id data, NSError *error))block;

- (void)uploadImage:(UIImage *)image WithPath:(NSString *)path
       successBlock:(void (^)(NSURLSessionDataTask *task, id responseObject))success
       failureBlock:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
      progerssBlock:(void (^)(CGFloat progressValue))progress;

- (BOOL)checkoutJsonData:(id)data;

@end
