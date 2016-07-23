//
//  HeadEditController.m
//  BrickMan
//
//  Created by 段永瑞 on 16/7/22.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "HeadEditController.h"
#import "CutHeadController.h"

@interface HeadEditController ()<UIImagePickerControllerDelegate>

@end

@implementation HeadEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的头像";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveHead:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.headImgView.image = [UIImage imageNamed:@"user_icon"];
    [self.view addSubview:self.headImgView];
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    changeBtn.bounds = CGRectMake(0, 0, kScreen_Width - 40, 40);
    changeBtn.center = CGPointMake(self.view.center.x, self.headImgView.bottom + (kScreen_Height - 64 - self.headImgView.height)/2);
    changeBtn.backgroundColor = kNavigationBarColor;
    [changeBtn setTitle:@"上传头像" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    changeBtn.layer.masksToBounds = YES;
    changeBtn.layer.cornerRadius = 5.f;
    [changeBtn addTarget:self action:@selector(changeHead:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
    // Do any additional setup after loading the view.
}

- (void)saveHead:(UIBarButtonItem *)sender {
    
}

- (void)changeHead:(UIButton *)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = (id)self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = (id)self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionSheet addAction:takePhoto];
    [actionSheet addAction:library];
    [actionSheet addAction:cancel];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"%@",info);
    
    [picker dismissViewControllerAnimated:YES completion:^{
        CutHeadController *cutHead = [[CutHeadController alloc]init];
        cutHead.image = info[UIImagePickerControllerOriginalImage];
        [self.navigationController pushViewController:cutHead animated:YES];
    }];
}

- (UIImageView *)headImgView {
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width)];
    }
    return _headImgView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
