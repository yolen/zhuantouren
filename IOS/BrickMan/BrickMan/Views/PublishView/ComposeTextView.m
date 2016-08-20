//
//  ComposeTextView.m
//  BrickMan
//
//  Created by TobyoTenma on 7/22/16.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import "ComposeTextView.h"

@interface ComposeTextView () <UITextViewDelegate>

/**
 *  文本输入框
 */
@property (nonatomic, strong) UITextView *textView;
/**
 *  文本输入框占位提示 label
 */
@property (nonatomic, strong) UILabel *placeHolderLabel;

@end

@implementation ComposeTextView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (NSString *)text {
    return self.textView.text;
}

#pragma mark - Setup UI
-(void)setupUI {
    [self setupTextPartView];
}

/**
 *  文字输入 View
 */
-(void)setupTextPartView{
    // 添加
    [self addSubview:self.textView];
    [self.textView addSubview:self.placeHolderLabel];
    // 配置
    // 布局
    self.textView.frame = self.bounds;

    [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView).offset(8);
        make.left.equalTo(self.textView).offset(5);
    }];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        self.placeHolderLabel.hidden = YES;
    }
}


#pragma mark - lazy loading
-(UITextView *)textView{
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.font = COMPOSE_TEXT_FONT_SIZE;
        _textView.delegate = self;
    }
    return _textView;
}

-(UILabel *)placeHolderLabel{
    if (_placeHolderLabel == nil) {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.text = @"你看见的,就是我想知道的...";
        _placeHolderLabel.font = COMPOSE_TEXT_FONT_SIZE;
        _placeHolderLabel.textColor = [UIColor lightGrayColor];
    }
    return _placeHolderLabel;
}

@end
