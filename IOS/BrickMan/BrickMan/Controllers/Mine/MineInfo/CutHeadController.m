//
//  CutHeadController.m
//  BrickMan
//
//  Created by 段永瑞 on 16/7/22.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "CutHeadController.h"
#import "HeadEditController.h"

@interface CutHeadController ()<UIScrollViewDelegate> {
    CGFloat _rate;
    CGFloat _offsetWidth;
    CGFloat _offsetHeight;
}

@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *cutView;
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation CutHeadController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scale = 1.f;
    self.title = @"移动与裁剪";
    self.view.layer.masksToBounds = YES;
    self.view.backgroundColor = [UIColor blackColor];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(submitHeadImage:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.imgView.center = CGPointMake(self.scrollView.center.x * 2, self.scrollView.center.y * 2);
    self.imgView.image = self.image;
    if (self.image.size.height/self.image.size.width > (kScreen_Height - 64)/kScreen_Width) {
        self.imgView.frame = CGRectMake(0, 0, (kScreen_Height - 64) * self.image.size.width/self.image.size.height, kScreen_Height - 64);
    } else {
        self.imgView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Width * self.image.size.height/self.image.size.width);
    }
    
    self.scrollView.bounds = CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64);
    self.scrollView.center = CGPointMake(self.view.center.x, self.view.center.y - 32);
    self.scrollView.minimumZoomScale = self.imgView.width > self.imgView.height?self.cutView.width / self.imgView.height : self.cutView.width / self.imgView.width;
    CGFloat insetWidth = kScreen_Width/2 - self.cutView.width/2;
    CGFloat insetHeight = (kScreen_Height - 64)/2 - self.cutView.height/2;
    self.scrollView.contentInset = UIEdgeInsetsMake(insetHeight, insetWidth, insetHeight, insetWidth);
    self.scrollView.contentSize = CGSizeMake(self.imgView.width, self.imgView.height);
    [self.scrollView addSubview:self.imgView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.cutView];
    _offsetWidth = self.imgView.width/2 - self.cutView.width/2;
    _offsetHeight = self.imgView.height/2 - self.cutView.height/2;
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + _offsetWidth, self.scrollView.contentOffset.y + _offsetHeight);
    // Do any additional setup after loading the view.
}

- (void)submitHeadImage:(UIBarButtonItem *)sender {
    _rate = self.image.size.width / self.imgView.width;
    UIImage *image = self.imgView.image;
    CGPoint origin = CGPointMake(0, 0);
    NSLog(@"%f",_rate);
    origin.x = (self.scrollView.contentOffset.x + self.scrollView.contentInset.left) * _rate;
    origin.y = (self.scrollView.contentOffset.y + self.scrollView.contentInset.top) * _rate;
    UIImage *newImage = [self image:image NewSize:CGSizeMake(_rate * self.cutView.width, _rate * self.cutView.width) newOrigin:CGPointMake(origin.x, origin.y)];
    
    
    __weak typeof(self) weakSelf = self;
    [[BrickManAPIManager shareInstance] uploadFileWithImages:@[newImage] doneBlock:^(NSString *imagePath, NSError *error) {
        if (imagePath) {
            BMUser *user = [BMUser getUserModel];
            [[BrickManAPIManager shareInstance] requestUpdateUserInfoWithParams:@{@"userId" : user.userId, @"userHead" : imagePath} andBlock:^(id data, NSError *error) {
                if (data) {
                    [NSObject showSuccessMsg:@"更换头像成功"];
                    if (weakSelf.updateBlock) {
                        weakSelf.updateBlock(imagePath);
                    }
                    //刷新数据
                    [[BrickManAPIManager shareInstance] requestUserInfoWithParams:@{@"userId" : [BMUser getUserModel].userId} andBlock:^(id data, NSError *error) {
                        if (data) {
                            [BMUser saveUserInfo:data];
                        }
                    }];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_RefreshUserInfo object:nil];
                    HeadEditController *headEdit = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2];
                    headEdit.headImgView.image = newImage;
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    } progerssBlock:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.imgView.width < self.cutView.width || self.imgView.height < self.cutView.height) {
        [MBProgressHUD showError:@"照片尺寸不符合要求,请重新选择"];
        [self performSelector:@selector(dismiss:) withObject:nil afterDelay:0.8];
    }
}

- (void)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    self.scale = scrollView.zoomScale;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imgView;
}

- (UIImage *)image:(UIImage *)image NewSize:(CGSize)size newOrigin:(CGPoint)origin{
    CGImageRef imgRef =  CGImageCreateWithImageInRect(image.CGImage, CGRectMake(origin.x, origin.y, size.width,size.height));
    return [UIImage imageWithCGImage:imgRef];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.bounces = YES;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIView *)cutView {
    if (!_cutView) {
        _cutView = [[UIView alloc] init];
        _cutView.userInteractionEnabled = NO;
        _cutView.bounds = CGRectMake(0, 0, kScreen_Width/2, kScreen_Width/2);
        _cutView.center = CGPointMake(self.view.center.x, self.view.center.y - 32);
        _cutView.backgroundColor = [UIColor clearColor];
        CAShapeLayer *shapLayer = [[CAShapeLayer alloc]init];
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        CGFloat lineWidth = (sqrt(pow(kScreen_Width, 2) + pow(kScreen_Height - 64, 2)) - self.cutView.width)/2;
        [bezierPath addArcWithCenter:CGPointMake(_cutView.width/2, _cutView.height/2)
                              radius:_cutView.width/2 + lineWidth/2
                          startAngle:0
                            endAngle:360 *M_PI/180
                           clockwise:YES];
        shapLayer.path = bezierPath.CGPath;
        shapLayer.lineWidth = lineWidth;
        shapLayer.fillColor = [UIColor clearColor].CGColor;
        shapLayer.strokeColor = [UIColor colorWithWhite:.1 alpha:.5].CGColor;
        shapLayer.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.2].CGColor;
        [_cutView.layer addSublayer:shapLayer];
    }
    return _cutView;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
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
