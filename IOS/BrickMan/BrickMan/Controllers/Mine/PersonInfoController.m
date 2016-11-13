//
//  PersonInfoController.m
//  BrickMan
//
//  Created by 段永瑞 on 16/7/22.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "PersonInfoController.h"
#import "Mine_infoCell.h"
#import "HeadEditController.h"
#import "MottoController.h"
#import "ChangeUserInfoController.h"
#import "UITextField+Common.h"

#define kMinLength 2

@interface PersonInfoController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation PersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.rowHeight = [Mine_infoCell cellHeight];
    self.myTableView.tableFooterView = [UIView new];
    [self.myTableView registerClass:[Mine_infoCell class] forCellReuseIdentifier:kCellIdentifier_Mine_infoCell];
    [self.view addSubview:self.self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.user = [BMUser getUserModel];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Mine_infoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Mine_infoCell forIndexPath:indexPath];
    cell.titleLabel.text = self.titles[indexPath.row];
    if (indexPath.row == 0) {
        
        NSString *imagePath = self.user.userHead;
        [cell.subImgView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"icon"]];
        [cell.subLabel setHidden:YES];
        [cell.subImgView setHidden:NO];
    } else {
        if (indexPath.row == 1) {
            
            cell.subLabel.text = self.user.userAlias;
        }else if(indexPath.row == 2) {
            cell.subLabel.text = self.user.userSexStr;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else if (indexPath.row == 3) {
            cell.subLabel.text = self.user.motto.length > 0 ? self.user.motto : @"漂泊者的分享交流社区";
        }
        [cell.subLabel setHidden:NO];
        [cell.subImgView setHidden:YES];
    }
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeft];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
        case 0: { //更改头像
            HeadEditController *headEdit = [[HeadEditController alloc]init];
            headEdit.updateBlock = ^(NSString *value){
                weakSelf.user.userHead = value;
                [weakSelf.myTableView reloadData];
            };
            NSString *imagePath = self.user.userHead;
            [headEdit.headImgView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"icon"]];
            [self.navigationController pushViewController:headEdit animated:YES];
        }
            break;
        case 1: { //更改昵称
            ChangeUserInfoController *vc = [[ChangeUserInfoController alloc] init];
            __weak typeof(self) weakSelf = self;
            vc.updateBlock = ^(NSString *value){
                weakSelf.user.userAlias = value;
                [weakSelf.myTableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2: { //更改性别

        }
            break;
        case 3: { //更改座右铭
            MottoController *motto = [[MottoController alloc]init];
            motto.mottoString = self.user.motto.length > 0 ? self.user.motto : @"漂泊者的分享交流社区";
            motto.updateBlock = ^(NSString *value){
                weakSelf.user.motto = value;
                [weakSelf.myTableView reloadData];
            };
            [self.navigationController pushViewController:motto animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 懒加载
- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"我的头像",@"我的昵称",@"我的性别",@"座右铭"];
    }
    return _titles;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
