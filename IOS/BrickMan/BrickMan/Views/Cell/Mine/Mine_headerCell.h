//
//  Mine_headerCell.h
//  BrickMan
//
//  Created by TZ on 16/7/19.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kCellIdentifier_Mine_headerCell @"Mine_headerCell"
#import <UIKit/UIKit.h>

@interface Mine_headerCell : UITableViewCell

- (void)setUserIcon:(NSString *)iconStr nameTitle:(NSString *)nameStr subTitle:(NSString *)subTitleStr;

+ (CGFloat)cellHeight;
@end
