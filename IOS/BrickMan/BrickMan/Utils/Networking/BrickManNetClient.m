//
//  BrickManNetClient.m
//  BrickMan
//
//  Created by TZ on 16/7/19.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BrickManNetClient.h"
NSString *const key = @"53b4be63fac688e0";

static NSInteger mycompare(id a,id b, void * ctx) { //比较的规则（函数指针）
    NSString * x = (NSString *)a;
    NSString * y = (NSString *)b;
    return [x compare:y];//可以加一个负号改变顺序和倒叙
}

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
//        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html",@"text/javascript", nil];
    }
    return self;
}

- (void)setToken:(NSString *)token {
    [self.requestSerializer setValue:token forHTTPHeaderField:@"token"];
}

- (void)requestJsonDataWithPath:(NSString *)path
                     withParams:(NSDictionary*)params
                 withMethodType:(NetworkMethod)method
                       andBlock:(void (^)(id data, NSError *error))block {
    [self requestJsonDataWithPath:path withParams:params withMethodType:method autoShowError:YES andBlock:block];
}

- (void)requestJsonDataWithPath:(NSString *)path withParams:(NSDictionary *)params withMethodType:(NetworkMethod)method autoShowError:(BOOL)autoShowError andBlock:(void (^)(id, NSError *))block {
    if (!path || path.length <= 0) {
        return;
    }
    
    //对params做处理
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    int rand = arc4random();
    NSString *randomString = [NSString stringWithFormat:@"%d",abs(rand)];
    [dic setObject:randomString forKey:@"rn"];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    NSString *date =  [formatter stringFromDate:[NSDate date]];
    NSString *timeString = [[NSString alloc] initWithFormat:@"%@", date];
    [dic setObject:timeString forKey:@"ts"];
    
    NSString *cVal = [self getMD5StringWithParams:dic];
    [dic setObject:cVal forKey:@"cVal"];
    DebugLog(@"request:%@ \nparams:%@", path, dic);
    
    //发起请求
    switch (method) {
        case Get:{
            [self GET:path parameters:dic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                DebugLog(@"\n===========response===========\n%@:\n%@", path, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (error) {
                    responseObject = [NSObject loadResponseWithPath:path];
                    block(responseObject,error);
                }else{
                    id result = [responseObject valueForKey:@"body"];
                    [NSObject saveResponseData:result toPath:path];
                    block(result, nil);
                }

            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                DebugLog(@"\n===========response===========\n%@:\n%@", path, error);
                !autoShowError || [NSObject showError:error];
                NSDictionary *responseObject = [NSObject loadResponseWithPath:path];
                block(responseObject, error);
            }];
            break;}
        case Post:{
            [self POST:path parameters:dic progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                DebugLog(@"\n===========response===========\n%@:\n%@", path, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (error) {
                    block(nil, error);
                }else{
                    block(responseObject, nil);
                }

            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                DebugLog(@"\n===========response===========\n%@:\n%@", path, error);
                !autoShowError || [NSObject showError:error];
                block(nil, error);
            }];
            break;}
        case Put:{
            [self PUT:path parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
                DebugLog(@"\n===========response===========\n%@:\n%@", path, responseObject);
                id error = [self handleResponse:responseObject autoShowError:autoShowError];
                if (error) {
                    block(nil, error);
                }else{
                    block(responseObject, nil);
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                DebugLog(@"\n===========response===========\n%@:\n%@", path, error);
                !autoShowError || [NSObject showError:error];
                block(nil, error);
            }];
            break;}
        default:
            break;
    }
}

- (void)uploadImages:(NSArray *)images WithPath:(NSString *)path
        successBlock:(void (^)(NSURLSessionDataTask *task, id responseObject))success
       failureBlock:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
      progerssBlock:(void (^)(CGFloat progressValue))progress {
    //对params做处理
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    int rand = arc4random();
    NSString *randomString = [NSString stringWithFormat:@"%d",abs(rand)];
    [dic setObject:randomString forKey:@"rn"];
    
    NSDateFormatter * formatter1 = [[NSDateFormatter alloc ] init];
    [formatter1 setDateFormat:@"YYYYMMddhhmmssSSS"];
    NSString *date =  [formatter1 stringFromDate:[NSDate date]];
    NSString *timeString = [[NSString alloc] initWithFormat:@"%@", date];
    [dic setObject:timeString forKey:@"ts"];
    
    NSString *cVal = [self getMD5StringWithParams:dic];
    [dic setObject:cVal forKey:@"cVal"];
    [dic setObject:[[BMUser getUserInfo] objectForKey:@"userId"] forKey:@"userId"];
    
    [self POST:path parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (UIImage *image in images) {
            NSData *data = UIImageJPEGRepresentation(image, 1.0);
            if ((float)data.length/1024 > 300) {
                data = UIImageJPEGRepresentation(image, 1024*300/(float)data.length);
            }
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", dateString];
            [formData appendPartWithFileData:data name:@"image" fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress *uploadProgress) {
        DebugLog(@"%@",progress);
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        DebugLog(@"Success: %@\n%@", task, responseObject);
        id error = [self handleResponse:responseObject autoShowError:YES];
        if (error && failure) {
            failure(task, error);
        }else{
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        DebugLog(@"Error: %@\n%@", task, error);
        if (failure) {
            failure(task, error);
        }

    }];
}

#pragma mark - Others
- (BOOL)checkoutJsonData:(id)data {
    NSString *cVal = [data objectForKey:@"cVal"];
    NSArray *list = [data objectForKey:@"body"];
    NSString *md5CombinStr = @"";
    if (list == nil || [list isKindOfClass:[NSNull class]]) {
        NSString *md5String = [[@"" md5Str] lowercaseString];
        NSString *combinStr = [md5String stringByAppendingString:[NSString stringWithFormat:@".%@",key]];
        md5CombinStr = [combinStr md5Str];
        md5CombinStr = [md5CombinStr lowercaseString];
    } else {
        NSString *string = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:list options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        NSLog(@"%@",string);
        NSString *md5String = [[string md5Str] lowercaseString];
        NSString *combinStr = [md5String stringByAppendingString:[NSString stringWithFormat:@".%@",key]];
        md5CombinStr = [combinStr md5Str];
        md5CombinStr = [md5CombinStr lowercaseString];
    }
    
    if ([md5CombinStr isEqualToString:cVal]) {
        return YES;
    }
    return NO;
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
    appendingString = [appendingString stringByAppendingString:[NSString stringWithFormat:@"%@",key]];
    appendingString  = [appendingString md5Str];
    NSString *cVal = [appendingString lowercaseString];
    
    return cVal;
}


@end
