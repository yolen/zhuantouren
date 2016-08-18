//
//  BrickListView.m
//  BrickMan
//
//  Created by TZ on 16/7/21.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BrickListView.h"
#import "MainTableViewCell.h"
#import "ShareView.h"
#import "ODRefreshControl.h"
#import "SVPullToRefresh.h"
#import "BMContentListModel.h"

@interface BrickListView()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *myTableView;
@property (nonatomic, strong) ODRefreshControl *refreshControl;

@property (strong, nonatomic) BMContentListModel *contentList;
@end

@implementation BrickListView

- (instancetype)initWithFrame:(CGRect)frame andIndex:(NSInteger)index {
    if (self = [super initWithFrame:frame]) {
        self.contentList = [BMContentListModel contentListlWithType:index];
        self.myTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.myTableView.dataSource = self;
        self.myTableView.delegate = self;
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.myTableView registerClass:[MainTableViewCell class] forCellReuseIdentifier:kCellIdentifier_MainTableViewCell];
        [self addSubview:self.myTableView];
        
        __weak typeof(self) weakSelf = self;
        [self.myTableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf refreshMore];
        }];
        
        self.refreshControl = [[ODRefreshControl alloc] initInScrollView:self.myTableView];
        [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
        [self refresh];

    }
    return self;
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
    [[BrickManAPIManager shareInstance] requestContentListWithObj:self.contentList andBlock:^(id data, NSError *error) {
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

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentList.body.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MainTableViewCell forIndexPath:indexPath];
    cell.model = self.contentList.body[indexPath.row];
    cell.shareBlock = ^(){
        [ShareView showShareView];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMContentModel  *model = self.contentList.body[indexPath.row];
    return [MainTableViewCell cellHeightWithModel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BMContentModel *model = self.contentList.body[indexPath.row];
    if (self.goToDetailBlock) {
        self.goToDetailBlock(model);
    }
}

#pragma mark - scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollBlock) {
        self.scrollBlock(scrollView.contentOffset.y);
    }
}

@end
