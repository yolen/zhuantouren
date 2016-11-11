//
//  BrickListView.m
//  BrickMan
//
//  Created by TZ on 16/7/21.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BrickListView.h"
#import "MainTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "BMContentList.h"

@interface BrickListView()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) BMContentList *contentList;
@property (assign, nonatomic) NSInteger curIndex;
@end

@implementation BrickListView

- (instancetype)initWithFrame:(CGRect)frame andIndex:(NSInteger)index {
    if (self = [super initWithFrame:frame]) {
        self.contentList = [BMContentList contentListlWithType:index];
        self.curIndex = index;
        
        self.myTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.myTableView.dataSource = self;
        self.myTableView.delegate = self;
        self.myTableView.backgroundColor = [UIColor clearColor];
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.myTableView registerClass:[MainTableViewCell class] forCellReuseIdentifier:kCellIdentifier_MainTableViewCell];
        [self addSubview:self.myTableView];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        self.myTableView.mj_header = header;
        
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMore)];
        [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
        self.myTableView.mj_footer = footer;
        
        [self sendRequest];
    }
    return self;
}

- (void)setContentListWithType:(NSInteger)type {
    self.contentList = [BMContentList contentListlWithType:type];
    [self refresh];
}

- (void)setSubScrollsToTop:(BOOL)scrollsToTop{
    [[self subviews] enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)obj setScrollEnabled:scrollsToTop];
            *stop = YES;
        }
    }];
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
    
    if (self.contentList.orderType.integerValue == 3) {
        [[BrickManAPIManager shareInstance] requestContentByCommentWithObj:self.contentList andBlock:^(id data, NSError *error) {
            [weakSelf.myTableView.mj_header endRefreshing];
            [weakSelf.myTableView.mj_footer endRefreshing];
            if (data) {
                [weakSelf.contentList configWithData:data];
                [weakSelf.myTableView reloadData];
                
                BMContentList *model = (BMContentList *)data;
                if (!weakSelf.contentList.canLoadMore || model.data.count == 0) {
                    [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else {
                [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
            }

        }];
    }else {
        [[BrickManAPIManager shareInstance] requestContentListWithObj:self.contentList andBlock:^(id data, NSError *error) {
            [weakSelf.myTableView.mj_header endRefreshing];
            [weakSelf.myTableView.mj_footer endRefreshing];
            if (data) {
                [weakSelf.contentList configWithData:data];
                [weakSelf.myTableView reloadData];
                
                BMContentList *model = (BMContentList *)data;
                if (!weakSelf.contentList.canLoadMore || model.data.count == 0) {
                    [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else {
                [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentList.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MainTableViewCell forIndexPath:indexPath];
    BMContent *model = self.contentList.data[indexPath.row];
    cell.model = model;
    cell.isDetail = NO;
    if ((self.myTableView.isDragging || self.myTableView.isDecelerating) ) {
        
    }
    __weak typeof(self) weakSelf = self;
    cell.refreshCellBlock = ^(){
        [weakSelf.myTableView reloadData];
    };
    cell.pushDetailBlock = ^(){
        if (self.goToDetailBlock) {
            self.goToDetailBlock(model);
        }
    };
    cell.pushGalleryBlock = ^(){
        if (self.goToGalleryBlock) {
            self.goToGalleryBlock(model.userId, model.user.userAlias);
        }
    };
    cell.pushLoginBlock = ^(){
        
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMContent  *model = self.contentList.data[indexPath.row];
    return [MainTableViewCell cellHeightWithModel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BMContent *model = self.contentList.data[indexPath.row];
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
