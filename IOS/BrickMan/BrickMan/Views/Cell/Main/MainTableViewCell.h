//
//  MainTableViewCell.h
//  BrickMan
//
//  Created by TZ on 16/7/21.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kCellIdentifier_MainTableViewCell @"MainTableViewCell"
#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *contentStr;

- (void)setData:(NSDictionary *)dataDic;
+ (CGFloat)cellHeightWithImageArray:(NSDictionary *)dataDic;
@end
