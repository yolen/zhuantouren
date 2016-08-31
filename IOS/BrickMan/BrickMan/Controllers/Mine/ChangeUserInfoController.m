//
//  ChangeUserInfoController.m
//  BrickMan
//
//  Created by TZ on 16/8/26.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "ChangeUserInfoController.h"

@interface ChangeUserInfoController()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic)UITextField *myTextField;
@property (strong, nonatomic) BMUser *user;

@end

@implementation ChangeUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [BMUser getUserModel];
    
    UITableView *myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.backgroundColor = kViewBGColor;
    myTableView.delegate = self;
    myTableView.rowHeight = 44;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.tableFooterView = [UIView new];
    [self.view addSubview:myTableView];
    [myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveAction:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    self.myTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width - 10*2, 44)];
    self.myTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.myTextField.backgroundColor = [UIColor clearColor];
    self.myTextField.delegate = self;
    self.myTextField.text = self.user.userAlias;
    self.myTextField.placeholder = @"请输入昵称";
    [cell.contentView addSubview:_myTextField];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerV = [UIView new];
    headerV.backgroundColor = [UIColor clearColor];
    return headerV;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *textString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textString.length == 0 || [textString isEqualToString:self.user.userAlias]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    return YES;
}

#pragma mark - Action
- (void)saveAction:(id)sender {
    if (self.myTextField.text.length > 10) {
        [NSObject showErrorMsg:@"昵称过长"];
        return;
    }
    
    NSString *userId = self.user.userId;
    __weak typeof(self) weakSelf = self;
    NSString *nickName = [self.myTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [[BrickManAPIManager shareInstance] requestUpdateUserInfoWithParams:@{@"userId" : userId, @"userAlias" : nickName} andBlock:^(id data, NSError *error) {
        if (data) {
            //刷新数据
            [[BrickManAPIManager shareInstance] requestUserInfoWithParams:@{@"userId" : userId} andBlock:^(id data, NSError *error) {
                if (data) {
                    [BMUser saveUserInfo:data];
                }
            }];
            if (weakSelf.updateBlock) {
                weakSelf.updateBlock(weakSelf.myTextField.text);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshUserInfo object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [NSObject showErrorMsg:@"修改昵称失败"];
        }
    }];

}

@end
