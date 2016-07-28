//
//  BMUserInfo.h
//  BrickMan
//
//  Created by TobyoTenma on 7/28/16.
//  Copyright © 2016 BrickMan. All rights reserved.
//

/*
{
city = "\U671d\U9633";
figureurl = "http://qzapp.qlogo.cn/qzapp/1105575082/576D1ADF8847B7CD03204EC9C721DD7B/30";
"figureurl_1" = "http://qzapp.qlogo.cn/qzapp/1105575082/576D1ADF8847B7CD03204EC9C721DD7B/50";
"figureurl_2" = "http://qzapp.qlogo.cn/qzapp/1105575082/576D1ADF8847B7CD03204EC9C721DD7B/100";
"figureurl_qq_1" = "http://q.qlogo.cn/qqapp/1105575082/576D1ADF8847B7CD03204EC9C721DD7B/40";
"figureurl_qq_2" = "http://q.qlogo.cn/qqapp/1105575082/576D1ADF8847B7CD03204EC9C721DD7B/100";
gender = "\U7537";
"is_lost" = 0;
"is_yellow_vip" = 0;
"is_yellow_year_vip" = 0;
level = 0;
msg = "";
nickname = "\U7816\U5934\U4eba";
province = "\U5317\U4eac";
ret = 0;
vip = 0;
"yellow_vip_level" = 0;
}
*/

#import <Foundation/Foundation.h>

@interface BMUserInfo : NSObject
/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString *nickname;
/**
 *  用户性别
 */
@property (nonatomic, copy) NSString *gender;
/**
 *  小头像
 */
@property (nonatomic, copy) NSString *figureurl_qq_1;
/**
 *  大头像
 */
@property (nonatomic, copy) NSString *figureurl_qq_2;
/**
 *  用户授权登录后对该用户的唯一标识
 */
@property (nonatomic, copy) NSString *openId;
/**
 *  Access Token凭证，用于后续访问各开放接口
 */
@property (nonatomic, copy) NSString *accessToken;
/**
 *  Access Token的失效期
 */
@property (nonatomic, copy) NSDate *expirationDate;
/**
 *  用户登录状态
 */
@property (nonatomic, assign) BOOL isLogin;

/**
 *  用户信息单例
 *
 *  @return 返回一个用户单例实例
 */
+ (instancetype)sharedUserInfo;

/**
 *  将传进来的 字典 数据转换为 userInfo模型并保存到本地
 *
 *  @param userInfoJson 传递进来的 json 数据
 */
-(void)saveUserInfoWithDict:(NSDictionary *)userInfoDict;

/**
 *  从本地加载用户信息
 */
-(void)loadUserInfo;

@end
