//
//  CommentInputView.m
//  BrickMan
//
//  Created by TZ on 16/7/27.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "CommentInputView.h"

@interface CommentInputView ()
@property (strong, nonatomic) NSString *placeHolder;
@property (strong, nonatomic) UIButton *sendBtn;
@property (assign, nonatomic) CGFloat oldTextViewHeight;

@end

@implementation CommentInputView

+ (CommentInputView *)getInputView {
    CommentInputView *inputView = [[CommentInputView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 114, kScreen_Width, 50)];
    return inputView;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
        _oldTextViewHeight = 33;
        
        if (!_inputTextView) {
            _inputTextView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake(10, 10, kScreen_Width - 80, 30)];
            _inputTextView.font = [UIFont systemFontOfSize:14];
            _inputTextView.returnKeyType = UIReturnKeySend;
            _inputTextView.scrollsToTop = NO;
            _inputTextView.placeholder = @"你怎么看?";
            [self addSubview:_inputTextView];
        }
        if (!_sendBtn) {
            _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _sendBtn.frame = CGRectMake(_inputTextView.right + 10, 10, 50, 30);
            _sendBtn.backgroundColor = kNavigationBarColor;
            _sendBtn.layer.cornerRadius = 3.0;
            _sendBtn.layer.masksToBounds = YES;
            [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
            [_sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_sendBtn];
        }
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    CGFloat oldheightToBottom = kScreen_Height - CGRectGetMinY(self.frame);
    CGFloat newheightToBottom = kScreen_Height - CGRectGetMinY(frame);
    
    [super setFrame:frame];
    if (fabs(oldheightToBottom - newheightToBottom) > 0.1) {
        if (self.updateInputViewHeight) {
            self.updateInputViewHeight(newheightToBottom);
        }
    }
}

- (void)sendAction:(id)sender {
    [self.inputTextView resignFirstResponder];
    
    if (self.sendCommentBlock) {
        self.sendCommentBlock();
    }
}

#pragma mark - Show Or Hidden
- (void)p_show {
    if ([self superview] == kKeyWindow) {
        return;
    }
    [self setY:kScreen_Height];
    [kKeyWindow addSubview:self];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    if (![self.inputTextView isFirstResponder]) {
        [UIView animateWithDuration:0.25 animations:^{
            [self setY:kScreen_Height - CGRectGetHeight(self.frame)];
        }];
    }
}

- (void)p_dismiss {
    if ([self superview] == nil) {
        return;
    }
    if ([self.inputTextView isFirstResponder]) {
        [self.inputTextView resignFirstResponder];
    }
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        [self setY:kScreen_Height];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)resignCommentInputViewWithCompletion:(void (^ __nullable)(BOOL finished))complection {
    self.inputTextView.text = nil;
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        self.inputTextView.height = 30;
        self.frame = CGRectMake(0, kScreen_Height - 114, kScreen_Width, 50);
    } completion:complection];
}


@end
