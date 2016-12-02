//
//  BMFeedBackViewController.m
//  BrickMan
//
//  Created by TobyoTenma on 12/11/2016.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import "BMFeedBackViewController.h"
#import <TencentOpenAPI/QQApiInterface.h>

@interface BMFeedBackViewController () {
    UIView *_topBgView;
    CAGradientLayer *_gradientLayer;
    UIView *_joinUsBgView;
    /** 加入 QQ 群按钮 */
    UIButton *_joinUsButton;
    /** navigationBar 的 shadowImage */
    UIImage *_navShadowImage;
}

@end

@implementation BMFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
//    [self setupUI];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kFeedBackUrl]];
    [webView loadRequest:request];
}

/*
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _gradientLayer.frame = _topBgView.bounds;
    
    _joinUsBgView.layer.cornerRadius = _joinUsBgView.height / 2;
    _joinUsBgView.layer.masksToBounds = YES;
    _joinUsButton.layer.cornerRadius = _joinUsButton.height / 2;
    _joinUsButton.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _navShadowImage = self.navigationController.navigationBar.shadowImage;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:kNavigationBarColor] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:_navShadowImage];
}

#pragma mark - UI
- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"反馈我们";
    
    // creat
    _topBgView = [[UIView alloc] init];
    _gradientLayer = [[CAGradientLayer alloc] init];
    UIImageView *redPackageImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red_package"]];
    _joinUsBgView = [[UIView alloc] init];
    _joinUsButton = [UIButton tta_buttonWithTitle:@"QQ群: 387655797" image:nil action:^(UIButton *button) {
            NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", kQQGroupAccount,kQQGroupKey];
            NSURL *url = [NSURL URLWithString:urlStr];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            } else {
                NSLog(@"%f", kScreen_Width);
                kTipAlert(@"您还未安装手机 QQ,请先安装手机 QQ!");
            }
    }];
    UILabel *tipLabel = [[UILabel alloc] init];
    
    // config
    [_topBgView.layer addSublayer:_gradientLayer];
    _gradientLayer.startPoint = CGPointMake(0, 0);
    _gradientLayer.endPoint = CGPointMake(0, 1);
    _gradientLayer.colors = @[(__bridge id)RGBCOLOR(253, 132, 65).CGColor, (__bridge id)RGBCOLOR(253, 186, 58).CGColor];
    _gradientLayer.locations = @[@0.5, @1.0];
    _joinUsBgView.backgroundColor = RGBCOLOR(244, 245, 246);
    _joinUsButton.contentMode = UIViewContentModeCenter;
    [_joinUsButton setBackgroundColor:kNavigationBarColor];
    [_joinUsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tipLabel.text = @"砖头人团队,等你来反馈!";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:20];
    
    // add
    [self.view addSubview:_topBgView];
    [_topBgView addSubview:redPackageImageView];
    [self.view addSubview:_joinUsBgView];
    [self.view addSubview:_joinUsButton];
    [self.view addSubview:tipLabel];
    
    // layout
    [_topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view);
        make.height.mas_equalTo(232 * SCALE);
    }];
    [redPackageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_topBgView.mas_centerX);
        make.centerY.mas_equalTo(_topBgView.mas_centerY).offset(20 * SCALE);
    }];
    
    [_joinUsBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(_topBgView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(216 * SCALE, 36 * SCALE));
    }];
    [_joinUsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(_joinUsBgView).offset(2 * SCALE);
        make.right.bottom.mas_equalTo(_joinUsBgView).offset(-2 * SCALE);
    }];
    
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(_joinUsBgView.mas_bottom).offset(12 * SCALE);
    }];
}
 */

@end
