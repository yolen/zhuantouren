//
//  MainViewController.m
//  BrickMan
//
//  Created by TZ on 16/7/18.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "MainViewController.h"
#import "ComposeViewController.h"
#import "DetailBrickViewController.h"
#import "LoginViewController.h"
#import "GalleryController.h"
#import "UserNotifyViewController.h"

#import "MainTableViewCell.h"
#import "XTSegmentControl.h"
#import "BrickListView.h"
#import "BMContentList.h"
#import "Advertisement.h"
#import "AutoScrollBannerView.h"
#import "YYModel.h"
#import "SwipeTableView.h"
#import <MJRefresh.h>

@interface MainViewController ()<SwipeTableViewDataSource,SwipeTableViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) SwipeTableView * swipeTableView;
@property (nonatomic, strong) STHeaderView * tableViewHeader;
@property (strong, nonatomic) XTSegmentControl *mySegmentControl;
@property (strong, nonatomic) AutoScrollBannerView *bannerView;

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) UIView *headerView;
@property (assign, nonatomic) NSInteger oldSelectedIndex;
@property (strong, nonatomic) NSMutableDictionary *contentListDic;
@property (strong, nonatomic) NSMutableDictionary *cacheDataDic;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleArray = [@[@"最新发布",@"砖头最多",@"鲜花最多",@"评论最多"] mutableCopy];
    self.contentListDic = [NSMutableDictionary dictionaryWithCapacity:self.titleArray.count];
    self.cacheDataDic = [NSMutableDictionary dictionaryWithCapacity:4];
    
    __weak typeof(self) weakSelf = self;
    _mySegmentControl = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, self.bannerView.bottom, kScreen_Width, 50) Items:self.titleArray selectedBlock:^(NSInteger index) {
        [weakSelf.swipeTableView scrollToItemAtIndex:index animated:NO];
    }];
    _mySegmentControl.backgroundColor = kViewBGColor;
    
    _swipeTableView = [[SwipeTableView alloc] init];
    _swipeTableView.backgroundColor = [UIColor clearColor];
    _swipeTableView.delegate = self;
    _swipeTableView.dataSource = self;
    _swipeTableView.shouldAdjustContentSize = YES;
    _swipeTableView.swipeHeaderView = [self tableViewHeader];
    _swipeTableView.swipeHeaderBar = self.mySegmentControl;
    _swipeTableView.swipeHeaderBarScrollDisabled = YES;
    _swipeTableView.swipeHeaderTopInset = 0;
    [self.view addSubview:_swipeTableView];
    [_swipeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(kScreen_Width);
        make.top.equalTo(self.view.top);
        make.bottom.equalTo(self.view.mas_bottom).offset(-5);
    }];
    [self requestForBannder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([BMUser isLogin]) {
        [self requestForRemind];
    }
}

- (UIView *)tableViewHeader {
    if (!_tableViewHeader) {
        self.bannerView = [[AutoScrollBannerView alloc] init];
        
        self.tableViewHeader = [[STHeaderView alloc]init];
        _tableViewHeader.frame = self.bannerView.bounds;
        _tableViewHeader.backgroundColor = [UIColor clearColor];
        _tableViewHeader.layer.masksToBounds = YES;
        [_tableViewHeader addSubview:self.bannerView];
    }
    return _tableViewHeader;
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

#pragma mark - SwipeTableView
- (NSInteger)numberOfItemsInSwipeTableView:(SwipeTableView *)swipeView {
    return 4;
}

- (UIScrollView *)swipeTableView:(SwipeTableView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIScrollView *)view {
    BrickListView * brickListView = (BrickListView *)view;
    if (!brickListView) {
        brickListView = [[BrickListView alloc]initWithFrame:swipeView.bounds style:UITableViewStylePlain];
    }
    if (![self.cacheDataDic objectForKey:[NSNumber numberWithInteger:index]]) {
        [brickListView refreshContentListWithIndex:index];
    }else {
        [brickListView setCurList:[self.cacheDataDic objectForKey:[NSNumber numberWithInteger:index]]];
    }
    brickListView.getCurContentListBlock = ^(BMContentList *list){
        [self.cacheDataDic setObject:list forKey:[NSNumber numberWithInteger:index]];
    };
    
    __weak typeof(self) weakSelf = self;
    brickListView.goToDetailBlock = ^(BMContent *model){
        DetailBrickViewController *vc = [[DetailBrickViewController alloc] init];
        vc.contentId = model.id;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    brickListView.goToGalleryBlock = ^(BMContent *model){
        GalleryController *galleryVc = [[GalleryController alloc] init];
        model.user.userId = model.user.userId.length == 0 ? model.userId : model.user.userId;
        galleryVc.user = model.user;
        [weakSelf.navigationController pushViewController:galleryVc animated:YES];
    };
    return brickListView;
}

- (void)swipeTableViewCurrentItemIndexDidChange:(SwipeTableView *)swipeView {
    _mySegmentControl.currentIndex = swipeView.currentItemIndex;
}

- (void)swipeTableViewDidScroll:(SwipeTableView *)swipeView {
    [_mySegmentControl moveIndexWithProgress:(swipeView.contentView.contentOffset.x/kScreen_Width)];
}

- (BOOL)swipeTableView:(SwipeTableView *)swipeTableView shouldPullToRefreshAtIndex:(NSInteger)index {
    return YES;
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
    UserNotifyViewController *notifyVC = [[UserNotifyViewController alloc] init];
    [self.navigationController pushViewController:notifyVC animated:YES];
//    ComposeViewController *publishVC = [[ComposeViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:publishVC];
//    [self presentViewController:nav animated:YES completion:nil];
}

- (void)requestForRemind {
    [[BrickManAPIManager shareInstance] requestRemindWithParams:nil andBlock:^(id data, NSError *error) {
        NSNumber *countNum = (NSNumber *)data;
        if (countNum.integerValue > 0) {
            [self setRightBarButtonItemWithImage:@"message"];
        }else {
            [self setRightBarButtonItemWithImage:nil];
        }
    }];
}

- (void)setRightBarButtonItemWithImage:(NSString *)imageStr {
    if (imageStr) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:imageStr] style:UIBarButtonItemStylePlain target:self action:@selector(composeAction:)];
        self.navigationItem.rightBarButtonItem = rightItem;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearDisk];
}

@end
