//
//  PublishViewController.m
//  BrickMan
//
//  Created by TZ on 16/7/18.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BMLoginViewController.h"
#import "ComposeViewController.h"
#import "PublishViewController.h"
#import "UITapImageView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ComposeViewController.h"

@interface PublishViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
/**
 *  相册或者相机控制器
 */
@property (nonatomic, strong) UIImagePickerController *imagePicker;

/**
 *  选择或者捕获的 image
 */
@property (nonatomic, strong) UIImage *image;


@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self customView];
}

- (void)customView {
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImgView.image        = [UIImage imageNamed:@"publishView_bg"];
    [self.view addSubview:bgImgView];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [backBtn setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    [backBtn addTarget:self
                action:@selector (dismissAction)
      forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo (CGSizeMake (50, 30));
        make.left.equalTo (self.view.mas_left).offset (10);
        make.top.equalTo (self.view.mas_top).offset (30);
    }];

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake (20, 120 * SCALE, kScreen_Width - 40, 150)];
    bgView.layer.borderWidth = 1.0;
    bgView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:bgView];

    //拍照
    __weak typeof(self) weakSelf  = self;
    UITapImageView *cameraImgView = [[UITapImageView alloc] init];
    cameraImgView.image           = [UIImage imageNamed:@"circle"];
    [cameraImgView addTapBlock:^(id obj) {
        [weakSelf cameraAction];
    }];
    [self.view addSubview:cameraImgView];
    UILabel *cameraLabel      = [[UILabel alloc] initWithFrame:CGRectMake (0, 20, 60, 20)];
    cameraLabel.font          = [UIFont systemFontOfSize:14];
    cameraLabel.textAlignment = NSTextAlignmentCenter;
    cameraLabel.text          = @"拍照";
    [cameraImgView addSubview:cameraLabel];

    //相册
    UITapImageView *photoImgView = [[UITapImageView alloc] init];
    photoImgView.image           = [UIImage imageNamed:@"circle"];
    [photoImgView addTapBlock:^(id obj) {
        [weakSelf photoAction];
    }];
    [self.view addSubview:photoImgView];
    UILabel *photoLabel      = [[UILabel alloc] initWithFrame:CGRectMake (0, 20, 60, 20)];
    photoLabel.font          = [UIFont systemFontOfSize:14];
    photoLabel.textAlignment = NSTextAlignmentCenter;
    photoLabel.text          = @"相册";
    [photoImgView addSubview:photoLabel];

    [cameraImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo (CGSizeMake (60, 60));
        make.right.equalTo (self.view.mas_centerX).offset (-50);
        make.top.equalTo (bgView.mas_bottom).offset (50);
    }];
    [photoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo (CGSizeMake (60, 60));
        make.left.equalTo (self.view.mas_centerX).offset (50);
        make.top.equalTo (bgView.mas_bottom).offset (50);
    }];
}

/**
 *  modal 出发布界面
 */
- (void)composePhotosOrVideos {
    ComposeViewController *composeViewController = [[ComposeViewController alloc] init];
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:composeViewController];
    composeViewController.image = self.image;
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Btn Action
- (void)dismissAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  点击拍照,进入相机拍照或者录相
 */
- (void)cameraAction {
    // 如果没有登录,显示登录界面
    if (!self.isLogin) {
        BMLoginViewController *loginViewController = [[BMLoginViewController alloc] init];
        [self.navigationController pushViewController:loginViewController animated:YES];
    } else {
        // 否则显示图片选择页面
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.mediaTypes = [[NSArray alloc]
        initWithObjects:(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage, (NSString *)kUTTypeGIF, nil];
        self.imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}
/**
 *  点击相册,进入相册选择照片
 */
- (void)photoAction {
    // 如果没有登录,显示登录界面
    if (!self.isLogin) {
        BMLoginViewController *loginViewController = [[BMLoginViewController alloc] init];
        [self.navigationController pushViewController:loginViewController animated:YES];
    } else {
        // 否则显示图片选择页面
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}


#pragma mark - UIImagePickerControllerDelegate
/**
 *  imagePickerController 实例在完成录制或者拍照完成后调用,保存视频或者照片
 *
 *  @param picker imagePickerController实例
 *  @param info   录制信息
 */
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    // 获取媒体文件类型
    NSString *mediaType = info[@"UIImagePickerControllerMediaType"];
    // 为 image 时,保存照片
    if (CFStringCompare ((__bridge_retained CFStringRef)mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        self.image     = image;
        if (picker.sourceType != UIImagePickerControllerSourceTypePhotoLibrary) {
            UIImageWriteToSavedPhotosAlbum (image, self,
                                            @selector (image:didFinishSavingWithError:contextInfo:), nil);
        }
    } else if (CFStringCompare ((__bridge_retained CFStringRef)mediaType, kUTTypeMovie, 0) ==
               kCFCompareEqualTo) { // 为 video 时,保存视频
        NSString *videoPath = (NSString *)[info[@"UIImagePickerControllerMediaURL"] path];
        if (picker.sourceType != UIImagePickerControllerSourceTypePhotoLibrary) {
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (videoPath)) {
                UISaveVideoAtPathToSavedPhotosAlbum (
                videoPath, self, @selector (video:didFinishSavingWithError:contextInfo:), nil);
            }
        }
    }
    [[BrickManAPIManager shareInstance] uploadFileWithImage:self.image doneBlock:^(NSArray *imgPathArray, NSError *error) {
        if (imgPathArray.count > 0) {
            [ComposeViewController sharedInstance].imagePathArray = imgPathArray;
        }
    } progerssBlock:^(CGFloat progressValue) {
        
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self composePhotosOrVideos];
}

/**
 *  当获取为 image 时,保存后回调
 *
 *  @param image       图片
 *  @param error       错误信息
 *  @param contextInfo
 */
- (void)image:(UIImage *)image
didFinishSavingWithError:(NSError *)error
             contextInfo:(void *)contextInfo {
    if (error) {
        UIAlertController *alert = [UIAlertController errorAlertWithMessage:@"照片保存失败"];
        [self presentViewController:alert animated:YES completion:nil];
        DebugLog (@"error: %@", error);
    }
}

/**
 *  当获取为 video 时,保存后回调
 *
 *  @param videoPath   视频
 *  @param error       错误信息
 *  @param contextInfo
 */
- (void)video:(NSString *)videoPath
didFinishSavingWithError:(NSError *)error
             contextInfo:(void *)contextInfo {
    if (error) {
        UIAlertController *alert = [UIAlertController errorAlertWithMessage:@"照片保存失败"];
        [self presentViewController:alert animated:YES completion:nil];
        DebugLog (@"error: %@", error);
    }
}


#pragma mark - 内存管理
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - lazy loading
- (UIImagePickerController *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker          = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}


@end
