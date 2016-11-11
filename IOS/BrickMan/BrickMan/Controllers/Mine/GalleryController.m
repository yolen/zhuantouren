//
//  GalleryController.m
//  BrickMan
//
//  Created by 段永瑞 on 16/7/22.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "GalleryController.h"
#import "MainTableViewCell.h"
#import "DetailBrickViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "BMGalleryTableHeaderView.h"

#define kHEAD_RADIO 800.0 / 1242.0

@interface GalleryController ()<UITableViewDataSource,UITableViewDelegate> {
    /** UINavigationBar 的shadowImage */
    UIImage *_navShadowImage;
}
@property (nonatomic, strong) UITableView *myTableView;
@property (strong, nonatomic) BMContentList *contentList;

@end

@implementation GalleryController

+ (instancetype)galleryControllerWithUserNickName:(NSString *)userNickName userID:(NSString *)userID {
    return [[self alloc] initWithUserNickName:userNickName userID:userNickName];
}

- (instancetype)initWithUserNickName:(NSString *)userNickName userID:(NSString *)userID {
    if (self = [super init]) {
        self.userNickName = userNickName;
        self.userID = userID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = [NSString stringWithFormat:@"%@的砖集", self.userNickName];
    self.contentList = [[BMContentList alloc] init];
    self.contentList.userID = self.userID;
    
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerClass:[MainTableViewCell class] forCellReuseIdentifier:kCellIdentifier_MainTableViewCell];
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.myTableView.tableHeaderView = [[BMGalleryTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kHEAD_RADIO * kScreen_Width)];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.myTableView.mj_header = header;
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMore)];
    [self refresh];
    [self requestUserInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    _navShadowImage = self.navigationController.navigationBar.shadowImage;
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNavigationBarColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:_navShadowImage];
}

#pragma mark - refresh
- (void)refresh {
    if (self.contentList.isLoading) {
        return;
    }
    self.contentList.willLoadMore = NO;
    [self sendRequest];
}

- (void)refreshMore {
    if (self.contentList.isLoading || !self.contentList.canLoadMore) {
        return;
    }
    self.contentList.willLoadMore = YES;
    [self sendRequest];
}

- (void)sendRequest {
    __weak typeof(self) weakSelf = self;
    [[BrickManAPIManager shareInstance] requestUserContentListWithObj:self.contentList andBlock:^(id data, NSError *error) {
        [weakSelf.myTableView.mj_header endRefreshing];
        [weakSelf.myTableView.mj_footer endRefreshing];
        if (data) {
            [weakSelf.contentList configWithData:data];
            [weakSelf.myTableView reloadData];
            BMContentList *model = (BMContentList *)data;
            if (!weakSelf.contentList.canLoadMore || model.data.count == 0) {
                [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }];
}

- (void)requestUserInfo {
    //刷新数据
    [[BrickManAPIManager shareInstance] requestUserInfoWithParams:@{@"userId" : self.userID} andBlock:^(id data, NSError *error) {
        if (data) {
            BMGalleryTableHeaderView *tableHeaderView = (BMGalleryTableHeaderView *)self.myTableView.tableHeaderView;
            [tableHeaderView configHeaderViewWithUser: [BMUser getUserModel]];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentList.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MainTableViewCell forIndexPath:indexPath];
    cell.model = self.contentList.data[indexPath.row];
    //判断在我的砖集状态下,cell的四个按钮不可点击
    [cell setIsGallery:YES];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailBrickViewController *vc = [[DetailBrickViewController alloc] init];
    vc.model = self.contentList.data[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMContent *model = self.contentList.data[indexPath.row];
    return [MainTableViewCell cellHeightWithModel:model];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
