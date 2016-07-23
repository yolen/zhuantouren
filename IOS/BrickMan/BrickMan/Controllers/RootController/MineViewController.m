//
//  MineViewController.m
//  BrickMan
//
//  Created by TZ on 16/7/18.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "MineViewController.h"
#import "Mine_headerCell.h"
#import "Mine_titleCell.h"
#import "PersonInfoController.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>
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
}

- (UIView *)customFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 100)];
    
    UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quitBtn.frame = CGRectMake(10, 30, kScreen_Width - 20, 35);
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
    return section == 0 ? 1 : (section == 1 ? 3 : 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        Mine_headerCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Mine_headerCell forIndexPath:indexPath];
        [cell setUserIcon:@"user_icon" nameTitle:@"砖头人" subTitle:@"路见不平,拍砖相助!"];
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
            [cell setIconImage:@"about_icon" withTitle:@"关于我们"];
        }
        [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeft hasSectionLine:NO];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? [Mine_headerCell cellHeight] : [Mine_titleCell cellHeight];
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
    switch (indexPath.section) {
        case 0:{
            PersonInfoController *personInfo = [[PersonInfoController alloc]init];
            [self.navigationController pushViewController:personInfo animated:YES];
        }
            break;
        case 1:{
            switch (indexPath.row) {
                case 0: {
                    
                }
                    break;
                case 1: {
                    
                }
                    break;
                case 2: {
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:{
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - Btn Action
- (void)doQuitAction {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
