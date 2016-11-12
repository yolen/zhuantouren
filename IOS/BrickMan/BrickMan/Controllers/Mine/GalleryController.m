//
//  GalleryController.m
//  BrickMan
//
//  Created by 段永瑞 on 16/7/22.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "GalleryController.h"
#import "DetailBrickViewController.h"
#import "MainTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "BMGalleryTableHeaderView.h"
#import "BMContent.h"

#define kHEAD_RADIO 800.0 / 1242.0
#define kHEAD_HEIGHT kHEAD_RADIO * kScreen_Width

@interface GalleryController ()<UITableViewDataSource,UITableViewDelegate> {
    /** UINavigationBar 的shadowImage */
    UIImage *_navShadowImage;
    BMGalleryTableHeaderView *_headerView;
}
@property (nonatomic, strong) UITableView *myTableView;
@property (strong, nonatomic) BMContentList *contentList;

@end

@implementation GalleryController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    __weak typeof(self) weakSelf = self;
    
    self.contentList = [[BMContentList alloc] init];
    self.contentList.userID = self.model ? self.model.userId : [BMUser getUserModel].userId; // 设置获取砖集列表时所用的 用户id
    
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerClass:[MainTableViewCell class] forCellReuseIdentifier:kCellIdentifier_MainTableViewCell];
    self.myTableView.contentInset = UIEdgeInsetsMake(kHEAD_HEIGHT, 0, 0, 0);
    self.myTableView.scrollIndicatorInsets = UIEdgeInsetsMake(kHEAD_HEIGHT, 0, 0, 0);
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
    _headerView = [[BMGalleryTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kHEAD_HEIGHT)];
    _headerView.popGalleryBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    [self.view addSubview:_headerView];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMore)];
    [self refresh];
//    [self requestUserInfo];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    [[BrickManAPIManager shareInstance] requestUserContentListWithObj:self.contentList andBlock:^(id data, NSError *error) {
        [weakSelf.myTableView.mj_header endRefreshing];
        [weakSelf.myTableView.mj_footer endRefreshing];
        if (data) {
            [weakSelf.contentList configWithData:data];
            [weakSelf.myTableView reloadData];
            BMContentList *model = (BMContentList *)data;
            if (!weakSelf.contentList.canLoadMore || model.data.count == 0) {
                [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [weakSelf.myTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }];
}

- (void)requestUserInfo {
    //刷新数据
    [[BrickManAPIManager shareInstance] requestUserInfoWithParams:@{@"userId" : self.model.userId} andBlock:^(id data, NSError *error) {
        if (data) {
            [_headerView configHeaderViewWithUser: [BMUser getUserModel]];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentList.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MainTableViewCell forIndexPath:indexPath];
    cell.model = self.contentList.data[indexPath.row];
    //判断在我的砖集状态下,cell的四个按钮不可点击
    [cell setIsGallery:YES];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailBrickViewController *vc = [[DetailBrickViewController alloc] init];
    vc.comeFromGallery = YES; // 标记下一个详情页面是由`砖集`页面来的,将不能再次显示`砖集`页面
    vc.model = self.contentList.data[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMContent *model = self.contentList.data[indexPath.row];
    return [MainTableViewCell cellHeightWithModel:model];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat offset = offsetY + kHEAD_HEIGHT;

    if (offset < 0) { // 放大
        _headerView.y = 0;
        _headerView.height = kHEAD_HEIGHT - offset;
        self.myTableView.scrollIndicatorInsets = UIEdgeInsetsMake(-offsetY, 0, 0, 0);
    } else { // 移动
        _headerView.height = kHEAD_HEIGHT;
        CGFloat min = kHEAD_HEIGHT - 64;
        _headerView.y = -MIN(offset, min);
    }
    [_headerView configItemsWith:offset];
}


@end
