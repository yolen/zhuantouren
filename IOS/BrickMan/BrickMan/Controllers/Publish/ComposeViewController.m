//
//  ComposeViewController.m
//  BrickMan
//
//  Created by TobyoTenma on 7/21/16.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import "ComposeViewController.h"

@interface ComposeViewController ()
/**
 *  返回 Home
 */
@property (nonatomic, strong) UIButton *returnHomeButton;

/**
 *  发布按钮
 */
@property (nonatomic, strong) UIButton *composeButton;

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *placeHolderLabel;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - UI
- (void)setupUI {
    [self setupNavigationBar];
    [self setupTextPartView];
}
/**
 *  设置 nabigationBar
 */
- (void)setupNavigationBar {
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.returnHomeButton setImage:[UIImage imageNamed:@"back_arrow"]
                           forState:UIControlStateNormal];
    UIBarButtonItem *returnItem = [[UIBarButtonItem alloc] initWithCustomView:self.returnHomeButton];
    self.navigationItem.leftBarButtonItem = returnItem;
    [self.returnHomeButton sizeToFit];

    [self.composeButton setBackgroundImage:[UIImage imageNamed:@"compose"]
                                  forState:UIControlStateNormal];
    UIBarButtonItem *composeItem = [[UIBarButtonItem alloc] initWithCustomView:self.composeButton];
    self.navigationItem.rightBarButtonItem = composeItem;
    [self.composeButton sizeToFit];

    self.title = @"Compose";
}

/**
 *  文字输入 View
 */
-(void)setupTextPartView{
    // 添加
    [self.view addSubview:self.textView];
    [self.textView addSubview:self.placeHolderLabel];
    // 配置
    self.textView.text = @"你看见的,就是我想知道的...";
    // 布局
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(150);
    }];

    [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.textView);
    }];
}

/**
 *  设置图片选择器
 */
-(void)setupPictureView{

}


#pragma mark - Actions
- (void)returnHomeButtonAction {
    // TODO: 回到 Home
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)composeButtonAction {
    // TODO: 发布
    DebugLog (@"%s", __FUNCTION__);
}


#pragma mark - lazy loading
- (UIButton *)returnHomeButton {
    if (_returnHomeButton == nil) {
        _returnHomeButton = [[UIButton alloc] init];
        [_returnHomeButton addTarget:self
                              action:@selector (returnHomeButtonAction)
                    forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnHomeButton;
}

- (UIButton *)composeButton {
    if (_composeButton == nil) {
        _composeButton = [[UIButton alloc] init];
        [_composeButton addTarget:self
                           action:@selector (composeButtonAction)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _composeButton;
}

-(UITextView *)textView{
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
    }
    return _textView;
}

-(UILabel *)placeHolderLabel{
    if (_placeHolderLabel == nil) {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.text = @"你看见的,就是我想知道的...";
        _placeHolderLabel.textColor = [UIColor darkGrayColor];
    }
    return _placeHolderLabel;
}


@end
