//
//  CommentInputView.h
//  BrickMan
//
//  Created by TZ on 16/7/27.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@interface CommentInputView : UIView
@property (strong, nonatomic) UIPlaceHolderTextView *inputTextView;

+ (CommentInputView *)getInputView;
- (void)p_show;
- (void)p_dismiss;
@end
