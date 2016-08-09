//
//  BMCityList.h
//  BrickMan
//
//  Created by TobyoTenma on 8/9/16.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BMCity;

@interface BMCityList : NSObject
/**
 *  字母标签
 */
@property (nonatomic, copy) NSString *title;
/**
 *  所有元素列表
 */
@property (nonatomic, strong) NSArray <BMCity *> *elements;
/**
 *  返回所有省市列表
 */
+ (NSArray *)cityList;


@end
