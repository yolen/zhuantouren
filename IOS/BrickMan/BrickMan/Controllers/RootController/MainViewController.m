//
//  MainViewController.m
//  BrickMan
//
//  Created by TZ on 16/7/18.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "XTSegmentControl.h"
#import "iCarousel.h"
#import "BrickListView.h"

@interface MainViewController ()<iCarouselDataSource, iCarouselDelegate>
@property (strong, nonatomic) XTSegmentControl *mySegmentControl;
@property (strong, nonatomic) iCarousel *myCarousel;
@property (strong, nonatomic) NSArray *titleArray;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleArray = @[@"最近发布",@"砖头最多",@"鲜花最多"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 120)];
    imageView.image = [UIImage imageNamed:@"headerImg"];
    [self.view addSubview:imageView];
    
    __weak typeof(self) weakSelf = self;
    _mySegmentControl = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, imageView.bottom, kScreen_Width, 50) Items:self.titleArray selectedBlock:^(NSInteger index) {
        [weakSelf.myCarousel scrollToItemAtIndex:index animated:NO];
    }];
    _mySegmentControl.backgroundColor = RGBCOLOR(244, 245, 246);
    [self.view addSubview:_mySegmentControl];
    
    _myCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, _mySegmentControl.bottom, kScreen_Width, self.view.height - 283)];
    _myCarousel.dataSource = self;
    _myCarousel.delegate = self;
    _myCarousel.decelerationRate = 1.0;
    _myCarousel.scrollSpeed = 1.0;
    _myCarousel.type = iCarouselTypeLinear;
    _myCarousel.pagingEnabled = YES;
    _myCarousel.clipsToBounds = YES;
    _myCarousel.bounceDistance = 0.2;
    [self.view addSubview:_myCarousel];
}

#pragma mark - iCarousel
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.titleArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    BrickListView *list = [[BrickListView alloc] initWithFrame:carousel.bounds];
    return list;
}

- (void)carouselDidScroll:(iCarousel *)carousel{
    if (_mySegmentControl) {
        float offset = carousel.scrollOffset;
        if (offset > 0) {
            [_mySegmentControl moveIndexWithProgress:offset];
        }
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    if (_mySegmentControl) {
        _mySegmentControl.currentIndex = carousel.currentItemIndex;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
