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

@property (nonatomic, strong) UIButton *goAroundButton, *qqLoginButton;
//@property (nonatomic, strong) UIButton *weChatLoginButton;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@end

@implementation BMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - UI
- (void)setupUI {
    
}

#pragma mark - Actions
- (void)didClickGoAroundButton:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didClickWeChatLoginButton:(UIButton *)button {
    kTipAlert(@"暂不支持微信登录");
}

- (void)didClickQQLoginButton:(UIButton *)button {
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQAppId andDelegate:self];
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
        [_goAroundButton setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
        [_goAroundButton setTitleEdgeInsets:UIEdgeInsetsMake (0, 10, 0, -10)];
        [_goAroundButton addTarget:self
                            action:@selector (didClickGoAroundButton:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _goAroundButton;
}

//- (UIButton *)weChatLoginButton {
//    if (_weChatLoginButton == nil) {
//        _weChatLoginButton = [[UIButton alloc] init];
//        [_weChatLoginButton setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
//        [_weChatLoginButton addTarget:self
//                               action:@selector (didClickWeChatLoginButton:)
//                     forControlEvents:UIControlEventTouchUpInside];
//        [_weChatLoginButton sizeToFit];
//    }
//    return _weChatLoginButton;
//}

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
