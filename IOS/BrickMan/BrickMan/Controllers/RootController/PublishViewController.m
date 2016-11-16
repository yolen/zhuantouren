//
//  PublishViewController.m
//  BrickMan
//
//  Created by TZ on 2016/11/15.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "PublishViewController.h"
#import "ComposeViewController.h"

@interface PublishViewController ()

@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"publish_bg"];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.bottom).offset(-150);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = kNavigationBarColor;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.layer.cornerRadius = 18.0;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"发布" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(composeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).offset(20);
        make.size.equalTo(CGSizeMake(150, 36));
        make.left.equalTo((kScreen_Width - 150)/2);
    }];
    
}

- (void)composeAction:(id)sender {
    ComposeViewController *publishVC = [[ComposeViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:publishVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
