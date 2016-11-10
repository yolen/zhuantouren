//
//  BMStartView.h
//  BrickMan
//
//  Created by TZ on 16/9/1.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMStartView : UIView

+ (instancetype)sharedInstance;

- (void)startAnimationWithCompletionBlock:(void(^)())completionHandler;
@end
