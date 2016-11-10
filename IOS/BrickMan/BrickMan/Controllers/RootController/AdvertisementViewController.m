//
//  AdvertisementViewController.m
//  BrickMan
//
//  Created by TZ on 16/9/2.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "AdvertisementViewController.h"
#import "Advertisement.h"
#import <MJRefresh/MJRefresh.h>
#import "YYModel.h"
#import "LoginViewController.h"

@interface AdvertisementViewController()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *myTableView;

@property (strong, nonatomic) NSArray *adverArray;
@end

@implementation AdvertisementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"广告";
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestForAdvertisement)];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.myTableView.mj_header = header;
    
    [self requestForAdvertisement];
}

- (void)requestForAdvertisement {
    __weak typeof(self) weakSelf = self;
    [[BrickManAPIManager shareInstance] requestAdvertisementWithParams:@{@"advertisementType" : @"4"} andBlock:^(id data, NSError *error) {
        [weakSelf.myTableView.mj_header endRefreshing];
        if (data) {
            self.adverArray = [NSArray yy_modelArrayWithClass:[Advertisement class] json:data];
            [weakSelf.myTableView reloadData];
        }
    }];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.adverArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width - 20, 150*SCALE)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.tag = 100;
        [cell.contentView addSubview:imageView];
    }
    UIImageView *view = (UIImageView *)[cell viewWithTag:100];
    Advertisement *adv = self.adverArray[indexPath.row];
    [view sd_setImageWithURL:[NSURL URLWithString:adv.advertisementUrl] placeholderImage:nil];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160*SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = kViewBGColor;
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:14];
    title.text = @"公益,一起关注社会,关注自然";
    [view addSubview:title];
    return view;
}

- (void)pushLoginViewController {
    LoginViewController *vc = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
