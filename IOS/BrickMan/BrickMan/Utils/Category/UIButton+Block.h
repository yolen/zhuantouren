//
//  UIButton+Block.h
//  UtilsDemo
//
//  Created by TobyoTenma on 06/10/2016.
//  Copyright © 2016 TobyoTenma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Block)

+ (instancetype) tta_buttonWithTitle:(NSString *)title image:(UIImage *)image action:(void (^)(UIButton *button))action;
- (instancetype) initTta_ButtonWithTitle:(NSString *)title image:(UIImage *)image action:(void (^)(UIButton *button))action;

+ (instancetype) tta_buttonWithTitle:(NSString *)title backgroundImage:(UIImage *)backgroundImage action:(void (^)(UIButton *button))action;
- (instancetype) initTta_ButtonWithTitle:(NSString *)title backgroundImage:(UIImage *)backgroundImage action:(void (^)(UIButton *button))action;

/**
 设置Button的点击事件的Block

 @param action 点击事件的Block
 */
- (void) setTTAButtonAction:(void (^)(UIButton *button))action;

@end
