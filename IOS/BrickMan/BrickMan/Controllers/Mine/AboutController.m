//
//  AboutController.m
//  BrickMan
//
//  Created by 段永瑞 on 16/7/22.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "AboutController.h"

@implementation AboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于我们";
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kAboutUrl]];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
