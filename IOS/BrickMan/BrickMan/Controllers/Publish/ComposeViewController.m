//
//  ComposeViewController.m
//  BrickMan
//
//  Created by TobyoTenma on 7/21/16.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import "ComposePictureCell.h"
#import "UIPlaceHolderTextView.h"
#import "ComposeViewController.h"
#import "BMLocationCell.h"
#import <TZImagePickerController.h>
#import <MBProgressHUD.h>
#import "EditLocationViewController.h"

#define DefaultLocationTimeout  6
#define DefaultReGeocodeTimeout 3
#define PICTURE_MARGIN 15
#define PICTURE_COL_NUM 3
#define PICTURE_WIDTH (kScreen_Width - (PICTURE_COL_NUM + 1) * PICTURE_MARGIN) / PICTURE_COL_NUM

@interface ComposeViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,ComposePictureCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,TZImagePickerControllerDelegate,UIActionSheetDelegate, AMapLocationManagerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIPlaceHolderTextView *textView;
@property (nonatomic, strong) UICollectionView *pictureView;
@property (nonatomic, strong) NSMutableArray<UIImage *> *pictures;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (strong, nonatomic) NSString *locationString;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pictures = [NSMutableArray array];
    [self setupNavigationBar];
    [self setupTableView];
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self initCompleteBlock];
    
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
//    [self.locationManager setAllowsBackgroundLocationUpdates:YES]; //设置允许在后台定位
    [self.locationManager setLocationTimeout:DefaultLocationTimeout]; //设置定位超时时间
    [self.locationManager setReGeocodeTimeout:DefaultReGeocodeTimeout]; //设置逆地理超时时间
    
    //进行单次带逆地理定位请求
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self.tableView.tableHeaderView respondsToSelector:@selector(becomeFirstResponder)]) {
        [self.tableView.tableHeaderView becomeFirstResponder];
    }
}

#pragma mark - config
- (void)setupNavigationBar {
    self.title = @"发布";
    
    UIButton *returnHomeButton = [[UIButton alloc] init];
    [returnHomeButton addTarget:self action:@selector (returnHomeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [returnHomeButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    UIBarButtonItem *returnItem = [[UIBarButtonItem alloc] initWithCustomView:returnHomeButton];
    self.navigationItem.leftBarButtonItem = returnItem;
    [returnHomeButton sizeToFit];

    UIButton *composeButton = [[UIButton alloc] init];
    [composeButton addTarget:self action:@selector (composeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [composeButton setBackgroundImage:[UIImage imageNamed:@"compose"]
                                  forState:UIControlStateNormal];
    UIBarButtonItem *composeItem = [[UIBarButtonItem alloc] initWithCustomView:composeButton];
    self.navigationItem.rightBarButtonItem = composeItem;
    [composeButton sizeToFit];
}

- (void)setupTableView {
    [self.view addSubview:self.tableView];
    self.textView = [[UIPlaceHolderTextView alloc] initWithFrame:CGRectMake (0, 0, kScreen_Width, 150)];
    self.textView.font = [UIFont systemFontOfSize:14];
    self.textView.placeholder = @"你看见的,就是我想知道的...";
    self.textView.returnKeyType = UIReturnKeyDefault;
    self.tableView.tableHeaderView = self.textView;
    self.tableView.tableFooterView = self.pictureView;
}

- (void)initCompleteBlock {
    __weak typeof(self) weakSelf = self;
    self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        BMLocationCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (error) {
            DebugLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            cell.locationLabel.text = @"定位失败,请点击编辑地址信息";
            if (error.code == AMapLocationErrorLocateFailed) { //如果为定位失败的error，则不进行annotation的添加
                return;
            }
        }
        
        if (location) { //得到定位信息
            cell.locationLabel.text = regeocode.formattedAddress;
            weakSelf.locationString = regeocode.formattedAddress;
        }
    };
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_BMLocationCell forIndexPath:indexPath];
    cell.locationLabel.text = @"获取中...";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    
    EditLocationViewController *editVC = [[EditLocationViewController alloc] init];
    editVC.locationStr = self.locationString;
    __weak typeof(self) weakSelf = self;
    editVC.updateStringBlock = ^(NSString *valueString){
        BMLocationCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.locationLabel.text = valueString;
        weakSelf.locationString = valueString;
    };
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pictures.count < 9 ? self.pictures.count + 1 : 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ComposePictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PictureCell" forIndexPath:indexPath];
    cell.composePictureCellDelegate = self;
    if (self.pictures.count == indexPath.item) {
        cell.image = nil;
    } else {
        cell.image = self.pictures[indexPath.item];
    }
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(PICTURE_WIDTH, PICTURE_WIDTH);
}

#pragma mark - ComposePictureCellDelegate
- (void)composePictureCellAddPicture:(ComposePictureCell *)composePictureCell {
    [self.view endEditing:YES];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [sheet showInView:self.view];
}

- (void)composePictureCellDeletePicture:(ComposePictureCell *)composePictureCell {
    NSUInteger deleteIndex    = [self.pictureView indexPathForCell:composePictureCell].item;
    [self.pictures removeObjectAtIndex:deleteIndex];
    [self.pictureView reloadData];
}

#pragma mark - ActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }else if(buttonIndex == 1) {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 - self.pictures.count delegate:self];
        imagePickerVc.allowTakePicture = NO; // 隐藏拍照按钮
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.pictures addObjectsFromArray:photos];
    [self.pictureView reloadData];
}

#pragma mark - pickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //保存原图片到相册中
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera && originalImage) {
        UIImageWriteToSavedPhotosAlbum(originalImage, self, nil, NULL);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.pictures addObject:originalImage];
    [self.pictureView reloadData];
}

