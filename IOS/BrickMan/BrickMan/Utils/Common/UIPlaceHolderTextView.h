//
//  UIPlaceHolderTextView.h
//  BrickMan
//
//  Created by TZ on 16/7/27.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
