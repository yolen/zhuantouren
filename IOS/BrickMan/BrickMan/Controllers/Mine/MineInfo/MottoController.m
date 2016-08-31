//
//  MottoController.m
//  BrickMan
//
//  Created by 段永瑞 on 16/7/24.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "MottoController.h"
#import "PersonInfoController.h"

#define kMottoMaxLength 100

@interface MottoController ()<UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeholder;
@property (strong, nonatomic) BMUser *user;

@end

@implementation MottoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [BMUser getUserModel];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(submitHeadImage:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.placeholder.frame = CGRectMake(5, 7, kScreen_Width, 20);
    
    [self.view addSubview:self.textView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification" object:self.textView];
    [self.view addSubview:self.placeholder];
    if (self.textView.text == nil || [self.textView.text isEqualToString:@""]) {
        self.placeholder.alpha = 1.0;
    } else {
        self.placeholder.alpha = 0.f;
    }
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:self.textView];
}

#pragma mark - Submit
- (void)submitHeadImage:(UIBarButtonItem *)sender {
    NSString *userId = self.user.userId;
    __weak typeof(self) weakSelf = self;
    NSString *mottoString = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [[BrickManAPIManager shareInstance] requestUpdateUserInfoWithParams:@{@"userId" : userId, @"motto" : mottoString} andBlock:^(id data, NSError *error) {
        if (data) {
            //刷新数据
            [[BrickManAPIManager shareInstance] requestUserInfoWithParams:@{@"userId" : userId} andBlock:^(id data, NSError *error) {
                if (data) {
                    [BMUser saveUserInfo:data];
                }
            }];
            if (weakSelf.updateBlock) {
                weakSelf.updateBlock(weakSelf.textView.text);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshUserInfo object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [NSObject showErrorMsg:@"修改昵称失败"];
        }
    }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *textString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if (textString.length == 0 || [textString isEqualToString:self.mottoString]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    return YES;
}

- (void)textFiledEditChanged:(NSNotification *)notify {
    UITextField *textField = (UITextField *)notify.object;
    NSString *toBeString = textField.text;
    NSString *lang = [textField.textInputMode primaryLanguage]; // 键盘输入模式
    toBeString = [textField disable_emoji:toBeString];
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        if (toBeString.length > kMottoMaxLength) {
            textField.text = [toBeString substringToIndex:kMottoMaxLength];
        }
    }else if (toBeString.length > kMottoMaxLength) {
        textField.text = [toBeString substringToIndex:kMottoMaxLength];
    } else {
        textField.text = toBeString;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text == nil || [textView.text isEqualToString:@""] ) {
        self.placeholder.alpha = 1.0;
    } else {
        self.placeholder.alpha = 0.f;
    }
}

#pragma mark - 懒加载
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64)];
        _textView.font = [UIFont systemFontOfSize:17.f];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.text = self.mottoString;
    }
    return _textView;
}

- (UILabel *)placeholder {
    if (!_placeholder) {
        _placeholder = [[UILabel alloc] init];
        _placeholder.text = @"请输入您的座右铭...";
        _placeholder.enabled = NO;
    }
    return _placeholder;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
