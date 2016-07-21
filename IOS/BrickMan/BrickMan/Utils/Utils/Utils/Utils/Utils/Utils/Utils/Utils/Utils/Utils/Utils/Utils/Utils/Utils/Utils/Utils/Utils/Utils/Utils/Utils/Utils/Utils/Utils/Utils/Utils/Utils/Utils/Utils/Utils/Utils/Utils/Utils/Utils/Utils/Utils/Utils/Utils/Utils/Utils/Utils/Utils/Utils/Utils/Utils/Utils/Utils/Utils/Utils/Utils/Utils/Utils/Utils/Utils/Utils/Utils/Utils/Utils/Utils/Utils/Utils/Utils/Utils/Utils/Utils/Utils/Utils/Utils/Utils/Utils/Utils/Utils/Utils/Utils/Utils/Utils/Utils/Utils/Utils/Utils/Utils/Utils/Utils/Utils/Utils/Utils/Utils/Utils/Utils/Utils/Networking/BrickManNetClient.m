//
//  BrickManNetClient.m
//  BrickMan
//
//  Created by TZ on 16/7/19.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BrickManNetClient.h"

#define kNetworkMethodName @[@"Get", @"Post", @"Put", @"Delete"]

@implementation BrickManNetClient

+ (id)sharedJsonClient {
    static BrickManNetClient *share_client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share_client = [[BrickManNetClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    });
    return share_client;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    if (self = [super initWithBaseURL:url]) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", nil];
        
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
        
        //SSL
        self.securityPolicy.allowInvalidCertificates = YES;
    }
    return self;
}

- (void)requestJsonDataWithPath:(NSString *)aPath
                     withParams:(NSDictionary*)params
                 withMethodType:(NetworkMethod)method
                       andBlock:(void (^)(id data, NSError *error))block {
    [self requestJsonDataWithPath:aPath withParams:params withMethodType:method autoShowError:YES andBlock:block];
}

- (void)requestJsonDataWithPath:(NSString *)aPath withParams:(NSDictionary *)params withMethodType:(NetworkMethod)method autoShowError:(BOOL)autoShowError andBlock:(void (^)(id, NSError *))block {
    if (!aPath || aPath.length <= 0) {
        return;
    }
    //log请求数据
    DebugLog(@"request:%@\npath:%@:\nparams:%@", kNetworkMethodName[method], aPath, params);
    
    //发起请求
    switch (method) {
        case Get:{
            [self GET:aPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (error) {
                    block(nil,error);
                }else{
                    block(responseObject, nil);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                !autoShowError || [NSObject showError:error];
                block(nil, error);
            }];
            break;}
        case Post:{
            [self POST:aPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (error) {
                    block(nil, error);
                }else{
                    block(responseObject, nil);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                !autoShowError || [NSObject showError:error];
                block(nil, error);
            }];
            break;}
        case Put:{
            [self PUT:aPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (error) {
                    block(nil, error);
                }else{
                    block(responseObject, nil);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                !autoShowError || [NSObject showError:error];
                block(nil, error);
            }];
            break;}
        case Delete:{
            [self DELETE:aPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (error) {
                    block(nil, error);
                }else{
                    block(responseObject, nil);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                DebugLog(@"\n===========response===========\n%@:\n%@", aPath, error);
                !autoShowError || [NSObject showError:error];
                block(nil, error);
            }];}
        default:
            break;
    }
    
}


@end
