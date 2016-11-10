//
//  BMStartView.m
//  BrickMan
//
//  Created by TZ on 16/9/1.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BMStartView.h"
#import "StartImageManager.h"

NSString *const content = @"专注社会事件的传播与思考";

@implementation BMStartView

+ (instancetype)sharedInstance {
    static BMStartView* instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BMStartView alloc] init];
    });

    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.frame = kScreen_Bounds;
        
        StartImage * st = [[StartImageManager sharedInstance] randomImage];
        if (st) {
            [self configureStartViewWithImage:[st image] andTitle:content];
        }else {
            UIImageView *defaultImgView = [[UIImageView alloc] initWithFrame:self.bounds];
            defaultImgView.contentMode = UIViewContentModeScaleAspectFill;
            defaultImgView.image = [UIImage imageNamed:@"default"];
            [self addSubview:defaultImgView];
        }
    }
    return self;
}

- (void)configureStartViewWithImage:(UIImage *)image andTitle:(NSString *)title {
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 425*SCALE)];
    topView.contentMode = UIViewContentModeScaleAspectFill;
    topView.image = image;
    [bgView addSubview:topView];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreen_Height - 55*SCALE, kScreen_Width, 20)];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:13];
    contentLabel.textColor = kNavigationBarColor;
    contentLabel.text = title;
    [bgView addSubview:contentLabel];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width - 50)/2, contentLabel.top + - 60*SCALE, 50*SCALE, 50*SCALE)];
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    iconView.image = [UIImage imageNamed:@"icon"];
    [bgView addSubview:iconView];
}

- (void)startAnimationWithCompletionBlock:(void(^)())completionHandler {
    [kKeyWindow addSubview:self];
    [kKeyWindow bringSubviewToFront:self];
    
    [UIView animateWithDuration:1.0 animations:^{
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.35 delay:2.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            if (completionHandler) {
                completionHandler(self);
            }
        }];
    }];
    
}

@end
