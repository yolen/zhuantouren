//
//  RegisterViewController.m
//  BrickMan
//
//  Created by TZ on 2016/9/27.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property(strong, nonatomic) UITextField *userID_TF, *password_TF, *confirm_TF;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIButton *registerBtn;
@end

@implementation RegisterViewController

- (instancetype)init {
    if (self = [super init]) {
        self.isEndEdit = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"注册";
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)configUI {
    //textField
    self.userID_TF = [[UITextField alloc] initWithFrame:CGRectMake(20, 30, kScreen_Width - 40, 40)];
    self.userID_TF.placeholder = @"设置用户名";
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

    self.password_TF = [[UITextField alloc] initWithFrame:CGRectMake(20, self.userID_TF.bottom + 30, kScreen_Width - 40, 40)];
    self.password_TF.placeholder = @"设置密码(6-20位字母、数字组合)";
    self.password_TF.secureTextEntry = YES;
    self.password_TF.backgroundColor = [UIColor whiteColor];
    self.password_TF.leftViewMode=UITextFieldViewModeAlways;
    self.password_TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.password_TF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.password_TF];
    
    UIView *left_view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    UIImageView *left_passwordView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 18, 20)];
    left_passwordView.image=[UIImage imageNamed:@"icon_pwd"];
    [left_view2 addSubview:left_passwordView];
    self.password_TF.leftView = left_view2;

    self.confirm_TF = [[UITextField alloc] initWithFrame:CGRectMake(20, self.password_TF.bottom + 30, kScreen_Width - 40, 40)];
    self.confirm_TF.placeholder = @"设置确认密码";
    self.confirm_TF.secureTextEntry = YES;
    self.confirm_TF.backgroundColor = [UIColor whiteColor];
    self.confirm_TF.leftViewMode=UITextFieldViewModeAlways;
    self.confirm_TF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.confirm_TF.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.confirm_TF];
    
    UIView *left_view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 40)];
    UIImageView *left_confirmView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 18, 20)];
    left_confirmView.image=[UIImage imageNamed:@"icon_pwd"];
    [left_view3 addSubview:left_confirmView];
    self.confirm_TF.leftView = left_view3;
    
    //btn
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.registerBtn.frame = CGRectMake(20, self.confirm_TF.bottom + 30, kScreen_Width - 40, 40);
    self.registerBtn.backgroundColor = kNavigationBarColor;
    [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    self.registerBtn.layer.cornerRadius = 3.0;
    self.registerBtn.layer.masksToBounds = YES;
    [self.view addSubview:self.registerBtn];
}

#pragma mark - Action 
- (void)registerAction:(id)sender {
    NSString *tipString;
    BOOL isEqual = [self.password_TF.text isEqualToString:self.confirm_TF.text];
    if (self.userID_TF.text.length == 0) {
        tipString = @"请输入用户名";
    }else if (self.password_TF.text.length == 0) {
        tipString = @"请输入密码";
    }else if (self.confirm_TF.text.length == 0) {
        tipString = @"请输入确认密码";
    }else if (self.password_TF.text.length < 6 || self.password_TF.text.length > 20) {
        tipString = @"密码为6-20位字母、数字组合";
    }else if ([_password_TF.text length] >= 6) {
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL result = [pred evaluateWithObject:_password_TF.text];
        
        if (!result) {
            tipString = @"密码为6-20位字母、数字组合";
        }
    }else if (!isEqual) {
        tipString = @"确认密码与密码不一致";
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
        CGSize captchaViewSize = self.registerBtn.bounds.size;
        _activityIndicator.hidesWhenStopped = YES;
        [_activityIndicator setCenter:CGPointMake(captchaViewSize.width/2, captchaViewSize.height/2)];
        [self.registerBtn addSubview:_activityIndicator];
    }
    [_activityIndicator startAnimating];
    self.registerBtn.enabled = NO;
    
    __weak typeof(self) weakSelf = self;
    [[BrickManAPIManager shareInstance] requestRegisterWithParams:@{@"userName" : self.userID_TF.text,@"userPwd" : self.password_TF.text,@"checkPassWord" : self.confirm_TF.text} andBlock:^(id data, NSError *error) {
        [weakSelf.activityIndicator stopAnimating];
        weakSelf.registerBtn.enabled = YES;
        if (data) {
            [NSObject showSuccessMsg:@"恭喜你,注册成功!"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
