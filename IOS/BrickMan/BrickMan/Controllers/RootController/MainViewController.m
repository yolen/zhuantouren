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
#import "DetailBrickViewController.h"
#import "LoginViewController.h"
#import "BMContentList.h"
#import "Advertisement.h"
#import "AutoScrollBannerView.h"
#import "ComposeViewController.h"
#import "YYModel.h"

@interface MainViewController ()<iCarouselDataSource, iCarouselDelegate>
@property (strong, nonatomic) XTSegmentControl *mySegmentControl;
@property (strong, nonatomic) iCarousel *myCarousel;
@property (strong, nonatomic) AutoScrollBannerView *bannerView;

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) UIView *headerView;
@property (assign, nonatomic) NSInteger oldSelectedIndex;
@property (strong, nonatomic) NSMutableDictionary *contentListDic;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleArray = @[@"最近发布",@"砖头最多",@"鲜花最多",@"评论最多"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.headerView = [self customHeaderView];
    self.oldSelectedIndex = 0;
    self.contentListDic = [NSMutableDictionary dictionaryWithCapacity:self.titleArray.count];
    
    _myCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, kScreen_Width, self.view.height - 155)];
    _myCarousel.dataSource = self;
    _myCarousel.delegate = self;
    _myCarousel.decelerationRate = 1.0;
    _myCarousel.scrollSpeed = 1.0;
    _myCarousel.type = iCarouselTypeLinear;
    _myCarousel.pagingEnabled = YES;
    _myCarousel.clipsToBounds = YES;
    _myCarousel.bounceDistance = 0.2;
    [self.view addSubview:_myCarousel];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"compose"] style:UIBarButtonItemStylePlain target:self action:@selector(composeAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self requestForBannder];
}

- (void)requestForBannder {
    __weak typeof(self) weakSelf = self;
    [[BrickManAPIManager shareInstance] requestAdvertisementWithParams:@{@"advertisementType" : @"2"} andBlock:^(id data, NSError *error) {
        if (data) {
            NSArray *adverArray = [NSArray yy_modelArrayWithClass:[Advertisement class] json:data];
            
            weakSelf.bannerView.bannerArray = adverArray;
        }
    }];
}

- (UIView *)customHeaderView {
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 170)];
    [self.view addSubview:headerV];
    
    self.bannerView = [[AutoScrollBannerView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 120)];
    [headerV addSubview:self.bannerView];
    
    __weak typeof(self) weakSelf = self;
    _mySegmentControl = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, self.bannerView.bottom, kScreen_Width, 50) Items:self.titleArray selectedBlock:^(NSInteger index) {
        if (index == self.oldSelectedIndex) {
            return ;
        }
        [weakSelf.myCarousel scrollToItemAtIndex:index animated:NO];
    }];
    _mySegmentControl.backgroundColor = kViewBGColor;
    [headerV addSubview:_mySegmentControl];
    
    return headerV;
}

#pragma mark - iCarousel
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.titleArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view {
    BrickListView *listView = (BrickListView *)view;
    if (listView) {
        [listView setContentListWithType:index];
    }else {
        listView = [[BrickListView alloc] initWithFrame:carousel.bounds andIndex:index];
    }
    
    __weak typeof(self) weakSelf = self;
    listView.scrollBlock = ^(CGFloat offset){
        if (offset < 0) {
            [weakSelf.headerView setY:0];
            [weakSelf.myCarousel setY:170];
        }else if (offset <= 120 && offset >= 0) {
            [weakSelf.headerView setY:-(offset)];
            [weakSelf.myCarousel setY:(170-offset)];
        }else if (offset > 120) {
            if (weakSelf.headerView.top != -120) {
                [weakSelf.headerView setY:-120];
                [weakSelf.myCarousel setY:50];
            }
        }
    };
    listView.goToDetailBlock = ^(BMContent *model){
        DetailBrickViewController *vc = [[DetailBrickViewController alloc] init];
        vc.model = model;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [listView setSubScrollsToTop:(index == carousel.currentItemIndex)];
    return listView;
}

- (void)carouselDidScroll:(iCarousel *)carousel {
    if (_mySegmentControl) {
        float offset = carousel.scrollOffset;
        if (offset > 0) {
            [_mySegmentControl moveIndexWithProgress:offset];
        }
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    if (_mySegmentControl) {
        _mySegmentControl.currentIndex = carousel.currentItemIndex;
    }
    if (_oldSelectedIndex != carousel.currentItemIndex) {
        _oldSelectedIndex = carousel.currentItemIndex;
//        BrickListView *listView = (BrickListView *)carousel.currentItemView;
//        [listView refresh];
    }
    
    [carousel.visibleItemViews enumerateObjectsUsingBlock:^(BrickListView *obj, NSUInteger idx, BOOL *stop) {
        [obj setSubScrollsToTop:(obj == carousel.currentItemView)];
    }];
}

#pragma mark - Handler
- (void)pushLoginViewController {
    LoginViewController *vc = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)composeAction:(id)sender {
    if (![BMUser isLogin]) {
        [self pushLoginViewController];
        return;
    }
    ComposeViewController *publishVC = [[ComposeViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:publishVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
