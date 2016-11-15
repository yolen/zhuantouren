//
//  Mine_titleCell.h
//  BrickMan
//
//  Created by TZ on 16/7/19.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kCellIdentifier_Mine_titleCell @"Mine_titleCell"
#import <UIKit/UIKit.h>

@interface Mine_titleCell : UITableViewCell

@property (strong, nonatomic) NSString *content;

- (void)setIconImage:(NSString *)imageStr withTitle:(NSString *)title;
+ (CGFloat)cellHeight;
@end
