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
#import <MJRefresh/MJRefresh.h>
#import "BMContentList.h"

@interface BrickListView()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) BMContentList *contentList;
@property (strong, nonatomic) NSMutableDictionary *contentListDic;
@property (assign, nonatomic) NSInteger curIndex;
@end

@implementation BrickListView

- (instancetype)initWithFrame:(CGRect)frame andIndex:(NSInteger)index {
    if (self = [super initWithFrame:frame]) {
        self.contentListDic = [NSMutableDictionary dictionaryWithCapacity:4];
        self.contentList = [BMContentList contentListlWithType:index];
        self.curIndex = index;
        
        self.myTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.myTableView.dataSource = self;
        self.myTableView.delegate = self;
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.myTableView registerClass:[MainTableViewCell class] forCellReuseIdentifier:kCellIdentifier_MainTableViewCell];
        [self addSubview:self.myTableView];
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        self.myTableView.mj_header = header;
        
        self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMore)];
        
        [self sendRequest];
    }
    return self;
}

#pragma mark - refresh
//- (void)refreshFirst {
//    if (self.contentList) {
//        self.myTableView.showsInfiniteScrolling = self.contentList.canLoadMore;
//    }else {
//        [self saveContentList:self.contentList];
//    }
//    if (self.contentList.data.count <= 0) {
//        [self refresh];
//    }
//}

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

#pragma mark - Get And Set
- (void)saveContentList:(BMContentList *)model {
    [self.contentListDic setObject:model forKey:[NSNumber numberWithInteger:self.curIndex]];
}

- (BMContentList *)getContentList {
    return [self.contentListDic objectForKey:[NSNumber numberWithInteger:self.curIndex]];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentList.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MainTableViewCell forIndexPath:indexPath];
    cell.model = self.contentList.data[indexPath.row];
    if ((self.myTableView.isDragging || self.myTableView.isDecelerating) ) {
        
    }
    cell.shareBlock = ^(){
        [ShareView showShareView];
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
