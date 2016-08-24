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
#import "BMAttachmentModel.h"

@interface DetailBrickViewController()<UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) CommentInputView *inputView;
@end

@implementation DetailBrickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    self.inputView.sendCommentBlock = ^(){
        [self commentAction];
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.inputView p_show];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.inputView p_dismiss];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
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
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:60.0];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? [MainTableViewCell cellHeightWithModel:self.model] : [CommentCell cellHeight];
}

#pragma mark - Comment
- (void)commentAction {
    if (self.inputView.inputTextView.text.length == 0) {
        return;
    }
    NSString *userId = [BMUser getUserInfo][@"userId"];
    BMAttachmentModel *attachModel = self.model.brickContentAttachmentList[0];
    NSDictionary *info = @{@"userId" : userId,
                           @"contentId" : [attachModel.contentId stringValue],
                           @"commentContent" : self.inputView.inputTextView.text};
    [[BrickManAPIManager shareInstance] requestAddCommentWithParams:info andBlock:^(id data, NSError *error) {
        
    }];
}


@end
