//
//  BrickManAPIManager.m
//  BrickMan
//
//  Created by TZ on 16/7/19.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BrickManAPIManager.h"
#import "BrickManNetClient.h"
#import "BMCommentList.h"
#import "Mine_BrickModel.h"
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

#pragma mark - 首页内容
- (void)requestContentListWithObj:(BMContentList *)contentList andBlock:(void(^)(id data, NSError *error))block { //获取内容列表
    contentList.isLoading = YES;
    [[BrickManNetClient sharedJsonClient] requestJsonDataWithPath:@"/content/list_content.json" withParams:[contentList getContentListParams] withMethodType:Get andBlock:^(id data, NSError *error) {
        contentList.isLoading = NO;
        if (data) {
            BMContentList *model = [BMContentList yy_modelWithJSON:data];
            block(model, nil);
        }else {
            block(nil,error);
        }
    }];
}

//TODO :
- (void)requestDetailContentWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block { //获取内容详情
    
}

- (void)requestOperContentWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block { //送鲜花、拍砖、举报
    [[BrickManNetClient sharedJsonClient] requestJsonDataWithPath:@"/content/oper_content.do" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            block(data,nil);
        }else {
            block(nil,error);
        }
    }];
}

#pragma mark - 评论
- (void)requestCommentListWithObj:(BMCommentList *)commentList andBlock:(void(^)(id data, NSError *error))block { //获取评论列表
    commentList.isLoading = YES;
    [[BrickManNetClient sharedJsonClient] requestJsonDataWithPath:@"/comment/list_comments.json" withParams:[commentList getCommentListParams] withMethodType:Get andBlock:^(id data, NSError *error) {
        commentList.isLoading = NO;
        if (data) {
            BMCommentList *model = [BMCommentList yy_modelWithJSON:data];
            block(model, nil);
        }else {
            block(nil,error);
        }
    }];
}

- (void)requestAddCommentWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block { //评论
    [[BrickManNetClient sharedJsonClient] requestJsonDataWithPath:@"/comment/add_comment.do" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            block(data,nil);
        }else {
            block(nil,error);
        }
    }];
}

#pragma mark - 登录
- (void)requestAuthLoginWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block { //授权登录
    [[BrickManNetClient sharedJsonClient] requestJsonDataWithPath:@"/user/auth_login.json" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            NSDictionary *dic = data[@"body"];
            block(dic,nil);
        }else {
            block(nil,error);
        }
    }];
}

#pragma mark - 发布
- (void)requestAddContentWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block { //发布
    [[BrickManNetClient sharedJsonClient] requestJsonDataWithPath:@"/content/add_content.do" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            block(data,nil);
        }else {
            block(nil,error);
        }
    }];
}

#pragma mark - 我的
- (void)requestMyBrickFlowerWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block { //鲜花或砖头数前十名
    [[BrickManNetClient sharedJsonClient] requestJsonDataWithPath:@"/user/top_users.json" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[Mine_BrickModel class] json:data];
            block(array,nil);
        }else {
            block(nil,error);
        }
    }];
}

- (void)requestUserContentListWithObj:(BMContentList *)contentList andBlock:(void(^)(id data, NSError *error))block { //我的砖集
    contentList.isLoading = YES;
    [[BrickManNetClient sharedJsonClient] requestJsonDataWithPath:@"/user/user_content_list.do" withParams:[contentList getUserContentListParams] withMethodType:Get andBlock:^(id data, NSError *error) {
        contentList.isLoading = NO;
        if (data) {
            BMContentList *model = [BMContentList yy_modelWithJSON:data];
            block(model, nil);
        }else {
            block(nil,error);
        }
    }];
}

- (void)requestUpdateUserInfoWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block { //修改用户信息
    [[BrickManNetClient sharedJsonClient] requestJsonDataWithPath:@"/user/update_user_info.do" withParams:params withMethodType:Post andBlock:^(id data, NSError *error) {
        if (data) {
            block(data,nil);
        }else {
            block(nil,error);
        }
    }];
}

- (void)requestUserInfoWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block { //请求用户信息
    [[BrickManNetClient sharedJsonClient] requestJsonDataWithPath:@"/user/get_user_info.do" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            block(data,nil);
        }else {
            block(nil,error);
        }
    }];
}


#pragma mark - Refresh Token
- (void)requestTokenWithParams:(id)params andBlock:(void (^)(id, NSError *))block {
    [[BrickManNetClient sharedJsonClient] requestJsonDataWithPath:@"/user/get_token.json" withParams:params withMethodType:Get andBlock:^(id data, NSError *error) {
        if (data) {
            block(data,nil);
        }else {
            block(nil,error);
        }
    }];
}


//上传文件
- (void)uploadFileWithImages:(NSArray *)images
               doneBlock:(void (^)(NSString *imagePath, NSError *error))block
           progerssBlock:(void (^)(CGFloat progressValue))progress {
    [[BrickManNetClient sharedJsonClient] uploadImages:images WithPath:@"/upload/upload_file.do" successBlock:^(NSURLSessionDataTask *task, id responseObject) {
        if (responseObject) {
            NSString *result = responseObject[@"body"];
            block(result,nil);
        }
    } failureBlock:^(NSURLSessionDataTask *task, NSError *error) {
        block(nil, error);
    } progerssBlock:^(CGFloat progressValue) {
//        progress(progressValue);
    }];
}

@end
