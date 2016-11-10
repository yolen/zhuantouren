//
//  ShareView.m
//  BrickMan
//
//  Created by TZ on 16/7/27.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kShareView_NumPerLine 4
#import "ShareView.h"
#import "UMSocialData.h"
#import "BMAttachment.h"
#import "UMSocialSnsPlatformManager.h"

@interface ShareView()<UMSocialUIDelegate>
@property (strong, nonatomic) UIView *bgView, *contentView;
@property (strong, nonatomic) UILabel *titleL;

@property (strong, nonatomic) NSArray *shareSnsValues;
@property (strong, nonatomic) BMContent *content;
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

+ (ShareView *)showShareViewWithContent:(BMContent *)content {
    ShareView *share_view = [self sharedInstance];
    share_view.content = content;
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
            _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 150)];
            _contentView.backgroundColor = [UIColor whiteColor];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreen_Width, 20)];
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = @"分享到";
            [_contentView addSubview:titleLabel];
            
            
            UIView *separatorView = [[UIView alloc] init];
            separatorView.backgroundColor = kLineColor;
            [_contentView addSubview:separatorView];
            
            UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [cancelBtn addTarget:self action:@selector(p_dismiss) forControlEvents:UIControlEventTouchUpInside];
            [_contentView addSubview:cancelBtn];
            
            [_contentView setY:kScreen_Height];
            [self addSubview:_contentView];
            
            [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_contentView);
                make.right.equalTo(_contentView);
                make.bottom.equalTo(_contentView);
                make.height.mas_equalTo(40);
            }];
            [separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(cancelBtn.mas_top);
                make.left.right.equalTo(_contentView);
                make.height.equalTo(0.5);
            }];
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
                                         @"qzone",
                                         @"wxsession",
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
            pointO.x = [ShareView_Item itemWidth] * (index%kShareView_NumPerLine);
            pointO.y = [ShareView_Item itemHeight] * (index/kShareView_NumPerLine) + 40;
            [item setOrigin:pointO];
            item.clickedBlock = ^(NSString *snsName){
                [self shareItemClickedWithSnsName:snsName];
            };
            [_contentView addSubview:item];
        }
        CGFloat contentHeight = [ShareView_Item itemHeight] + 80;
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
    NSString *title = @"砖头人app";
    NSString *shareText = self.content.contentTitle;
    BMAttachment *attachment = self.content.brickContentAttachmentList.firstObject;
    NSString *shareUrl = [NSString stringWithFormat:@"%@/index.html?contentId=%@",kBaseUrl,attachment.contentId];
    UIImage *shareImage = [UIImage imageNamed:@"icon"];
    [UMSocialData defaultData].extConfig.yxtimelineData.yxMessageType = UMSocialYXMessageTypeApp;
    if ([snsName isEqualToString:@"qq"]) {
        [UMSocialData defaultData].extConfig.qqData.title = title;
        [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
    }else if ([snsName isEqualToString:@"qzone"]) {
        [UMSocialData defaultData].extConfig.qzoneData.title = title;
        [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
    }else if([snsName isEqualToString:@"wxsession"]) {
        [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
    }else if ([snsName isEqualToString:@"wxtimeline"]) {
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareText;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
    }

    [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:shareImage socialUIDelegate:self];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:snsName];
    snsPlatform.snsClickHandler(nil,[UMSocialControllerService defaultControllerService],YES);
}

#pragma mark - UMSocialUIDelegate
- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
    if ((response.responseCode == UMSResponseCodeSuccess)) {
        [NSObject showSuccessMsg:@"分享成功"];
        if (self.successShareBlock) {
            self.successShareBlock();
        }
    }else {
        [NSObject showErrorMsg:@"分享失败"];
    }
}

- (BOOL)isDirectShareInIconActionSheet{
    return YES;
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
        CGFloat padding_button = kScaleFrom_iPhone5_Desgin(15);
        _button.frame = CGRectMake(padding_button, 0, [ShareView_Item itemWidth] - 2*padding_button, [ShareView_Item itemWidth] - 2*padding_button);
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
    return kScreen_Width/kShareView_NumPerLine;
}

+ (CGFloat)itemHeight{
    return [self itemWidth];
}

+ (NSDictionary *)snsNameDict{
    static NSDictionary *snsNameDict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        snsNameDict = @{
                        @"qq" : @"QQ",
                        @"qzone" : @"QQ空间",
                        @"wxtimeline" : @"朋友圈",
                        @"wxsession" : @"微信好友",
                        };
    });
    return snsNameDict;
}

@end

