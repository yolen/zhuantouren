//
//  NotifyCell.h
//  BrickMan
//
//  Created by TZ on 2016/11/15.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kCellIdentifier_NotifyCell @"NotifyCell"
#import <UIKit/UIKit.h>

@interface NotifyCell : UITableViewCell

- (void)setContent:(NSString *)contentStr withIsRead:(BOOL)isRead;

@end
