//
//  BrickListView.h
//  BrickMan
//
//  Created by TZ on 16/7/21.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMContent.h"

@interface BrickListView : UIView
@property (copy, nonatomic) void(^scrollBlock)(CGFloat offset);
@property (copy, nonatomic) void(^goToDetailBlock)(BMContent *model);
@property (strong, nonatomic) UITableView *myTableView;

- (instancetype)initWithFrame:(CGRect)frame andIndex:(NSInteger)index;
//- (void)refreshFirst;
- (void)refresh;

@end
