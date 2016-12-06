//
//  PersonInfoController.m
//  BrickMan
//
//  Created by 段永瑞 on 16/7/22.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "PersonInfoController.h"
#import "Mine_infoCell.h"
#import "HeadEditController.h"
#import "MottoController.h"
#import "ChangeUserInfoController.h"
#import "UITextField+Common.h"
#import "ActionSheetStringPicker.h"

@import AVFoundation;
@import AssetsLibrary;

#define kMinLength 2

@interface PersonInfoController ()<UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation PersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    self.titles = @[@"我的头像",@"我的昵称",@"我的性别",@"座右铭"];
    
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.rowHeight = [Mine_infoCell cellHeight];
    self.myTableView.tableFooterView = [UIView new];
    [self.myTableView registerClass:[Mine_infoCell class] forCellReuseIdentifier:kCellIdentifier_Mine_infoCell];
    [self.view addSubview:self.self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.user = [BMUser getUserModel];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Mine_infoCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Mine_infoCell forIndexPath:indexPath];
    cell.titleLabel.text = self.titles[indexPath.row];
    if (indexPath.row == 0) {
        
        [cell.subImgView sd_setImageWithURL:[NSURL URLWithString:self.user.userHead] placeholderImage:[UIImage imageNamed:@"icon"]];
        [cell.subLabel setHidden:YES];
        [cell.subImgView setHidden:NO];
    } else {
        if (indexPath.row == 1) {
            
            cell.subLabel.text = self.user.userAlias;
        }else if(indexPath.row == 2) {
            cell.subLabel.text = self.user.userSexStr;
        }else if (indexPath.row == 3) {
            cell.subLabel.text = self.user.motto.length > 0 ? self.user.motto : @"漂泊者的分享交流社区";
        }
        [cell.subLabel setHidden:NO];
        [cell.subImgView setHidden:YES];
    }
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeft];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
        case 0: { //更改头像
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil];
            [sheet showInView:self.view];
        }
            break;
        case 1: { //更改昵称
            ChangeUserInfoController *vc = [[ChangeUserInfoController alloc] init];
            __weak typeof(self) weakSelf = self;
            vc.updateBlock = ^(NSString *value){
                weakSelf.user.userAlias = value;
                [weakSelf.myTableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2: { //更改性别
            NSArray *sexArray = @[@"男",@"女"];
            NSInteger selectIndex = [sexArray indexOfObject:self.user.userSexStr];
            [ActionSheetStringPicker showPickerWithTitle:nil rows:@[sexArray] initialSelection:@[[NSNumber numberWithInteger:selectIndex]] doneBlock:^(ActionSheetStringPicker *picker, NSArray *selectedIndex, NSArray *selectedValue) {
                NSString *sexString = [selectedValue.firstObject isEqualToString:@"男"] ? @"USER_SEX01" : @"USER_SEX02";
                
                [[BrickManAPIManager shareInstance] requestUpdateUserInfoWithParams:@{@"userId" : self.user.userId, @"userSex" : sexString} andBlock:^(id data, NSError *error) {
                    if (data) {
                        NSMutableDictionary *userInfo = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo] mutableCopy];
                        userInfo[@"userSex"] = sexString;
                        userInfo[@"userSexStr"] = selectedValue.firstObject;
                        [BMUser saveUserInfo:userInfo];
                        weakSelf.user = [BMUser getUserModel];
                        
                        [weakSelf.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    }else {
                        [NSObject showErrorMsg:@"修改性别失败"];
                    }
                }];
            } cancelBlock:nil origin:self.view];
        }
            break;
        case 3: { //更改座右铭
            MottoController *motto = [[MottoController alloc]init];
            motto.mottoString = self.user.motto.length > 0 ? self.user.motto : @"漂泊者的分享交流社区";
            motto.updateBlock = ^(NSString *value){
                weakSelf.user.motto = value;
                [weakSelf.myTableView reloadData];
            };
            [self.navigationController pushViewController:motto animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 2) {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if (buttonIndex == 0) {
        if (![self checkCameraAuthorizationStatus]) {
            return;
        }
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else {
        if (![self checkPhotoLibraryAuthorizationStatus]) {
            return;
        }
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - picker Image 
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //保存原图片到相册中
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera && originalImage) {
        UIImageWriteToSavedPhotosAlbum(originalImage, self, nil, NULL);
    }
    
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        NSData *data = UIImageJPEGRepresentation(originalImage, 1.0);
        //对于大于100kb的图片进行压缩
        if ((float)data.length/1024 > 30) {
            data = UIImageJPEGRepresentation(originalImage, 1024*30 / (float)data.length);
        }
        UIImage *image = [UIImage imageWithData:data];
        
        [[BrickManAPIManager shareInstance] uploadFileWithImages:@[image] doneBlock:^(NSString *imagePath, NSError *error) {
            if (imagePath) {
                BMUser *user = [BMUser getUserModel];
                [[BrickManAPIManager shareInstance] requestUpdateUserInfoWithParams:@{@"userId" : user.userId, @"userHead" : imagePath} andBlock:^(id data, NSError *error) {
                    if (data) {
                        [NSObject showSuccessMsg:@"更换头像成功"];
                        NSMutableDictionary *userInfo = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo] mutableCopy];
                        userInfo[@"userHead"] = [NSString stringWithFormat:@"%@/%@",kImageUrl,imagePath];
                        [BMUser saveUserInfo:userInfo];
                        
                        [weakSelf reload];
                    }
                }];
            }
        } progerssBlock:nil];

    }];
}

- (void)reload {
    self.user = [BMUser getUserModel];
    [self.myTableView reloadData];
}

#pragma mark - alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
            [[UIApplication sharedApplication] openURL:settingsURL];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)checkPhotoLibraryAuthorizationStatus {
    if ([ALAssetsLibrary respondsToSelector:@selector(authorizationStatus)]) {
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (ALAuthorizationStatusDenied == authStatus ||
            ALAuthorizationStatusRestricted == authStatus) {
            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->照片”中打开本应用的访问权限"];
            return NO;
        }
    }
    return YES;
}

- (BOOL)checkCameraAuthorizationStatus {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        kTipAlert(@"该设备不支持拍照");
        return NO;
    }
    
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (AVAuthorizationStatusDenied == authStatus ||
            AVAuthorizationStatusRestricted == authStatus) {
            [self showSettingAlertStr:@"请在iPhone的“设置->隐私->相机”中打开本应用的访问权限"];
            return NO;
        }
    }
    
    return YES;
}

- (void)showSettingAlertStr:(NSString *)tipStr {
    //iOS8+系统下可跳转到‘设置’页面，否则只弹出提示窗即可
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:tipStr delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    }else{
        kTipAlert(@"%@", tipStr);
    }
}

@end
