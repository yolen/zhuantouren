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
#import "SwipeTableView.h"

@interface BrickListView()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) MJRefreshNormalHeader *refresh_header;
@end

@implementation BrickListView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[MainTableViewCell class] forCellReuseIdentifier:kCellIdentifier_MainTableViewCell];
        
        self.refresh_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        self.refresh_header.automaticallyChangeAlpha = YES;
        self.refresh_header.lastUpdatedTimeLabel.hidden = YES;
        self.mj_header = self.refresh_header;
        
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMore)];
        [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
        self.mj_footer = footer;
    }
    return self;
}

- (void)refreshContentListWithIndex:(NSInteger)index {
    self.curList = [BMContentList contentListlWithType:index];
    [self refresh];
}

- (void)setContentListWithType:(NSInteger)type {
    self.curList = [BMContentList contentListlWithType:type];
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

- (void)setCurList:(BMContentList *)curList {
    if (_curList != curList) {
        _curList = curList;
        
        [self reloadData];
    }
}

#pragma mark - refresh
- (void)refresh {
    if (self.curList.isLoading) {
        return;
    }
    self.curList.willLoadMore = NO;
    [self sendRequest];
}

- (void)refreshMore {
    if (self.curList.isLoading || !self.curList.canLoadMore) {
        return;
    }
    self.curList.willLoadMore = YES;
    [self sendRequest];
}

- (void)sendRequest {
    __weak typeof(self) weakSelf = self;
    
    if (self.curList.orderType.integerValue == 3) {
        [[BrickManAPIManager shareInstance] requestContentByCommentWithObj:self.curList andBlock:^(id data, NSError *error) {
            [weakSelf.mj_header endRefreshing];
            [weakSelf.mj_footer endRefreshing];
            if (data) {
                [weakSelf.curList configWithData:data];
                if (weakSelf.getCurContentListBlock) {
                    weakSelf.getCurContentListBlock(weakSelf.curList);
                }
                [weakSelf reloadData];
                
                BMContentList *model = (BMContentList *)data;
                if (!weakSelf.curList.canLoadMore || model.data.count == 0) {
                    [weakSelf.mj_footer endRefreshingWithNoMoreData];
                }
            }else {
                [weakSelf.mj_footer endRefreshingWithNoMoreData];
            }

        }];
    }else {
        [[BrickManAPIManager shareInstance] requestContentListWithObj:self.curList andBlock:^(id data, NSError *error) {
            [weakSelf.mj_header endRefreshing];
            [weakSelf.mj_footer endRefreshing];
            if (data) {
                [weakSelf.curList configWithData:data];
                if (weakSelf.getCurContentListBlock) {
                    weakSelf.getCurContentListBlock(weakSelf.curList);
                }
                [weakSelf reloadData];
                
                BMContentList *model = (BMContentList *)data;
                if (!weakSelf.curList.canLoadMore || model.data.count == 0) {
                    [weakSelf.mj_footer endRefreshingWithNoMoreData];
                }
            }else {
                [weakSelf.mj_footer endRefreshingWithNoMoreData];
            }
        }];
    }
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.curList.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MainTableViewCell forIndexPath:indexPath];
    BMContent *model = self.curList.data[indexPath.row];
    cell.model = model;
    cell.isDetail = NO;
    if ((self.isDragging || self.isDecelerating) ) {
        
    }
    __weak typeof(self) weakSelf = self;
    cell.refreshCellBlock = ^(){
        [weakSelf reloadData];
    };
    cell.pushDetailBlock = ^(){
        if (self.goToDetailBlock) {
            self.goToDetailBlock(model);
        }
    };
    cell.pushGalleryBlock = ^(){
        if (self.goToGalleryBlock) {
            self.goToGalleryBlock(model);
        }
    };
    cell.pushLoginBlock = ^(){
        
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMContent  *model = self.curList.data[indexPath.row];
    return [MainTableViewCell cellHeightWithModel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BMContent *model = self.curList.data[indexPath.row];
    if (self.goToDetailBlock) {
        self.goToDetailBlock(model);
    }
}

@end
