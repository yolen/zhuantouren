//
//  UIView+Common.m
//  BrickMan
//
//  Created by TobyoTenma on 11/11/2016.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import "UIView+Common.h"
#import <objc/runtime.h>

static const void *kTAP_ACTION;

@interface UIView () {
//    BMTapAction _tapAction;
}
@property (nonatomic, copy) BMTapAction tapAction;

@end

@implementation UIView (Common)


- (void)tta_addTapGestureWithTarget:(nullable id)aTarget action:(BMTapAction)anAction {
    self.tapAction = anAction;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:aTarget action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}









#pragma mark - Actions
- (void)tap:(UITapGestureRecognizer *)tap {
    if (self.tapAction) {
        self.tapAction(tap);
    }
}

#pragma mark - Getter && Setter
- (BMTapAction)tapAction {
    return objc_getAssociatedObject(self, &kTAP_ACTION);
}

- (void)setTapAction:(BMTapAction)tapAction {
    objc_setAssociatedObject(self, &kTAP_ACTION, tapAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
