//
//  ComposeViewController.m
//  BrickMan
//
//  Created by TobyoTenma on 7/21/16.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import "ComposePictureCell.h"
#import "ComposePictureViewFlowLayout.h"
#import "ComposeTextView.h"
#import "ComposeViewController.h"
#import "BMLocationViewController.h"
#import "BMLocationCell.h"

@interface ComposeViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ComposePictureCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ComposeTextView *textView;
//@property (nonatomic, strong) UISwitch *goodThingSwitch; //好人好事开关
@property (nonatomic, strong) UICollectionView *pictureView;
@property (nonatomic, strong) NSMutableArray<UIImage *> *pictures;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (strong, nonatomic) NSString *locationString;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.images = [NSMutableArray array];
    [self setupNavigationBar];
    [self setupTableView];
}

#pragma mark - UI
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
    self.textView = [[ComposeTextView alloc] initWithFrame:CGRectMake (0, 0, kScreen_Width, 150)];
    self.tableView.tableHeaderView = self.textView;
    self.tableView.tableFooterView = self.pictureView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BMLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.text = @"地点";
    cell.detailTextLabel.text = @"";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) weakSelf = self;
    BMLocationViewController *locationController = [[BMLocationViewController alloc] init];
    locationController.locationFinish = ^(NSString *location){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextLabel.text = location;
        weakSelf.locationString = location;
    };
    [self.navigationController pushViewController:locationController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.pictures.count < 9 ? self.pictures.count + 1 : 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ComposePictureCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"PictureCell" forIndexPath:indexPath];
    cell.composePictureCellDelegate = self;
    if (self.pictures.count == indexPath.item) {
        cell.image = nil;
    } else {
        cell.image = self.pictures[indexPath.item];
    }
    return cell;
}

#pragma mark - ComposePictureCellDelegate
- (void)composePictureCellAddPicture:(ComposePictureCell *)composePictureCell {
    self.selectedIndex              = [self.pictureView indexPathForCell:composePictureCell].item;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate                 = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)composePictureCellDeletePicture:(ComposePictureCell *)composePictureCell {
    
    NSUInteger deleteIndex    = [self.pictureView indexPathForCell:composePictureCell].item;
    NSMutableArray *picturesM = [[NSMutableArray alloc] initWithArray:self.pictures];
    [picturesM removeObjectAtIndex:deleteIndex];
    self.pictures = picturesM.copy;
    [self.pictureView reloadData];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSMutableArray *picturesM = [NSMutableArray arrayWithArray:self.pictures];
    if (self.selectedIndex == self.pictures.count) {
        [picturesM addObject:image];
    } else {
        picturesM[self.selectedIndex] = image;
    }
    self.pictures = picturesM.copy;
    [self.pictureView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Actions
- (void)returnHomeButtonAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)composeButtonAction {
    __weak typeof(self) weakSelf = self;
    [[BrickManAPIManager shareInstance] uploadFileWithImages:self.images doneBlock:^(NSString *imagePath, NSError *error) {
        if (imagePath) {
            NSDictionary *params = @{@"userId" : [BMUser getUserModel].userId,
                                     @"imgPaths" : imagePath,
                                     @"contentTitle" : self.textView.text,
                                     @"contentPlace" : self.locationString};
            [[BrickManAPIManager shareInstance] requestAddContentWithParams:params andBlock:^(id data, NSError *error) {
                if (data) {
                    [NSObject showSuccessMsg:@"发布成功"];
                    [weakSelf.view endEditing:YES];
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                }else {
                    [NSObject showErrorMsg:@"发布失败"];
                }
            }];
        }else {
            [NSObject showError:error];
        }
    } progerssBlock:^(CGFloat progressValue) {
        
    }];
    
}

#pragma mark - lazy loading
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        [_tableView registerClass:[BMLocationCell class] forCellReuseIdentifier:@"TableCell"];
    }
    return _tableView;
}

//- (UISwitch *)goodThingSwitch {
//    if (_goodThingSwitch == nil) {
//        _goodThingSwitch             = [[UISwitch alloc] init];
//        _goodThingSwitch.on          = YES;
//        _goodThingSwitch.onTintColor = RGBCOLOR (251, 101, 52);
//    }
//    return _goodThingSwitch;
//}

- (UICollectionView *)pictureView {
    if (_pictureView == nil) {
        _pictureView =
        [[UICollectionView alloc] initWithFrame:CGRectMake (0, 0, kScreen_Width, kScreen_Width)
                           collectionViewLayout:[[ComposePictureViewFlowLayout alloc] init]];
        [_pictureView registerClass:[ComposePictureCell class]
         forCellWithReuseIdentifier:@"PictureCell"];
        _pictureView.backgroundColor = [UIColor whiteColor];
        _pictureView.contentInset    = UIEdgeInsetsMake (10, 10, 0, 10);
        _pictureView.delegate        = self;
        _pictureView.dataSource      = self;
    }
    return _pictureView;
}

- (void)setImages:(NSArray *)images {
    _images = images;
    if (!self.pictures) {
        self.pictures = [NSMutableArray array];
    }
    [self.pictures addObjectsFromArray:images];
    [self.pictureView reloadData];
}

- (void)dealloc {
    [self.pictures removeAllObjects];
}

@end
