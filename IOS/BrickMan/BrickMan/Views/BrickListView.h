//
//  BrickListView.h
//  BrickMan
//
//  Created by TZ on 16/7/21.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMContent.h"
#import "BMContentList.h"

@interface BrickListView : UITableView

@property (copy, nonatomic) void(^scrollBlock)(CGFloat offset);
@property (copy, nonatomic) void(^goToDetailBlock)(BMContent *model);
@property (copy, nonatomic) void(^getCurContentListBlock)(BMContentList *list);

@property (strong, nonatomic) BMContentList *curList;

- (void)refreshContentListWithIndex:(NSInteger)index; //初始化刷新

- (void)setContentListWithType:(NSInteger)type;

- (void)refresh;

- (void)setSubScrollsToTop:(BOOL)scrollsToTop;
@end
