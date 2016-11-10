//
//  EditLocationViewController.m
//  BrickMan
//
//  Created by TZ on 2016/9/26.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "EditLocationViewController.h"

@interface EditLocationViewController()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong, nonatomic)UITextField *myTextField;

@end

@implementation EditLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑地址";
    
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
    self.myTextField.text = self.locationStr;
    self.myTextField.placeholder = @"请编辑地址";
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
    if (textString.length == 0 || [textString isEqualToString:self.locationStr]) {
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

- (void)saveAction:(id)sender {
    NSString *locationString = self.myTextField.text;
    if (locationString.length > 20) {
        [NSObject showErrorMsg:@"超过最大长度"];
        return;
    }
    
    if (self.updateStringBlock) {
        self.updateStringBlock(locationString);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
