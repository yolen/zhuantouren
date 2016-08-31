//
//  UIView+Common.m
//  BrickMan
//
//  Created by TZ on 16/8/25.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "UIView+Common.h"

@implementation UIView (Common)

- (void)setSubScrollsToTop:(BOOL)scrollsToTop{
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)obj setScrollEnabled:scrollsToTop];
            *stop = YES;
        }
    }];
}

@end
