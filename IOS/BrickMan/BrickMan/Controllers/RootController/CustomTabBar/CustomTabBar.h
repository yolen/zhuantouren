//
//  CustomTabBar.h
//  BrickMan
//
//  Created by TZ on 2016/11/14.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarButton.h"

@protocol CustomTabBarDelegate <NSObject>
@required
- (void)changeNavigation:(NSInteger)fromIndex to:(NSInteger)toIndex;
@end

@interface CustomTabBar : UIView

@property (assign, nonatomic) id<CustomTabBarDelegate> delegate;

-(void) btnClick:(TabBarButton *)button;

- (void)changeTabBarToIndex:(NSInteger)index;

@end
