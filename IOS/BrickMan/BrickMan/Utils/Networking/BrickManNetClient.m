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
    //对params做处理
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    NSString *randomString = [NSString stringWithFormat:@"1231231263781"];
    [dic setObject:randomString forKey:@"rn"];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    NSString *date =  [formatter stringFromDate:[NSDate date]];
    NSString *timeString = [[NSString alloc] initWithFormat:@"%@", date];
    [dic setObject:timeString forKey:@"ts"];
    
    NSString *cVal = [self getMD5StringWithParams:dic];
    [dic setObject:cVal forKey:@"cVal"];
    DebugLog(@"request:%@\npath:%@:\nparams:%@", kNetworkMethodName[method], aPath, dic);
    //发起请求
    switch (method) {
        case Get:{
            [self GET:aPath parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            [self POST:aPath parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            [self PUT:aPath parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            [self DELETE:aPath parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

- (NSString *)getMD5StringWithParams:(NSMutableDictionary *)params {
    NSArray *allValues = [params allValues];
    NSArray * sortlValues = [allValues sortedArrayUsingFunction:mycompare context:NULL];
    
    NSString * appendingString = @"";
    for (NSString * value in sortlValues) {
        NSString *string = [NSString stringWithFormat:@"%@,",value];
        appendingString = [appendingString stringByAppendingString:string];
    }
    //去除最后一个','
    appendingString = [appendingString substringToIndex:appendingString.length-1];
    appendingString = [appendingString md5Str];
    appendingString = [appendingString lowercaseString];
    appendingString = [appendingString stringByAppendingString:[NSString stringWithFormat:@".%@",@"53b4be63fac688e0"]];
    appendingString  = [appendingString md5Str];
    NSString *cVal = [appendingString lowercaseString];
    
    return cVal;
}

NSInteger mycompare(id a,id b, void * ctx) { //比较的规则（函数指针）
    NSString * x = (NSString *)a;
    NSString * y = (NSString *)b;
    return [x compare:y];//可以加一个负号改变顺序和倒叙
}


@end