#pragma mark - Actions
- (void)returnHomeButtonAction {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)composeButtonAction {
    if (self.textView.text.length == 0) {
        kTipAlert(@"请输入内容");
        return;
    }else if (self.pictures.count == 0) {
        kTipAlert(@"请添加图片");
        return;
    }else if (!self.locationString) {
        kTipAlert(@"请编辑地址");
        return;
    }else if (self.textView.text.length > 100) {
        kTipAlert(@"超过最大(100)字数限制");
        return;
    }
    
    [self.view endEditing:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"发送中...";
    __weak typeof(self) weakSelf = self;
    [[BrickManAPIManager shareInstance] uploadFileWithImages:self.pictures doneBlock:^(NSString *imagePath, NSError *error) {
        if (imagePath) {
            NSDictionary *params = @{@"userId" : [BMUser getUserModel].userId,
                                     @"imgPaths" : imagePath,
                                     @"contentTitle" : self.textView.text,
                                     @"contentPlace" : self.locationString};
            [[BrickManAPIManager shareInstance] requestAddContentWithParams:params andBlock:^(id data, NSError *error) {
                [hud hide:YES];
                if (data) {
                    [weakSelf performSelector:@selector(dismiss) withObject:nil afterDelay:0.5];
                }else {
                    [NSObject showError:error];
                }
            }];
        }else {
            [hud hide:YES];
            [NSObject showError:error];
        }
    } progerssBlock:^(CGFloat progressValue) {
        
    }];
    
}

- (void)dismiss {
    [NSObject showSuccessMsg:@"发布成功"];
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - lazy loading
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        [_tableView registerClass:[BMLocationCell class] forCellReuseIdentifier:kCellIdentifier_BMLocationCell];
    }
    return _tableView;
}

- (UICollectionView *)pictureView {
    if (_pictureView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _pictureView = [[UICollectionView alloc] initWithFrame:CGRectMake (0, 0, kScreen_Width, kScreen_Height - 254) collectionViewLayout:layout];
        [_pictureView registerClass:[ComposePictureCell class]
         forCellWithReuseIdentifier:@"PictureCell"];
        _pictureView.backgroundColor = [UIColor whiteColor];
        _pictureView.contentInset    = UIEdgeInsetsMake (10, 10, 0, 10);
        _pictureView.delegate        = self;
        _pictureView.dataSource      = self;
    }
    return _pictureView;
}

- (void)dealloc {
    self.pictures = nil;
}

@end
