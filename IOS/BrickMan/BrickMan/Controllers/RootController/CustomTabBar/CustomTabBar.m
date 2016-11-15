//
//  CustomTabBar.m
//  BrickMan
//
//  Created by TZ on 2016/11/14.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "CustomTabBar.h"
#import "TabBarButton.h"
#import "RootTabBarController.h"

@interface CustomTabBar()
@property (strong, nonatomic) TabBarButton *selectedTB;

@end

@implementation CustomTabBar

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTabBarButtons];
    }
    return self;
}

- (void)addTabBarButtons {
    for (int i = 0 ; i<3 ; i++) {
        TabBarButton *btn = [[TabBarButton alloc] init];
        btn.tag = i;
        CGFloat btnW = self.frame.size.width/3;
        CGFloat btnX = i * btnW;
        CGFloat btnY = 5;
        
        CGFloat btnH = self.frame.size.height - 10;
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        NSString *imageName = [NSString stringWithFormat:@"tabbar%d_nor",i];
        NSString *selImageName = [NSString stringWithFormat:@"tabbar%d_sel",i];
        NSString *title;
        if (i == 0) {
            title = @"砖集";
        }else if (i == 1) {
            imageName = @"摄影机图标_点击前";
            selImageName =@"摄影机图标_点击后";
        }else if(i == 2){
            title = @"我的";
        }
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:selImageName] forState:UIControlStateSelected];
        
        if (i != 1) {
            [btn setTitle:title forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize: 11];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn setTitleColor:kNavigationBarColor forState:UIControlStateSelected];
            [btn setTitleColor:RGBCOLOR(128, 128, 128) forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
            [self addSubview:btn];
        }
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        if(i == 0){
            [self btnClick:btn];
        }
    }
}

-(void) btnClick:(TabBarButton *)button {
    NSInteger toIndex = button.tag;
    if (![BMUser isLogin] && toIndex == 2) {
         MainViewController *mainVC = [[RootTabBarController sharedInstance] getMainViewController];
        [mainVC pushLoginViewController];
        return;
    }
    [self.delegate changeNavigation:_selectedTB.tag to:toIndex];
    _selectedTB.selected = NO;
    button.selected = YES;
    _selectedTB = button;
}

- (void)changeTabBarToIndex:(NSInteger)index {
    TabBarButton *btn = self.subviews[index];
    _selectedTB.selected = NO;
    btn.selected = YES;
}

@end
