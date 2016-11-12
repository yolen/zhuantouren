//
//  AutoScrollBannerView.m
//  BrickMan
//
//  Created by TZ on 16/9/2.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "AutoScrollBannerView.h"
#import "Advertisement.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface AutoScrollBannerView()<SDCycleScrollViewDelegate>
@property (strong, nonatomic) SDCycleScrollView *autoSlideView;
@end

@implementation AutoScrollBannerView

- (instancetype)init {
    if (self = [super init]) {
        [self setSize:CGSizeMake(kScreen_Width, 120)];
    }
    return self;
}


- (void)setBannerArray:(NSArray *)bannerArray {
    _bannerArray = bannerArray;
    NSMutableArray *adverUrlArray = [NSMutableArray array];
    for (Advertisement *adver in bannerArray) {
        NSString *urlString = adver.advertisementUrl;
        if (urlString && urlString.length > 0) {
            [adverUrlArray addObject:urlString];
        }
    }
    
    if (!_autoSlideView) {
        _autoSlideView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreen_Width, self.height) delegate:self placeholderImage:nil];
        _autoSlideView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _autoSlideView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _autoSlideView.currentPageDotImage = [UIImage imageNamed:@"page_sel"];
        _autoSlideView.pageDotImage = [UIImage imageNamed:@"page_unsel"];
        _autoSlideView.autoScrollTimeInterval = 5.0;
        [self addSubview:_autoSlideView];
    }
    _autoSlideView.imageURLStringsGroup = adverUrlArray;
//    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
}

@end
