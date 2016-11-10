//
//  BrickManAPIManager.h
//  BrickMan
//
//  Created by TZ on 16/7/19.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMContentList.h"

@interface BrickManAPIManager : NSObject

+ (id)shareInstance;

//首页内容
- (void)requestContentListWithObj:(BMContentList *)contentList andBlock:(void(^)(id data, NSError *error))block;
- (void)requestDetailContentWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block;
- (void)requestOperContentWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block;
- (void)requestAdvertisementWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block;
- (void)requestAddShareCountWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block;
- (void)requestContentByCommentWithObj:(BMContentList *)contentList andBlock:(void(^)(id data, NSError *error))block;

//评论
- (void)requestCommentListWithObj:(id)contentList andBlock:(void(^)(id data, NSError *error))block;
- (void)requestAddCommentWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block;

//login
- (void)requestAuthLoginWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block;
- (void)requestLoginWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block;
- (void)requestRegisterWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block;

//发布
- (void)requestAddContentWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block;

//我的
- (void)requestMyBrickFlowerWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block;
- (void)requestUserContentListWithObj:(BMContentList *)contentList andBlock:(void(^)(id data, NSError *error))block;
- (void)requestUpdateUserInfoWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block;
- (void)requestUserInfoWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block;

//刷新token
- (void)requestTokenWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block;

- (void)uploadFileWithImages:(NSArray *)images
                   doneBlock:(void (^)(NSString *imagePath, NSError *error))block
               progerssBlock:(void (^)(CGFloat progressValue))progress;
@end
