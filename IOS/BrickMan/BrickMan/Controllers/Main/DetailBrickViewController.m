//
//  DetailBrickViewController.m
//  BrickMan
//
//  Created by TZ on 16/7/21.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "DetailBrickViewController.h"
#import "MainDetailCell.h"
#import "CommentCell.h"

@interface DetailBrickViewController()<UITableViewDelegate,UITableViewDataSource>
@property(strong, nonatomic) UITableView *myTableView;
@end

@implementation DetailBrickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerClass:[MainDetailCell class] forCellReuseIdentifier:kCellIdentifier_MainDetailCell];
    [self.myTableView registerClass:[CommentCell class] forCellReuseIdentifier:kCellIdentifier_CommentCell];
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MainDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MainDetailCell forIndexPath:indexPath];
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0 hasSectionLine:NO];
        return cell;
    }else {
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CommentCell forIndexPath:indexPath];
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:60 hasSectionLine:NO];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? [MainDetailCell cellHeight] : [CommentCell cellHeight];
}



@end
