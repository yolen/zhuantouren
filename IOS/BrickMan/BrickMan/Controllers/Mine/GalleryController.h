//
//  GalleryController.h
//  BrickMan
//
//  Created by 段永瑞 on 16/7/22.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BaseViewController.h"

@interface GalleryController : BaseViewController
/** 用户名 */
@property (nonatomic, copy) NSString *userNickName;
/** 用户 id */
@property (nonatomic, copy) NSString *userID;

+ (instancetype)galleryControllerWithUserNickName:(NSString *)userNickName userID:(NSString *)userID;
- (instancetype)initWithUserNickName:(NSString *)userNickName userID:(NSString *)userID;
@end
