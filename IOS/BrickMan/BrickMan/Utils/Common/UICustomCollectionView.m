//
//  UICustomCollectionView.m
//  BrickMan
//
//  Created by TZ on 16/9/5.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "UICustomCollectionView.h"

@implementation UICustomCollectionView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //当事件是传递给此View内部的子View时，让子View自己捕获事件，如果是传递给此View自己时，放弃事件捕获
    UIView* __tmpView = [super hitTest:point withEvent:event];
    if (__tmpView == self) {
        return nil;
    }
    return __tmpView;
}

@end
