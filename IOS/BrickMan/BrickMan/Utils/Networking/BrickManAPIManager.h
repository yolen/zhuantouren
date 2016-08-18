//
//  BrickManAPIManager.h
//  BrickMan
//
//  Created by TZ on 16/7/19.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMContentListModel.h"

@interface BrickManAPIManager : NSObject

+ (id)shareInstance;

- (void)requestContentListWithObj:(BMContentListModel *)contentList andBlock:(void(^)(id data, NSError *error))block;
- (void)requestDetailContentWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block;
- (void)requestOperContentWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block;
- (void)requestAuthLoginWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block;
- (void)requestMyBrickFlowerWithParams:(id)params andBlock:(void(^)(id data, NSError *error))block;
- (void)requestUserContentListWithObj:(BMContentListModel *)contentList andBlock:(void(^)(id data, NSError *error))block;
//上传文件
- (void)uploadFileWithImage:(UIImage *)image
                  doneBlock:(void (^)(NSString *imagePath, NSError *error))block
              progerssBlock:(void (^)(CGFloat progressValue))progress;
@end
