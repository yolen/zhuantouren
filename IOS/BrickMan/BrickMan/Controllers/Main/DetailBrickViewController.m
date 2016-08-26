//
//  DetailBrickViewController.m
//  BrickMan
//
//  Created by TZ on 16/7/21.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "DetailBrickViewController.h"
#import "MainTableViewCell.h"
#import "CommentCell.h"
#import "CommentInputView.h"
#import "BMAttachment.h"
#import "BMCommentList.h"
#import <MJRefresh/MJRefresh.h>

@interface DetailBrickViewController()<UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) CommentInputView *inputView;
@property (strong, nonatomic) BMCommentList *commentList;
@end

@implementation DetailBrickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commentList = [[BMCommentList alloc] init];
    BMAttachment *attachment = self.model.brickContentAttachmentList[0];
    self.commentList.contentId = [attachment.contentId stringValue];
    
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerClass:[MainTableViewCell class] forCellReuseIdentifier:kCellIdentifier_MainTableViewCell];
    [self.myTableView registerClass:[CommentCell class] forCellReuseIdentifier:kCellIdentifier_CommentCell];
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.myTableView.contentInset = inset;
    self.myTableView.scrollIndicatorInsets = inset;
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.inputView = [CommentInputView getInputView];
    __weak typeof(self) weakSelf = self;
    self.inputView.sendCommentBlock = ^(){
        [weakSelf commentAction];
    };
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.myTableView.mj_header = header;
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMore)];
    
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.inputView p_show];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.inputView p_dismiss];
}

#pragma mark - Refresh
- (void)refresh {
    if (self.commentList.isLoading) {
        return;
    }
    self.commentList.willLoadMore = NO;
    [self sendRequest];
}

- (void)refreshMore {
    if (self.commentList.isLoading || !self.commentList.canLoadMore) {
        return;
    }
    self.commentList.willLoadMore = YES;
    [self sendRequest];
}

- (void)sendRequest {
    __weak typeof(self) weakSelf = self;
    [[BrickManAPIManager shareInstance] requestCommentListWithObj:self.commentList andBlock:^(id data, NSError *error) {
        [weakSelf.myTableView.mj_header endRefreshing];
        [weakSelf.myTableView.mj_footer endRefreshing];
        if (data) {
            [weakSelf.commentList configWithData:data];
            [weakSelf.myTableView reloadData];
            
            BMCommentList *model = (BMCommentList *)data;
            if (!weakSelf.commentList.canLoadMore || model.data.count == 0) {
                [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }else {
            [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.commentList.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MainTableViewCell forIndexPath:indexPath];
        cell.model = self.model;
        cell.inputView = self.inputView;
        __weak typeof(self) weakSelf = self;
        cell.commentBlock = ^(){
            [weakSelf.inputView becomeFirstResponder];
            
        };
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0 hasSectionLine:NO];
        return cell;
    }else {
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CommentCell forIndexPath:indexPath];
        BMComment *comment = self.commentList.data[indexPath.row];
        cell.comment = comment;
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:60.0];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [MainTableViewCell cellHeightWithModel:self.model];
    }else {
        BMComment *comment = self.commentList.data[indexPath.row];
        return [CommentCell cellHeightWithModel:comment];
    }
}

#pragma mark - Comment
- (void)commentAction {
    if (self.inputView.inputTextView.text.length == 0) {
        return;
    }
    NSString *userId = [BMUser getUserInfo][@"userId"];
    BMAttachment *attachModel = self.model.brickContentAttachmentList[0];
    NSDictionary *info = @{@"userId" : userId,
                           @"contentId" : [attachModel.contentId stringValue],
                           @"commentContent" : self.inputView.inputTextView.text};
    [[BrickManAPIManager shareInstance] requestAddCommentWithParams:info andBlock:^(id data, NSError *error) {
        if (data) {
            
        }
    }];
}


@end
