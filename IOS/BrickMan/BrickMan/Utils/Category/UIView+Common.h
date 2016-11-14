//
//  UIView+Common.h
//  BrickMan
//
//  Created by TobyoTenma on 11/11/2016.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^_Nullable BMTapAction)(UITapGestureRecognizer  * _Nullable  tap);

@interface UIView (Common)
- (void)tta_addTapGestureWithTarget:(nullable id)aTarget action:(BMTapAction)action;
@end
