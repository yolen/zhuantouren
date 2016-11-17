//
//  AppDelegate.m
//  BrickMan
//
//  Created by TZ on 16/7/18.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabBarController.h"
#import "IntroduceViewController.h"
#import "BMStartView.h"
#import "CacheImageSize.h"
#import "BrickManNetClient.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "AFNetworkActivityIndicatorManager.h"

static void customHandler() {
    //友盟分享初始化
    [UMSocialData setAppKey:kUMSocialKey];
    [UMSocialWechatHandler setWXAppId:kWXAppId appSecret:kWXAppSecret url:kUMRedirectURL];
    [UMSocialQQHandler setQQWithAppId:kQQAppId appKey:kQQAppKey url:kUMRedirectURL];
    [UMSocialConfig setFinishToastIsHidden:YES position:UMSocialiToastPositionCenter];
    
    [AMapServices sharedServices].apiKey = (NSString *)APIKey;
    
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    [navigationBar setBackgroundImage:[UIImage imageWithColor:kNavigationBarColor]
                        forBarMetrics:UIBarMetricsDefault];
    [navigationBar setTintColor:[UIColor whiteColor]];
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName: [UIFont systemFontOfSize:18],
                                     NSForegroundColorAttributeName: [UIColor whiteColor],
                                     };
    [navigationBar setTitleTextAttributes:textAttributes];
    [navigationBar setTintColor:[UIColor whiteColor]];
    [[UITextField appearance] setTintColor:kNavigationBarColor];
}
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    customHandler();
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isShowIntroducePage"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowIntroducePage"];
        
        IntroduceViewController *introduceVC = [[IntroduceViewController alloc] init];
        self.window.rootViewController = introduceVC;
    }else {
        RootTabBarController *rootVC = [RootTabBarController sharedInstance];
        self.window.rootViewController = rootVC;
    }
    
    if ([BMUser isLogin]) {
        [[BrickManNetClient sharedJsonClient] setToken:[BMUser getUserModel].token];
    }
    [self.window makeKeyAndVisible];

    BMStartView *startView = [BMStartView sharedInstance];
    [startView startAnimationWithCompletionBlock:^{
        DebugLog(@"Completion");
    }];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for
    // certain types of temporary interruptions (such as an incoming phone call or SMS message) or
    // when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame
    // rates. Games should use this method to pause the game.
    [[CacheImageSize shareManager] save];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store
    // enough application state information to restore your application to its current state in case
    // it is terminated later.
    // If your application supports background execution, this method is called instead of
    // applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo
    // many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive.
    // If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also
    // applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        result = [TencentOAuth HandleOpenURL:url];
    }
    return result;
}

@end
