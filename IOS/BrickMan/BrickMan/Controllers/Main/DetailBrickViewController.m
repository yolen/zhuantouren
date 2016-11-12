//
//  DetailBrickViewController.m
//  BrickMan
//
//  Created by TZ on 16/7/21.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "DetailBrickViewController.h"
#import "LoginViewController.h"
#import "GalleryController.h"

#import "MainTableViewCell.h"
#import "CommentCell.h"
#import "CommentInputView.h"
#import "BMAttachment.h"
#import "BMCommentList.h"
#import <MJRefresh/MJRefresh.h>
#import "ShareView.h"

@interface DetailBrickViewController()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property(strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) CommentInputView *inputView;
@property (strong, nonatomic) BMCommentList *commentList;
@end

@implementation DetailBrickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"详情";
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
        [weakSelf.inputView.inputTextView resignFirstResponder];
        [weakSelf commentAction];
    };
    self.inputView.updateInputViewHeight = ^(CGFloat heightToBottom){
        [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            UIEdgeInsets contentInsets= UIEdgeInsetsMake(0.0, 0.0, heightToBottom, 0.0);;
            
            weakSelf.myTableView.contentInset = contentInsets;
        } completion:nil];
    };
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.myTableView.mj_header = header;
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMore)];
    [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"暂无更多评论" forState:MJRefreshStateNoMoreData];
    self.myTableView.mj_footer = footer;
    
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
            [weakSelf.myTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
            
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
        cell.isDetail = YES;
        cell.inputView = self.inputView;
        
        __weak typeof(self) weakSelf = self;
        cell.pushLoginBlock = ^(){
            [self.inputView p_dismiss];
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
            [self presentViewController:nav animated:YES completion:nil];
        };
        cell.shareBlock = ^(BMContent *content){
            ShareView *view = [ShareView showShareViewWithContent:content];
            view.successShareBlock = ^(){
                [weakSelf addShareCountAction];
            };
        };
        cell.reportBlock = ^(){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您确定要举报这位漂泊者发布的砖集吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        };
        
        if (!self.isComeFromeGallery) { // 如果当前页面是从`砖集`页面来了,内则不能再次推出砖集页面
            cell.pushGalleryBlock = ^(){
                GalleryController *galleryVc = [[GalleryController alloc] init];
                galleryVc.model = self.model;
                [weakSelf.navigationController pushViewController:galleryVc animated:YES];
            };
        }
//        cell.commentBlock = ^(){
//            [weakSelf.inputView becomeFirstResponder];
//            
//        };
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.inputView.inputTextView isFirstResponder]) {
        [self.inputView.inputTextView resignFirstResponder];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        MainTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        BMAttachment *attachmentModel = self.model.brickContentAttachmentList[0];
        NSString *contentId = [attachmentModel.contentId stringValue];
        [[BrickManAPIManager shareInstance] requestOperContentWithParams:@{@"contentId" : contentId, @"operType" : @"3", @"userId" : [BMUser getUserModel].userId} andBlock:^(id data, NSError *error) {
            if (data) {
                [NSObject showSuccessMsg:@"举报成功"];
                [cell.reportBtn setImage:[UIImage imageNamed:@"report_sel"] forState:UIControlStateNormal];
            }
        }];
    }
}

#pragma mark - Comment
- (void)commentAction {
    if (![BMUser isLogin]) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    if (self.inputView.inputTextView.text.length == 0) {
        kTipAlert(@"请输入评论内容");
        return;
    }
    MainTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    NSString *userId = [BMUser getUserModel].userId;
    BMAttachment *attachModel = self.model.brickContentAttachmentList[0];
    NSDictionary *info = @{@"userId" : userId,
                           @"contentId" : [attachModel.contentId stringValue],
                           @"commentContent" : self.inputView.inputTextView.text};
    __weak typeof(self) weakSelf = self;
    [[BrickManAPIManager shareInstance] requestAddCommentWithParams:info andBlock:^(id data, NSError *error) {
        weakSelf.inputView.inputTextView.text = @"";
        if (data) {
            [weakSelf refresh];
            [cell.commentBtn setTitle:[NSString stringWithFormat:@"评论 %ld",(long)(self.model.commentCount.integerValue + 1)] forState:UIControlStateNormal];
            [cell.commentBtn setImage: [UIImage imageNamed:@"comment_sel"] forState:UIControlStateNormal];
        }else {
            [NSObject showErrorMsg:@"评论失败"];
        }
    }];
}

- (void)addShareCountAction {
    MainTableViewCell *cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    BMAttachment *attachmentModel = self.model.brickContentAttachmentList[0];
    NSString *contentId = [attachmentModel.contentId stringValue];
    [[BrickManAPIManager shareInstance] requestAddShareCountWithParams:@{@"contentId" : contentId} andBlock:^(id data, NSError *error) {
        if (data) {
            [cell.shareBtn setTitle:[NSString stringWithFormat:@"分享 %ld",(long)(self.model.contentShares.integerValue + 1)] forState:UIControlStateNormal];
            [cell.shareBtn setImage:[UIImage imageNamed:@"share_sel"] forState:UIControlStateNormal];
        }
    }];
}


@end
