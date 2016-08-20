//
//  BrickManAPIManager.m
//  BrickMan
//
//  Created by TZ on 16/7/19.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BrickManAPIManager.h"
#import "BrickManNetClient.h"
#define CustomErrorDomain @"com.zhuantouren.error"

@implementation BrickManAPIManager

+ (id)shareInstance {
    static BrickManAPIManager *share_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share_instance = [[BrickManAPIManager alloc] init];
    });
    return share_instance;
}

//获取内容列表
- (void)requestContentListWithObj:(BMContentListModel *)contentList andBlock:(void(^)(id data, NSError *error))block {
    contentList.isLoading = YES;
    [[BrickManNetClient sharedJsonClient] requestJsonDataWithPath:@"/content/list_content.json" withParams:[contentList getContentListParams] withMethodType:Get andBlock:^(id data, NSError *error) {
        contentList.isLoading = NO;
        if (data) {
            BMContentListModel *model = [BMContentListModel yy_modelWithJSON:data];
            block(model, nil);
        }else {
            block(nil,error);
        }
    }];
}

//获取内容详情
- (void)requestDetailContentWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block {
    
}

//送鲜花、拍砖、举报
- (void)requestOperContentWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block {
    [[BrickManNetClient sharedJsonClient] requestJsonDataWithPath:@"/content/oper_content.json" withParams:params withMethodType:Put andBlock:^(id data, NSError *error) {
        if (data) {
            block(data,nil);
        }else {
            block(nil,error);
        }
    }];
}

//授权登录
- (void)requestAuthLoginWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block {
    [[BrickManNetClient sharedJsonClient] requestJsonDataWithPath:@"/user/auth_login.json" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            NSDictionary *dic = data[@"body"];
            block(dic,nil);
        }else {
            block(nil,error);
        }
    }];
}

//我的鲜花
- (void)requestMyBrickFlowerWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block {
    [[BrickManNetClient sharedJsonClient] requestJsonDataWithPath:@"/user/top_users.json" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if (error) {
            block(nil,error);
        }else {
            block(data,nil);
        }
    }];
}

//我的砖集
- (void)requestUserContentListWithObj:(BMContentListModel *)contentList andBlock:(void(^)(id data, NSError *error))block {
    contentList.isLoading = YES;
    [[BrickManNetClient sharedJsonClient] requestJsonDataWithPath:@"/user/user_content_list.do" withParams:[contentList getUserContentListParams] withMethodType:Get andBlock:^(id data, NSError *error) {
        contentList.isLoading = NO;
        if (data) {
            BMContentListModel *model = [BMContentListModel yy_modelWithJSON:data];
            block(model, nil);
        }else {
            block(nil,error);
        }
    }];
}

//发布
- (void)requestAddContentWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block {
    [[BrickManNetClient sharedJsonClient] requestJsonDataWithPath:@"/content/add_content.do" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            block(data,nil);
        }else {
            block(nil,error);
        }
            
    }];
}

//上传文件
- (void)uploadFileWithImage:(UIImage *)image
               doneBlock:(void (^)(NSArray *imgPathArray, NSError *error))block
           progerssBlock:(void (^)(CGFloat progressValue))progress {
    [[BrickManNetClient sharedJsonClient] uploadImage:image WithPath:@"/upload/upload_file.do" successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            NSArray *array = [NSArray arrayWithObject:responseObject[@"body"]];
            block(array,nil);
        }
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil, error);
    } progerssBlock:^(CGFloat progressValue) {
        progress(progressValue);
    }];
}

@end
