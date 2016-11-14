//
//  UIButton+Block.m
//  UtilsDemo
//
//  Created by TobyoTenma on 06/10/2016.
//  Copyright © 2016 TobyoTenma. All rights reserved.
//

#import "UIButton+Block.h"

static const void *kACTION;

@interface UIButton ()
/**
 button的点击事件Block
 */
@property (nonatomic, copy) void (^buttonAction)(UIButton *button);

@end

@implementation UIButton (Block)

+ (instancetype) tta_buttonWithTitle:(NSString *)title image:(UIImage *)image action:(void (^)(UIButton *button))action {
    return [[self alloc] initTta_ButtonWithTitle:title image:image action:action];
}

- (instancetype) initTta_ButtonWithTitle:(NSString *)title image:(UIImage *)image action:(void (^)(UIButton *button))action {
    if (self = [super init]) {
        self.buttonAction = action;
        [self setTitle:title forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateNormal];
        [self addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

+ (instancetype) tta_buttonWithTitle:(NSString *)title backgroundImage:(UIImage *)backgroundImage action:(void (^)(UIButton *button))action {
    return [[self alloc] initTta_ButtonWithTitle:title backgroundImage:backgroundImage action:action];
}

- (instancetype) initTta_ButtonWithTitle:(NSString *)title backgroundImage:(UIImage *)backgroundImage action:(void (^)(UIButton *button))action {
    if (self = [super init]) {
        self.buttonAction = action;
        [self setTitle:title forState:UIControlStateNormal];
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [self addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}








/**
 设置Button的点击事件的Block
 
 @param action 点击事件的Block
 */
- (void) setTTAButtonAction:(void (^)(UIButton *button))action {
    self.buttonAction = action;
    [self addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions
- (void) didClickButton:(id)sender {
    if (self.buttonAction) {
        self.buttonAction(self);
    }
}

#pragma mark - Getters && Setters

-(void)setButtonAction:(void (^)(UIButton *))buttonAction {
    objc_setAssociatedObject(self, &kACTION, buttonAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void (^)(UIButton *))buttonAction{
    return objc_getAssociatedObject(self, &kACTION);
}

@end
