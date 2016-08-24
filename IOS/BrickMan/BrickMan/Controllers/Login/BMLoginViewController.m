//
//  BMLoginViewController.m
//  BrickMan
//
//  Created by TobyoTenma on 7/28/16.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import "BMLoginViewController.h"
#import "MainViewController.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "BrickManNetClient.h"
#import "BMUser.h"

#define LOGIN_HEADER_TEXT @"砖头人"
#define LOGIN_TIP_TEXT @"左手鲜花,右手砖头的一群人\n只评论事儿,不评价人儿"

#define GO_AROUND_BUTTON_TITLE @"先随便看看"
#define LOGIN_TIP_TITLE @"社交帐号登录"


@interface BMLoginViewController () <TencentSessionDelegate>

@property (nonatomic, strong) UIButton *goAroundButton;
@property (nonatomic, strong) UIButton *weChatLoginButton;
@property (nonatomic, strong) UIButton *qqLoginButton;

#pragma mark - QQ Login Propreties
@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@end

@implementation BMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    // 添加
    UIImageView *imageView =
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginbackground"]];
    [self.view addSubview:imageView];

    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    [self.view addSubview:logoImageView];

    UILabel *headerLabel = [[UILabel alloc] init];
    [self.view addSubview:headerLabel];

    UILabel *tipLabel = [[UILabel alloc] init];
    [self.view addSubview:tipLabel];

    UIView *lineView = [[UIView alloc] init];
    [self.view addSubview:lineView];

    UILabel *loginTipLabel = [[UILabel alloc] init];
    [self.view addSubview:loginTipLabel];

    UIView *goAroundBgView = [[UIView alloc] init];
    [self.view addSubview:goAroundBgView];

    [goAroundBgView addSubview:self.goAroundButton];
    [self.view addSubview:self.weChatLoginButton];
    [self.view addSubview:self.qqLoginButton];

    // 配置
    headerLabel.text        = LOGIN_HEADER_TEXT;
    headerLabel.font        = [UIFont boldSystemFontOfSize:20];
    headerLabel.textColor   = [UIColor whiteColor];
    headerLabel.contentMode = UIViewContentModeCenter;

    tipLabel.text          = LOGIN_TIP_TEXT;
    tipLabel.numberOfLines = 0;
    tipLabel.textColor     = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;

    lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];

    loginTipLabel.text            = LOGIN_TIP_TITLE;
    loginTipLabel.textAlignment   = NSTextAlignmentCenter;
    loginTipLabel.backgroundColor = [UIColor whiteColor];

    goAroundBgView.backgroundColor     = [UIColor whiteColor];
    goAroundBgView.layer.cornerRadius  = 22;
    goAroundBgView.layer.masksToBounds = YES;

    // 布局
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo (self.view);
    }];

    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (kScreen_Height / 8);
        make.centerX.equalTo (self.view.mas_centerX);
    }];

    [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo (self.view.mas_centerX);
        make.top.equalTo (logoImageView.mas_bottom).offset (20);
    }];

    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo (self.view.mas_centerY).offset (-20);
        make.centerX.equalTo (headerLabel.mas_centerX);
    }];

    [goAroundBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo (self.view.mas_centerX);
        make.bottom.equalTo (imageView.mas_bottom).offset (-30);
        make.height.equalTo (self.goAroundButton.mas_height).offset (10);
        make.width.equalTo (self.goAroundButton.mas_width).offset (60);
    }];

    [self.goAroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo (goAroundBgView).offset (-10);
        make.centerY.equalTo (goAroundBgView);
    }];

    [loginTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo (self.view.mas_centerX);
        make.top.equalTo (imageView.mas_bottom).offset (30);
        make.width.offset (150);
    }];

    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo (loginTipLabel);
        make.width.equalTo (self.view);
        make.height.equalTo (1);
    }];

    [self.weChatLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo (self.view.mas_centerX).offset (-kScreen_Width / 4);
        make.bottom.equalTo (self.view.mas_bottom).offset (-kScreen_Height / 20);
    }];

    [self.qqLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo (self.view.mas_centerX).offset (kScreen_Width / 4);
        make.top.equalTo (self.weChatLoginButton);
    }];
}

#pragma mark - QQ Login
- (void)loginWithQQ {
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_LOGIN_APP_ID andDelegate:self];
    // 设置权限//TODO:  qq 登录权限可以精简
    NSArray *permissions =[NSArray arrayWithObjects:kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];;
    [self.tencentOAuth authorize:permissions inSafari:NO];
}

#pragma mark - Actions
- (void)didClickGoAroundButton:(UIButton *)button {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didClickWeChatLoginButton:(UIButton *)button {
    NSLog (@"%s", __FUNCTION__);
}

- (void)didClickQQLoginButton:(UIButton *)button {
    [self loginWithQQ];
}

#pragma mark - TencentSessionDelegate
- (void)tencentDidLogin {
    [[BrickManAPIManager shareInstance] requestAuthLoginWithParams:@{@"thirdAuth" : @"qq", @"accessToken" : self.tencentOAuth.accessToken, @"openId" : self.tencentOAuth.openId} andBlock:^(id data, NSError *error) {
        if (data) {
            //缓存用户信息
            [BMUser saveUserInfo:data];
            [[BrickManNetClient sharedJsonClient] setToken:data[@"token"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    UIAlertController *alert = [UIAlertController errorAlertWithMessage:@"登录失败"];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)tencentDidNotNetWork {
    
}


#pragma mark - lazy loading
- (UIButton *)goAroundButton {
    if (_goAroundButton == nil) {
        _goAroundButton = [[UIButton alloc] init];
        [_goAroundButton setTitle:GO_AROUND_BUTTON_TITLE forState:UIControlStateNormal];
        UIImage *rightArrow = [UIImage imageNamed:@"right_arrow"];
        [_goAroundButton setImage:rightArrow forState:UIControlStateNormal];
        [_goAroundButton setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
        [_goAroundButton setTitleEdgeInsets:UIEdgeInsetsMake (0, -20, 0, 0)];
        [_goAroundButton setImageEdgeInsets:UIEdgeInsetsMake (10, 130, 10, 0)];
        [_goAroundButton addTarget:self
                            action:@selector (didClickGoAroundButton:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _goAroundButton;
}

- (UIButton *)weChatLoginButton {
    if (_weChatLoginButton == nil) {
        _weChatLoginButton = [[UIButton alloc] init];
        [_weChatLoginButton setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
        [_weChatLoginButton addTarget:self
                               action:@selector (didClickWeChatLoginButton:)
                     forControlEvents:UIControlEventTouchUpInside];
        [_weChatLoginButton sizeToFit];
    }
    return _weChatLoginButton;
}

- (UIButton *)qqLoginButton {
    if (_qqLoginButton == nil) {
        _qqLoginButton = [[UIButton alloc] init];
        [_qqLoginButton setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
        [_qqLoginButton addTarget:self
                           action:@selector (didClickQQLoginButton:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _qqLoginButton;
}


@end
