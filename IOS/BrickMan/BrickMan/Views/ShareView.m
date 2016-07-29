//
//  ShareView.m
//  BrickMan
//
//  Created by TZ on 16/7/27.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "ShareView.h"

@interface ShareView()
@property (strong, nonatomic) UIView *bgView, *contentView;
@property (strong, nonatomic) UILabel *titleL;

@property (strong, nonatomic) NSArray *shareSnsValues;
@end

@implementation ShareView

+ (instancetype)sharedInstance {
    static ShareView* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ShareView new];
    });
    
    return instance;
}

+ (ShareView *)showShareView {
    ShareView *share_view = [self sharedInstance];
    [share_view p_show];
    return share_view;
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = kScreen_Bounds;
        
        if (!_bgView) {
            _bgView = [[UIView alloc] initWithFrame:kScreen_Bounds];
            _bgView.backgroundColor = [UIColor blackColor];
            _bgView.alpha = 0;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(p_dismiss)];
            [_bgView addGestureRecognizer:tap];
            [self addSubview:_bgView];
        }
        
        if(!_contentView) {
            _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 200)];
            _contentView.backgroundColor = [UIColor whiteColor];
            
            UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width/2 - 0.25, 10, 0.5, 60)];
            separatorView.backgroundColor = kLineColor;
            [_contentView addSubview:separatorView];
            
            UIView *separatorView2 = [[UIView alloc] initWithFrame:CGRectMake(0, separatorView.bottom + 10, kScreen_Width, 0.5)];
            separatorView2.backgroundColor = kLineColor;
            [_contentView addSubview:separatorView2];
            
            UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelBtn.frame = CGRectMake(0, separatorView2.bottom, kScreen_Width, 40);
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [cancelBtn addTarget:self action:@selector(p_dismiss) forControlEvents:UIControlEventTouchUpInside];
            [_contentView addSubview:cancelBtn];
            
            [_contentView setY:kScreen_Height];
            [self addSubview:_contentView];
        }
    }
    return self;
}

#pragma mark - show and hidden
- (void)p_show {
    [self checkShareSnsValues];
    [kKeyWindow addSubview:self];
    
    CGPoint endCenter = self.contentView.center;
    endCenter.y -= CGRectGetHeight(self.contentView.frame);
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.alpha = 0.3;
        self.contentView.center = endCenter;
    } completion:nil];
}

- (void)p_dismiss {
    CGPoint endCenter = self.contentView.center;
    endCenter.y += CGRectGetHeight(self.contentView.frame);
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.alpha = 0.0;
        self.contentView.center = endCenter;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dismissWithCompletionBlock:(void (^)(void))completionBlock {
    CGPoint endCenter = self.contentView.center;
    endCenter.y += CGRectGetHeight(self.contentView.frame);
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.alpha = 0.0;
        self.contentView.center = endCenter;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (completionBlock) {
            completionBlock();
        }
    }];
}

#pragma mark -
- (void)checkShareSnsValues {
    self.shareSnsValues = [ShareView supportSnsValues];
}

+(NSArray *)supportSnsValues{
    NSMutableArray *resultSnsValues = [@[
                                         @"qq",
                                         @"wxtimeline",
                                         ] mutableCopy];
    return resultSnsValues;
}

- (void)setShareSnsValues:(NSArray *)shareSnsValues {
    if (![_shareSnsValues isEqualToArray:shareSnsValues]) {
        _shareSnsValues = shareSnsValues;
        for (int index = 0; index < _shareSnsValues.count; index++) {
            NSString *snsName = _shareSnsValues[index];
            ShareView_Item *item = [ShareView_Item itemWithSnsName:snsName];
            CGPoint pointO = CGPointZero;
            pointO.x = (kScreen_Width/2 - [ShareView_Item itemWidth])/2 + kScreen_Width/2*index;
            pointO.y = 0.0;
            [item setOrigin:pointO];
            item.clickedBlock = ^(NSString *snsName){
                [self shareItemClickedWithSnsName:snsName];
            };
            [_contentView addSubview:item];
        }
        CGFloat contentHeight = ((_shareSnsValues.count - 1)/2 + 1)*[ShareView_Item itemHeight] + 60;
        [self.contentView setSize:CGSizeMake(kScreen_Width, contentHeight)];
    }
}

- (void)shareItemClickedWithSnsName:(NSString *)snsName {
    void(^completion)()=^(){
        [self doShareToSnsName:snsName];
    };
    [self dismissWithCompletionBlock:completion];
}
- (void)doShareToSnsName:(NSString *)snsName {
    
}

@end
/////////////////////////////////////////////////

@interface ShareView_Item ()
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UILabel *titleL;
@end

@implementation ShareView_Item

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, [ShareView_Item itemWidth], [ShareView_Item itemHeight]);
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0, 0, [ShareView_Item itemWidth], [ShareView_Item itemWidth]);
        [_button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, _button.bottom, [ShareView_Item itemWidth], 15)];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.font = [UIFont systemFontOfSize:12];
        _titleL.textColor = [UIColor colorWithHexString:@"0x666666"];
        [self addSubview:_titleL];
    }
    return self;
}

- (void)buttonClicked {
    if (self.clickedBlock) {
        self.clickedBlock(_snsName);
    }
}

- (void)setSnsName:(NSString *)snsName {
    if (![_snsName isEqualToString:snsName]) {
        _snsName = snsName;
        NSString *imageName = [NSString stringWithFormat:@"share_%@", snsName];
        NSString *title = [[ShareView_Item snsNameDict] objectForKey:snsName];
        [_button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        _titleL.text = title;
    }
}

+ (instancetype)itemWithSnsName:(NSString *)snsName{
    ShareView_Item *item = [self new];
    item.snsName = snsName;
    return item;
}

+ (CGFloat)itemWidth{
    return 60.0;
}

+ (CGFloat)itemHeight{
    return 60.0;
}

+ (NSDictionary *)snsNameDict{
    static NSDictionary *snsNameDict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        snsNameDict = @{
                        @"qq": @"QQ",
                        @"wxtimeline": @"微信",
                        };
    });
    return snsNameDict;
}

@end

