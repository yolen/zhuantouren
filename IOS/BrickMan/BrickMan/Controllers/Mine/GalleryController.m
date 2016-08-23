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
#import "ODRefreshControl.h"
#import "SVPullToRefresh.h"

@interface GalleryController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) ODRefreshControl *refreshControl;
@property (strong, nonatomic) BMContentListModel *contentList;

@end

@implementation GalleryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的砖集";
    self.contentList = [[BMContentListModel alloc] init];
    
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerClass:[MainTableViewCell class] forCellReuseIdentifier:kCellIdentifier_MainTableViewCell];
    [self.view addSubview:self.myTableView];
    
    __weak typeof(self) weakSelf = self;
    [self.myTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf refreshMore];
    }];
    
    self.refreshControl = [[ODRefreshControl alloc] initInScrollView:self.myTableView];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self refresh];
    
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
        [weakSelf.refreshControl endRefreshing];
        if (data) {
            [weakSelf.contentList configWithData:data];
            [weakSelf.myTableView reloadData];
            weakSelf.myTableView.showsInfiniteScrolling = weakSelf.contentList.canLoadMore;
        }else {
            weakSelf.myTableView.showsInfiniteScrolling = NO;
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentList.body.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MainTableViewCell forIndexPath:indexPath];
    cell.model = self.contentList.body[indexPath.row];
    //判断在我的砖集状态下,cell的四个按钮不可点击
    [cell setIsGallery:YES];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailBrickViewController *vc = [[DetailBrickViewController alloc] init];
    vc.model = self.contentList.body[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMContentModel  *model = self.contentList.body[indexPath.row];
    return [MainTableViewCell cellHeightWithModel:model];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
