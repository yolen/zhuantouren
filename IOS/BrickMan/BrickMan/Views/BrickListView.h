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
@property (strong, nonatomic) UITableView *myTableView;

@property (copy, nonatomic) void(^scrollBlock)(CGFloat offset);
@property (copy, nonatomic) void(^goToDetailBlock)(BMContent *model);
@property (nonatomic, copy) void(^goToGalleryBlock)(NSString *userID, NSString *userNickName);


- (instancetype)initWithFrame:(CGRect)frame andIndex:(NSInteger)index;
- (void)setContentListWithType:(NSInteger)type;

- (void)refresh;

- (void)setSubScrollsToTop:(BOOL)scrollsToTop;
@end
