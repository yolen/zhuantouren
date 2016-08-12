//
//  FlowerAndBrickModel.h
//  BrickMan
//
//  Created by 段永瑞 on 16/7/26.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mine_BrickModel : NSObject
/**
 *  砖头数或鲜花数排名
 */
@property (nonatomic, copy) NSString *ranking;
/**
 *  头像路径
 */
@property (nonatomic, copy) NSString *headPath;
/**
 *  用户昵称
 */
@property (nonatomic, copy) NSString *nickname;
/**
 *  等级
 */
@property (nonatomic, copy) NSString *grade;
/**
 *  砖头数
 */
@property (nonatomic, copy) NSString *numberOfBrick;
/**
 *  鲜花数
 */
@property (nonatomic, copy) NSString *numberOfFlower;

@end
