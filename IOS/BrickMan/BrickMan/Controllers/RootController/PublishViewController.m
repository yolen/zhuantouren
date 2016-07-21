//
//  PublishViewController.m
//  BrickMan
//
//  Created by TZ on 16/7/18.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "PublishViewController.h"
#import "UITapImageView.h"

@interface PublishViewController ()

@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customView];
    
}

- (void)customView {
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImgView.image = [UIImage imageNamed:@"publishView_bg"];
    [self.view addSubview:bgImgView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [backBtn setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 30));
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(self.view.mas_top).offset(30);
    }];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(20, 120*SCALE, kScreen_Width - 40, 150)];
    bgView.layer.borderWidth = 1.0;
    bgView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:bgView];
    
    //拍照
    __weak typeof(self) weakSelf = self;
    UITapImageView *cameraImgView = [[UITapImageView alloc] init];
    cameraImgView.image = [UIImage imageNamed:@"circle"];
    [cameraImgView addTapBlock:^(id obj) {
        [weakSelf cameraAction];
    }];
    [self.view addSubview:cameraImgView];
    UILabel *cameraLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20,60, 20)];
    cameraLabel.font = [UIFont systemFontOfSize:14];
    cameraLabel.textAlignment = NSTextAlignmentCenter;
    cameraLabel.text = @"拍照";
    [cameraImgView addSubview:cameraLabel];
    
    //相册
    UITapImageView *photoImgView = [[UITapImageView alloc] init];
    photoImgView.image = [UIImage imageNamed:@"circle"];
    [photoImgView addTapBlock:^(id obj) {
        [weakSelf cameraAction];
    }];
    [self.view addSubview:photoImgView];
    UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 60, 20)];
    photoLabel.font = [UIFont systemFontOfSize:14];
    photoLabel.textAlignment = NSTextAlignmentCenter;
    photoLabel.text = @"相册";
    [photoImgView addSubview:photoLabel];
    
    [cameraImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.right.equalTo(self.view.mas_centerX).offset(-50);
        make.top.equalTo(bgView.mas_bottom).offset(50);
    }];
    [photoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.left.equalTo(self.view.mas_centerX).offset(50);
        make.top.equalTo(bgView.mas_bottom).offset(50);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Btn Action
- (void)dismissAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraAction {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
