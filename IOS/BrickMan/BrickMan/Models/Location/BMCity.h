//
//  BMCity.h
//  BrickMan
//
//  Created by TobyoTenma on 8/8/16.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BMCounty;

@interface BMCity : NSObject
/**
 *  城市名
 */
@property (nonatomic, copy) NSString *name;
/**
 *  城市 id
 */
@property (nonatomic, copy) NSString *id;
/**
 *  英文名
 */
@property (nonatomic, copy) NSString *en;
/**
 *  搜索列表
 */
@property (nonatomic, strong) NSArray <NSString *> *s;

@end
