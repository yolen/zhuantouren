//
//  MineViewController.m
//  BrickMan
//
//  Created by TZ on 16/7/18.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "MineViewController.h"
#import "PersonInfoController.h"
#import "GalleryController.h"
#import "BrickController.h"
#import "FlowerController.h"
#import "AboutController.h"
#import "RootTabBarController.h"
#import "BMFeedBackViewController.h"

#import "Mine_headerCell.h"
#import "Mine_titleCell.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@property (strong, nonatomic) UITableView *myTableView;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.myTableView registerClass:[Mine_headerCell class] forCellReuseIdentifier:kCellIdentifier_Mine_headerCell];
    [self.myTableView registerClass:[Mine_titleCell class] forCellReuseIdentifier:kCellIdentifier_Mine_titleCell];
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.myTableView.tableFooterView = [self customFooterView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kNotification_RefreshUserInfo object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)reloadData {
    [self.myTableView reloadData];
}

- (UIView *)customFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 80)];
    
    UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quitBtn.frame = CGRectMake(10, 20, kScreen_Width - 20, 35*SCALE);
    quitBtn.layer.cornerRadius = 3.0;
    quitBtn.layer.masksToBounds = YES;
    quitBtn.backgroundColor = kNavigationBarColor;
    [quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    quitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quitBtn addTarget:self action:@selector(doQuitAction) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:quitBtn];
    return footerView;
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : (section == 1 ? 3 : 3);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        Mine_headerCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Mine_headerCell forIndexPath:indexPath];
        BMUser *user = [BMUser getUserModel];
        [cell setUserIcon:user.userHead nameTitle:user.userAlias subTitle:user.motto.length > 0 ? user.motto : @"漂泊者的分享交流社区"];
        return cell;
    }else {
        Mine_titleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Mine_titleCell forIndexPath:indexPath];
        if (indexPath.section ==1) {
            switch (indexPath.row) {
                case 0:
                    [cell setIconImage:@"mine_icon" withTitle:@"我的砖集"];
                    break;
                case 1:
                    [cell setIconImage:@"brick_icon" withTitle:@"我的砖头"];
                    break;
                default:
                    [cell setIconImage:@"flower_icon" withTitle:@"我的鲜花"];
                    break;
            }
        }else {
            switch (indexPath.row) {
                case 0:
                    [cell setIconImage:@"feedback" withTitle:@"反馈我们"];
                    break;
                case 1:
                    [cell setIconImage:@"del_cache" withTitle:@"清除缓存"];
                    cell.content = [self getSDImageCacheSize];
                    break;
                default:
                    [cell setIconImage:@"about_icon" withTitle:@"关于我们"];
                    break;
            }
        }
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeft hasSectionLine:NO];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = indexPath.section == 0 ? [Mine_headerCell cellHeight] : [Mine_titleCell cellHeight];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = kViewBGColor;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BaseViewController *viewController = nil;
    switch (indexPath.section) {
        case 0:{
            viewController = [[PersonInfoController alloc]init];
        }
            break;
        case 1:{
            switch (indexPath.row) {
                case 0: {
                    GalleryController *gallery = [[GalleryController alloc] init];
                    viewController = gallery;
                }
                    break;
                case 1: {
                    BrickController *brick = [[BrickController alloc]init];
                    viewController = brick;
                }
                    break;
                case 2: {
                    FlowerController *flower = [[FlowerController alloc]init];
                    viewController = flower;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:{
            switch (indexPath.row) {
                case 0: {
                    BMFeedBackViewController *feedbackVc = [[BMFeedBackViewController alloc] init];
                    viewController = feedbackVc;
                }
                    break;
                case 1: {
                    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"是否清除缓存" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    sheet.tag = 1002;
                    [sheet showInView:self.view];
                }
                    break;
                default:{
                    AboutController *about = [[AboutController alloc]init];
                    viewController = about;
                }
                    break;
            }
        }
            break;
        default:
            break;
    }
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - Action
- (void)doQuitAction {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"是否退出登录" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil, nil];
    sheet.tag = 1001;
    [sheet showInView:self.view];
}

- (NSString *)getSDImageCacheSize {
    CGFloat tmpSize = [[SDImageCache sharedImageCache] getSize];
    return [NSString stringWithFormat:@"%.1fM",tmpSize/1024/1024];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (actionSheet.tag == 1001) {
            [BMUser removeUserInfo];
            RootTabBarController *tabBarVC = [RootTabBarController sharedInstance];
            tabBarVC.selectedIndex = 0;
            [tabBarVC.myTabBar changeTabBarToIndex:0];
            [NSObject showSuccessMsg:@"退出成功"];
        }else if(actionSheet.tag == 1002) {
            [NSObject showHUDQueryStr:@"正在清除缓存..."];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                    [NSObject hideHUDQuery];
                    [NSObject showHudTipStr:@"清除缓存成功"];
                    [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationFade];
                }];
            });
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
