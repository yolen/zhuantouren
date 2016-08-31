//
//  PublishViewController.m
//  BrickMan
//
//  Created by TZ on 16/7/18.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BMLoginViewController.h"
#import "ComposeViewController.h"
#import "ComposeViewController.h"
#import "PublishViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "ComposeViewController.h"
#import <TZImagePickerController/TZImagePickerController.h>

static float progress = 0.0f;
@interface PublishViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImage *image;
@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;

    [self customView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)customView {
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImgView.image = [UIImage imageNamed:@"publishView_bg"];
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
    UIImageView *cameraImgView = [[UIImageView alloc] init];
    cameraImgView.image = [UIImage imageNamed:@"circle"];
    cameraImgView.userInteractionEnabled = YES;
    [self.view addSubview:cameraImgView];
    UITapGestureRecognizer *cameraTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cameraAction)];
    [cameraImgView addGestureRecognizer:cameraTap];
    UILabel *cameraLabel = [[UILabel alloc] initWithFrame:CGRectMake (0, 20*SCALE, 60*SCALE, 20)];
    cameraLabel.font = [UIFont systemFontOfSize:14];
    cameraLabel.textAlignment = NSTextAlignmentCenter;
    cameraLabel.text = @"拍照";
    [cameraImgView addSubview:cameraLabel];

    //相册
    UIImageView *photoImgView = [[UIImageView alloc] init];
    photoImgView.image = [UIImage imageNamed:@"circle"];
    photoImgView.userInteractionEnabled = YES;
    [self.view addSubview:photoImgView];
    UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoAction)];
    [photoImgView addGestureRecognizer:photoTap];
    UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake (0, 20*SCALE, 60*SCALE, 20)];
    photoLabel.font = [UIFont systemFontOfSize:14];
    photoLabel.textAlignment = NSTextAlignmentCenter;
    photoLabel.text = @"相册";
    [photoImgView addSubview:photoLabel];

    [cameraImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo (CGSizeMake (60*SCALE, 60*SCALE));
        make.right.equalTo (self.view.mas_centerX).offset (-50);
        make.top.equalTo (bgView.mas_bottom).offset (50);
    }];
    [photoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo (CGSizeMake (60*SCALE, 60*SCALE));
        make.left.equalTo (self.view.mas_centerX).offset (50);
        make.top.equalTo (bgView.mas_bottom).offset (50);
    }];
}

#pragma mark - Btn Action
- (void)dismissAction {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraAction {
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    self.imagePicker.mediaTypes = [[NSArray alloc]
//    initWithObjects:(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage, (NSString *)kUTTypeGIF, nil];
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)photoAction {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowTakePicture = NO; // 隐藏拍照按钮
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    [self dismissViewControllerAnimated:YES completion:nil];
    ComposeViewController *composeVC = [[ComposeViewController alloc] init];
    composeVC.images = photos;
    UINavigationController *composeNav = [[UINavigationController alloc] initWithRootViewController:composeVC];
    [self presentViewController:composeNav animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //保存原图片到相册中
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera && originalImage) {
        UIImageWriteToSavedPhotosAlbum(originalImage, self, nil, NULL);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    ComposeViewController *composeVC = [[ComposeViewController alloc] init];
    NSArray *array = [NSArray arrayWithObject:originalImage];
    composeVC.images = array;
    UINavigationController *composeNav = [[UINavigationController alloc] initWithRootViewController:composeVC];
    [self presentViewController:composeNav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
