
//
//  LoginViewController.m
//  BrickMan
//
//  Created by TZ on 2016/9/27.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "LoginViewController.h"
#import "BrickManNetClient.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "RegisterViewController.h"

@interface LoginViewController ()<TencentSessionDelegate>
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (strong, nonatomic) UITextField *userID_TF, *password_TF;
@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@end

@implementation LoginViewController

- (instancetype)init {
    if (self = [super init]) {
        self.isEndEdit = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customeUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)customeUI {
    UIImageView *top_bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width , 180*SCALE)];
    top_bgView.contentMode = UIViewContentModeScaleAspectFill;
    top_bgView.image = [UIImage imageNamed:@"login_bg0"];
    [self.view addSubview:top_bgView];
    
    UIImageView *bottom_bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, top_bgView.bottom, kScreen_Width, kScreen_Height - top_bgView.height)];
    bottom_bgView.contentMode = UIViewContentModeScaleAspectFill;
    bottom_bgView.image = [UIImage imageNamed:@"login_bg1"];
    [self.view addSubview:bottom_bgView];
    
    UIButton *close_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    close_btn.frame = CGRectMake(15, 30, 15, 15);
    [close_btn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [close_btn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close_btn];
    
    UILabel *title_label = [[UILabel alloc] initWithFrame:CGRectMake((kScreen_Width - 100)/2, 65*SCALE, 100, 50)];
    title_label.font = [UIFont systemFontOfSize:20];
    title_label.textColor = [UIColor whiteColor];
    title_label.textAlignment = NSTextAlignmentCenter;
    title_label.text = @"砖头人";
    [self.view addSubview:title_label];
    
    //textField
    self.userID_TF = [[UITextField alloc] initWithFrame:CGRectMake(20, top_bgView.bottom + 30, kScreen_Width - 40, 40)];
    self.userID_TF.placeholder = @"请输入用户名";
    self.userID_TF.backgroundColor = [UIColor whiteColor];
    self.userID_TF.leftViewMode=UITextFieldViewModeAlways;
    self.userID_TF.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.userID_TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.userID_TF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.userID_TF];
    
    UIView *left_view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    UIImageView *left_userView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    left_userView.image=[UIImage imageNamed:@"icon_user"];
    [left_view1 addSubview:left_userView];
    self.userID_TF.leftView = left_view1;
    
    self.password_TF = [[UITextField alloc] initWithFrame:CGRectMake(20, self.userID_TF.bottom + 20, kScreen_Width - 40, 40)];
    self.password_TF.placeholder = @"请输入密码";
    self.password_TF.secureTextEntry = YES;
    self.password_TF.backgroundColor = [UIColor whiteColor];
    self.password_TF.leftViewMode=UITextFieldViewModeAlways;
    self.password_TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.password_TF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.password_TF];
    
    UIView *left_view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    UIImageView *left_pwdView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 18, 20)];
    left_pwdView.image=[UIImage imageNamed:@"icon_pwd"];
    [left_view2 addSubview:left_pwdView];
    self.password_TF.leftView = left_view2;
    
    //login
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.frame = CGRectMake(20, self.password_TF.bottom + 30, kScreen_Width - 40, 40);
    self.loginBtn.backgroundColor = kNavigationBarColor;
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    self.loginBtn.layer.cornerRadius = 5.0;
    self.loginBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.loginBtn];
    
    //注册&找回密码
    UIButton *register_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    register_btn.frame = CGRectMake(20, self.loginBtn.bottom + 10, 50, 20);
    [register_btn setTitle:@"注册" forState:UIControlStateNormal];
    [register_btn setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    register_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [register_btn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:register_btn];
    
    UIButton *forget_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    forget_btn.frame = CGRectMake(kScreen_Width - 100, self.loginBtn.bottom + 10, 80, 20);
    [forget_btn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forget_btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    forget_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [forget_btn addTarget:self action:@selector(forgetPwdAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forget_btn];
    
    //第三方登录
    UIImageView *separator_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 120*SCALE, kScreen_Width, 10)];
    separator_view.image = [UIImage imageNamed:@"separator"];
    [self.view addSubview:separator_view];
    
    UILabel *third_label = [[UILabel alloc] initWithFrame:CGRectMake((kScreen_Width - 100)/2, separator_view.top, 100, 10)];
    third_label.font = [UIFont systemFontOfSize:14];
    third_label.textAlignment = NSTextAlignmentCenter;
    third_label.text = @"社交账号登录";
    [self.view addSubview:third_label];
    
    UIButton *qq_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    qq_btn.frame = CGRectMake((kScreen_Width - 50)/2, kScreen_Height - 80*SCALE, 40, 40);
    [qq_btn setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    [qq_btn addTarget:self action:@selector(qqLoginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qq_btn];
}

#pragma mark - Action
- (void)closeAction {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginAction:(id)sender {
    NSString *tipString;
    if (self.userID_TF.text.length == 0) {
        tipString = @"请输入用户名";
    }else if (self.password_TF.text.length == 0) {
        tipString = @"请输入密码";
    }
    if (tipString) {
        kTipAlert(@"%@",tipString);
        return;
    }
    [self.view endEditing:YES];
    
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc]
                              initWithActivityIndicatorStyle:
                              UIActivityIndicatorViewStyleGray];
        CGSize captchaViewSize = _loginBtn.bounds.size;
        _activityIndicator.hidesWhenStopped = YES;
        [_activityIndicator setCenter:CGPointMake(captchaViewSize.width/2, captchaViewSize.height/2)];
        [_loginBtn addSubview:_activityIndicator];
    }
    [_activityIndicator startAnimating];
    _loginBtn.enabled = NO;
    
    __weak typeof(self) weakSelf = self;
    [[BrickManAPIManager shareInstance] requestLoginWithParams:@{@"userName" : self.userID_TF.text, @"userPwd" : self.password_TF.text} andBlock:^(id data, NSError *error) {
        [weakSelf.activityIndicator stopAnimating];
        weakSelf.loginBtn.enabled = YES;
        if (data) {
            [NSObject showSuccessMsg:@"登录成功"];
            
            //缓存用户信息
            [BMUser saveUserInfo:data];
            [[BrickManNetClient sharedJsonClient] setToken:data[@"token"]];
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshUserInfo object:nil];
        }else {
            [NSObject showErrorMsg:@"登录失败"];
        }
    }];
}

- (void)registerAction:(id)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)forgetPwdAction:(id)sender {
    kTipAlert(@"请加砖头人app用户反馈群（387655797），找管理员索要登录密码。");
}

- (void)qqLoginAction:(id)sender {
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
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshUserInfo object:nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
