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
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 400*SCALE)];
    imageView.image = [UIImage imageNamed:@"loginbackground"];
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
    headerLabel.text        = @"砖头人";
    headerLabel.font        = [UIFont boldSystemFontOfSize:20];
    headerLabel.textColor   = [UIColor whiteColor];
    headerLabel.contentMode = UIViewContentModeCenter;

    tipLabel.text          = @"左手鲜花,右手砖头的一群人\n只评论事儿,不评价人儿";
    tipLabel.numberOfLines = 0;
    tipLabel.textColor     = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;

    lineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];

    loginTipLabel.text            = @"社交帐号登录";
    loginTipLabel.textAlignment   = NSTextAlignmentCenter;
    loginTipLabel.backgroundColor = [UIColor whiteColor];

    goAroundBgView.backgroundColor     = [UIColor whiteColor];
    goAroundBgView.layer.cornerRadius  = 22;
    goAroundBgView.layer.masksToBounds = YES;

    // 布局
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
        make.bottom.equalTo (self.view.mas_bottom).offset (-40*SCALE);
    }];

    [self.qqLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo (self.view.mas_centerX).offset (kScreen_Width / 4);
        make.top.equalTo (self.weChatLoginButton);
    }];
}

#pragma mark - Actions
- (void)didClickGoAroundButton:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didClickWeChatLoginButton:(UIButton *)button {
    kTipAlert(@"暂不支持微信登录");
}

- (void)didClickQQLoginButton:(UIButton *)button {
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_LOGIN_APP_ID andDelegate:self];
    NSArray *permissions =[NSArray arrayWithObjects:kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];;
    [self.tencentOAuth authorize:permissions inSafari:NO];
}

#pragma mark - TencentSessionDelegate
- (void)tencentDidLogin {
    [[BrickManAPIManager shareInstance] requestAuthLoginWithParams:@{@"thirdAuth" : @"qq", @"accessToken" : self.tencentOAuth.accessToken, @"openId" : self.tencentOAuth.openId} andBlock:^(id data, NSError *error) {
        if (data) {
            [NSObject showSuccessMsg:@"登录成功"];
            
            //缓存用户信息
            [BMUser saveUserInfo:data];
            [[BrickManNetClient sharedJsonClient] setToken:data[@"token"]];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            [NSObject showErrorMsg:@"登录失败"];
        }
    }];
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    kTipAlert(@"登录失败");
}

- (void)tencentDidNotNetWork {
    
}


#pragma mark - lazy loading
- (UIButton *)goAroundButton {
    if (_goAroundButton == nil) {
        _goAroundButton = [[UIButton alloc] init];
        [_goAroundButton setTitle:@"先随便看看" forState:UIControlStateNormal];
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
