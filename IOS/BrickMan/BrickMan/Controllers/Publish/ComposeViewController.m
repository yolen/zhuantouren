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


@interface ComposeViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, ComposePictureCellDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
/**
 *  返回 Home
 */
@property (nonatomic, strong) UIButton *returnHomeButton;

/**
 *  发布按钮
 */
@property (nonatomic, strong) UIButton *composeButton;

/**
 *  tableView
 */
@property (nonatomic, strong) UITableView *tableView;
/**
 *  文本输入框
 */
@property (nonatomic, strong) ComposeTextView *textView;
/**
 *  好人好事开关
 */
@property (nonatomic, strong) UISwitch *goodThingSwitch;
/**
 *  选择图片的 CollectionView
 */
@property (nonatomic, strong) UICollectionView *pictureView;
/**
 *  图片数组
 */
@property (nonatomic, strong) NSArray <UIImage *> *pictures;

/**
 *  选中图片下标
 */
@property (nonatomic, assign) NSUInteger selectedIndex;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillLayoutSubviews {
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UI
- (void)setupUI {
    [self setupNavigationBar];

    [self setupTableView];
}


/**
 *  设置 tableView
 */
- (void)setupTableView {
    [self.view addSubview:self.tableView];
    self.textView = [[ComposeTextView alloc] initWithFrame:CGRectMake (0, 0, kScreen_Width, 150)];
    self.tableView.tableHeaderView = self.textView;
    self.tableView.tableFooterView = self.pictureView;
}

/**
 *  设置 nabigationBar
 */
- (void)setupNavigationBar {
    [self.returnHomeButton setImage:[UIImage imageNamed:@"back_arrow"]
                           forState:UIControlStateNormal];
    UIBarButtonItem *returnItem = [[UIBarButtonItem alloc] initWithCustomView:self.returnHomeButton];
    self.navigationItem.leftBarButtonItem = returnItem;
    [self.returnHomeButton sizeToFit];

    [self.composeButton setBackgroundImage:[UIImage imageNamed:@"compose"]
                                  forState:UIControlStateNormal];
    UIBarButtonItem *composeItem = [[UIBarButtonItem alloc] initWithCustomView:self.composeButton];
    self.navigationItem.rightBarButtonItem = composeItem;
    [self.composeButton sizeToFit];

    self.title = @"发布";
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];

    cell.textLabel.font      = PUBLISH_TEXT_FONT_SIZE;
    cell.textLabel.textColor = [UIColor grayColor];

    // 设置 Cell...
    if (indexPath.row == 0) {
        cell.textLabel.text = @"地点";
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.textLabel.text = @"好人好事";
        cell.accessoryView  = self.goodThingSwitch;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.tableView endEditing:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.pictures.count < MAX_SELECTE_PICTURE_NUM ? self.pictures.count + 1 : MAX_SELECTE_PICTURE_NUM;
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
    self.selectedIndex = [self.pictureView indexPathForCell:composePictureCell].item;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)composePictureCellDeletePicture:(ComposePictureCell *)composePictureCell {
    NSUInteger deleteIndex = [self.pictureView indexPathForCell:composePictureCell].item;
    NSMutableArray *picturesM = [[NSMutableArray alloc] initWithArray:self.pictures];
    [picturesM removeObjectAtIndex:deleteIndex];
    self.pictures = picturesM.copy;
    [self.pictureView reloadData];
}


#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSMutableArray *picturesM = [NSMutableArray arrayWithArray:self.pictures];
    if (self.selectedIndex == self.pictures.count) {
        [picturesM addObject:image];
    }else{
        picturesM[self.selectedIndex] = image;
    }
    self.pictures = picturesM.copy;
    [self.pictureView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Actions
/**
 *  直接返回到 Home
 */
- (void)returnHomeButtonAction {
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)composeButtonAction {
    // TODO: 发布
    DebugLog (@"%s", __FUNCTION__);
}

#pragma mark - Getter && Setter
-(void)setImage:(UIImage *)image{
    _image = image;
    NSMutableArray *picturesM = [NSMutableArray arrayWithArray:self.pictures];
    [picturesM addObject:image];
    self.pictures = picturesM.copy;
    [self.pictureView reloadData];
}


#pragma mark - lazy loading
- (UIButton *)returnHomeButton {
    if (_returnHomeButton == nil) {
        _returnHomeButton = [[UIButton alloc] init];
        [_returnHomeButton addTarget:self
                              action:@selector (returnHomeButtonAction)
                    forControlEvents:UIControlEventTouchUpInside];
    }
    return _returnHomeButton;
}

- (UIButton *)composeButton {
    if (_composeButton == nil) {
        _composeButton = [[UIButton alloc] init];
        [_composeButton addTarget:self
                           action:@selector (composeButtonAction)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _composeButton;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableCell"];
    }
    return _tableView;
}

- (UISwitch *)goodThingSwitch {
    if (_goodThingSwitch == nil) {
        _goodThingSwitch             = [[UISwitch alloc] init];
        _goodThingSwitch.on          = YES;
        _goodThingSwitch.onTintColor = RGBCOLOR (251, 101, 52);
    }
    return _goodThingSwitch;
}

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

- (NSArray<UIImage *> *)pictures {
    if (_pictures == nil) {
        _pictures = [[NSArray alloc] init];
    }
    return _pictures;
}

@end
