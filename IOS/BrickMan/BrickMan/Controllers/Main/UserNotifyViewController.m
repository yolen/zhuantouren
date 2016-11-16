//
//  UserNotifyViewController.m
//  BrickMan
//
//  Created by TZ on 2016/11/15.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "UserNotifyViewController.h"
#import "NotifyCell.h"
#import "Notify.h"
#import "DetailBrickViewController.h"

@interface UserNotifyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *myTableView;

@property (strong, nonatomic) NSArray *dataList;
@end

@implementation UserNotifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息";
    
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerClass:[NotifyCell class] forCellReuseIdentifier:kCellIdentifier_NotifyCell];
    self.myTableView.rowHeight = 60.0;
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self requestForUserNotify];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.myTableView reloadData];
}

- (void)requestForUserNotify {
    __weak typeof(self) weakSelf = self;
    [[BrickManAPIManager shareInstance] requestUserNotifyWithParams:nil andBlock:^(id data, NSError *error) {
        if (data) {
            weakSelf.dataList = data;
            [weakSelf.myTableView reloadData];
        }
    }];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotifyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_NotifyCell forIndexPath:indexPath];
    Notify *model = self.dataList[indexPath.row];
    [cell setContent:model.text withIsRead:model.isRead];
    
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Notify *model = self.dataList[indexPath.row];
    model.isRead = YES;
    
    DetailBrickViewController *detailVC = [[DetailBrickViewController alloc] init];
    detailVC.contentId = model.contentId;
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
