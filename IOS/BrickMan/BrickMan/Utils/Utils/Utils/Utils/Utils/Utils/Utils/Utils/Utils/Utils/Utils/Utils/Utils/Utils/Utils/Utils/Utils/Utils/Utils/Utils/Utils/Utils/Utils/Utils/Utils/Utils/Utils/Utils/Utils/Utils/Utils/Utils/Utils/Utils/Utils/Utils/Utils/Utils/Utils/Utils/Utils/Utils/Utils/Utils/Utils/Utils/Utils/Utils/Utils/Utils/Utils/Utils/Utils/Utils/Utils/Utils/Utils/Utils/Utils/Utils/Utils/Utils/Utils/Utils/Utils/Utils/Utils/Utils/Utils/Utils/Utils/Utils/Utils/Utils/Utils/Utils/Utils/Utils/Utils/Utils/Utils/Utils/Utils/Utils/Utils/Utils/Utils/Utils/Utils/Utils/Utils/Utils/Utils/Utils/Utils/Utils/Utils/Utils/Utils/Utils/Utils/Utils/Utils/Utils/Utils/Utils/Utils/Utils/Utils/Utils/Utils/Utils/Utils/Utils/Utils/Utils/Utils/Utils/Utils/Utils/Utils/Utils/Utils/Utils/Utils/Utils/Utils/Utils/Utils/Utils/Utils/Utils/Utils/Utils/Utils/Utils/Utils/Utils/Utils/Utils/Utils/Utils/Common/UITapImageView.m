//
//  UITapImageView.m
//  BrickMan
//
//  Created by TZ on 16/7/21.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "UITapImageView.h"

@interface  UITapImageView ()
@property (nonatomic, copy) void(^tapAction)(id);
@end

@implementation UITapImageView

- (void)addTapBlock:(void(^)(id obj))tapAction {
    self.tapAction = tapAction;
    if (![self gestureRecognizers]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
}

- (void)tap{
    if (self.tapAction) {
        self.tapAction(self);
    }
}

@end
