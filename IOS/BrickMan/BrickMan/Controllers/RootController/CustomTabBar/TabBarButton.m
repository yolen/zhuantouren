//
//  TabBarButton.m
//  BrickMan
//
//  Created by TZ on 2016/11/14.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kImageRatio 0.8
#import "TabBarButton.h"

@implementation TabBarButton

-(CGRect) imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 5, contentRect.size.width, contentRect.size.height*kImageRatio - 10);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, contentRect.size.height*kImageRatio, contentRect.size.width, contentRect.size.height-contentRect.size.height*kImageRatio);
}

@end
