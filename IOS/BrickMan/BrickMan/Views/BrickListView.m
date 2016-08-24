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

@property (strong, nonatomic) NSMutableDictionary *contentListDic;
@property (assign, nonatomic) NSInteger curIndex;
@end

@implementation BrickListView

- (instancetype)initWithFrame:(CGRect)frame andIndex:(NSInteger)index {
    if (self = [super initWithFrame:frame]) {
        self.contentListDic = [NSMutableDictionary dictionaryWithCapacity:4];
        self.curIndex = index;
        
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
        [self refreshFirst];

    }
    return self;
}



#pragma mark - refresh
- (void)refreshFirst {
    BMContentListModel *contentList = [self getContentList];
    if (contentList) {
        self.myTableView.showsInfiniteScrolling = contentList.canLoadMore;
    }else {
        contentList = [BMContentListModel contentListlWithType:self.curIndex];
        [self saveContentList:contentList];
    }
    if (contentList.data.count <= 0) {
        [self refresh];
    }
}

- (void)refresh {
    BMContentListModel *contentList = [self getContentList];
    if (contentList.isLoading) {
        return;
    }
    contentList.willLoadMore = NO;
    [self sendRequest];
}

- (void)refreshMore {
    BMContentListModel *contentList = [self getContentList];
    if (contentList.isLoading || !contentList.canLoadMore) {
        return;
    }
    contentList.willLoadMore = YES;
    [self sendRequest];
}

- (void)sendRequest {
    BMContentListModel *contentList = [self getContentList];
    
    __weak typeof(self) weakSelf = self;
    [[BrickManAPIManager shareInstance] requestContentListWithObj:contentList andBlock:^(id data, NSError *error) {
        [weakSelf.refreshControl endRefreshing];
        [weakSelf.myTableView.infiniteScrollingView stopAnimating];
        
        if (data) {
            [contentList configWithData:data];
            [weakSelf.myTableView reloadData];
            weakSelf.myTableView.showsInfiniteScrolling = contentList.canLoadMore;
        }
    }];
}

#pragma mark - Get And Set
- (void)saveContentList:(BMContentListModel *)model {
    [self.contentListDic setObject:model forKey:[NSNumber numberWithInteger:self.curIndex]];
}

- (BMContentListModel *)getContentList {
    return [self.contentListDic objectForKey:[NSNumber numberWithInteger:self.curIndex]];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BMContentListModel *contentList = [self getContentList];
    return contentList.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MainTableViewCell forIndexPath:indexPath];
    BMContentListModel *contentList = [self getContentList];
    cell.model = contentList.data[indexPath.row];
    cell.shareBlock = ^(){
        [ShareView showShareView];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMContentListModel *contentList = [self getContentList];
    BMContentModel  *model = contentList.data[indexPath.row];
    return [MainTableViewCell cellHeightWithModel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BMContentListModel *contentList = [self getContentList];
    BMContentModel *model = contentList.data[indexPath.row];
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
