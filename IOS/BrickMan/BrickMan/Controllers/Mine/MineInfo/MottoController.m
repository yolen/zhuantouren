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

@property (nonatomic, strong) UILabel *placeholder;

@end

@implementation MottoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)submitHeadImage:(UIBarButtonItem *)sender {
    if ([self.delegate respondsToSelector:@selector(saveMotto:)]) {
        [self.delegate saveMotto:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
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

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64)];
        _textView.font = [UIFont systemFontOfSize:17.f];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.delegate = self;
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

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text == nil || [textView.text isEqualToString:@""] ) {
        self.placeholder.alpha = 1.0;
    } else {
        self.placeholder.alpha = 0.f;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:self.textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
