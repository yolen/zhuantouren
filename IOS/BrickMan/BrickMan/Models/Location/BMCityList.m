//
//  BMCityList.m
//  BrickMan
//
//  Created by TobyoTenma on 8/9/16.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import "BMCityList.h"
#import "BMCity.h"
#import "YYModel.h"

@implementation BMCityList

/**
 *  返回所有省市列表
 */
+ (NSArray *)cityList {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    NSArray *dataArr = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSMutableArray *cityListM = [NSMutableArray arrayWithCapacity:dataArr.count];
    for (NSDictionary *dic in dataArr) {
        BMCityList *cityList = [self yy_modelWithDictionary:dic];
        [cityListM addObject:cityList];
    }
    return cityListM.copy;
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"elements": [BMCity class],
             };
}

@end
