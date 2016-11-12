//
//  UINavigationController+Common.h
//  BrickMan
//
//  Created by TobyoTenma on 11/11/2016.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Common)

/// 自定义全屏拖拽返回手势
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *tta_popGestureRecognizer;

@end
