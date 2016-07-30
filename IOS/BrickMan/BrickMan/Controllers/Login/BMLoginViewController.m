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
#import "BMUserInfo.h"

#define LOGIN_HEADER_TEXT @"砖头人"
#define LOGIN_TIP_TEXT @"左手鲜花,右手砖头的一群人\n只评论事儿,不评价人儿"

#define GO_AROUND_BUTTON_TITLE @"先随便看看"
#define WECHAT_TIP_TITLE @"微信登录"
#define QQ_TIP_TITLE @"QQ登录"


@interface BMLoginViewController () <TencentSessionDelegate>
/**
 *  随便看看
 */
@property (nonatomic, strong) UIButton *goAroundButton;
/**
 *  微信登录
 */
@property (nonatomic, strong) UIButton *weChatLoginButton;
/**
 *  QQ 登录
 */
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
//    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"publishView_bg"].CGImage);
    // 添加
    UILabel *headerLabel = [[UILabel alloc] init];
    [self.view addSubview:headerLabel];

    UILabel *loginTipLabel = [[UILabel alloc] init];
    [self.view addSubview:loginTipLabel];

    UILabel *weChatTipLabel = [[UILabel alloc] init];
    [self.view addSubview:weChatTipLabel];

    UILabel *qqTipLabel = [[UILabel alloc] init];
    [self.view addSubview:qqTipLabel];

    [self.view addSubview:self.goAroundButton];
    [self.view addSubview:self.weChatLoginButton];
    [self.view addSubview:self.qqLoginButton];
    // 配置
    headerLabel.text        = LOGIN_HEADER_TEXT;
    headerLabel.font        = [UIFont boldSystemFontOfSize:30];
    headerLabel.textColor   = [UIColor darkGrayColor];
    headerLabel.contentMode = UIViewContentModeCenter;

    loginTipLabel.text          = LOGIN_TIP_TEXT;
    loginTipLabel.numberOfLines = 0;
    loginTipLabel.textColor     = [UIColor grayColor];
    loginTipLabel.textAlignment = NSTextAlignmentCenter;

    weChatTipLabel.text = WECHAT_TIP_TITLE;
    qqTipLabel.text = QQ_TIP_TITLE;
    // 布局
    [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo (self.view.mas_centerX);
        make.top.equalTo (kScreen_Height / 4);
    }];

    [loginTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.view).offset (kScreen_Height * 2 / 5);
        make.centerX.equalTo (headerLabel.mas_centerX);
    }];

    [self.goAroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo (self.view.mas_centerX);
        make.top.equalTo (self.view).offset (kScreen_Height * 3 / 5);
    }];

    [self.weChatLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo (self.view.mas_centerX).offset (-kScreen_Width / 4);
        make.top.equalTo (self.view.mas_bottom).offset (-kScreen_Height / 4);
    }];

    [weChatTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.weChatLoginButton.mas_centerX);
        make.top.equalTo(self.weChatLoginButton.mas_bottom).offset(5);
    }];

    [self.qqLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo (self.view.mas_centerX).offset (kScreen_Width / 4);
        make.top.equalTo (self.weChatLoginButton);
    }];

    [qqTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.qqLoginButton.mas_centerX);
        make.top.equalTo(weChatTipLabel);
    }];
}

#pragma mark - QQ Login
- (void)loginWithQQ {
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_LOGIN_APP_ID andDelegate:self];
    // 设置权限//TODO:  qq 登录权限可以精简
    NSArray *permissions =
    [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
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
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin {
    // 保存用户 accessToken expirationDate openId
    [BMUserInfo sharedUserInfo].accessToken = self.tencentOAuth.accessToken;
    [BMUserInfo sharedUserInfo].expirationDate = self.tencentOAuth.expirationDate;
    [BMUserInfo sharedUserInfo].openId = self.tencentOAuth.openId;
    // 获取用户基本信息
    [self.tencentOAuth getUserInfo];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 * 登录失败后的回调
 * @param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled {
    UIAlertController *alert = [UIAlertController errorAlertWithMessage:@"登录失败"];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork {
}

/**
 * 获取用户个人信息回调
 * \param response API返回结果，具体定义参见sdkdef.h文件中\ref APIResponse
 * \remarks 正确返回示例: \snippet example/getUserInfoResponse.exp success
 *          错误返回示例: \snippet example/getUserInfoResponse.exp fail
 */
- (void)getUserInfoResponse:(APIResponse*) response{
    // 保存用户信息到本地
    [[BMUserInfo sharedUserInfo] saveUserInfoWithDict:response.jsonResponse];
    //TODO: 用户数据与服务器对接
}


#pragma mark - lazy loading
- (UIButton *)goAroundButton {
    if (_goAroundButton == nil) {
        _goAroundButton = [[UIButton alloc] init];
        [_goAroundButton setTitle:GO_AROUND_BUTTON_TITLE forState:UIControlStateNormal];
        [_goAroundButton setImage:[UIImage imageNamed:@"right_arrow"]
                         forState:UIControlStateNormal];
        [_goAroundButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_goAroundButton setTitleEdgeInsets:UIEdgeInsetsMake (0, -20, 0, 0)];
        [_goAroundButton setImageEdgeInsets:UIEdgeInsetsMake (0, 120, 0, 0)];
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
        [_weChatLoginButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
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
        [_qqLoginButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_qqLoginButton addTarget:self
                           action:@selector (didClickQQLoginButton:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _qqLoginButton;
}


@end
