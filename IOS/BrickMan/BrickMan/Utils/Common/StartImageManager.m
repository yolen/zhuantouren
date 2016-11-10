//
//  StartImageManager.m
//  BrickMan
//
//  Created by TZ on 16/9/1.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#define kStartImageName @"start_image_name"
#import "StartImageManager.h"
#import <AFNetworking.h>
#import "YYModel.h"

@interface StartImageManager()
@property (strong, nonatomic) NSMutableArray *imageLoadedArray;
@property (strong, nonatomic) StartImage *startImage;
@end

@implementation StartImageManager

+ (instancetype)sharedInstance {
    static StartImageManager* instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });

    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self createFolder:[self downloadPath]];
        [self loadStartImage];
    }
    return self;
}

- (StartImage *)randomImage {
    NSInteger count = _imageLoadedArray.count;
    if (count > 0) {
        NSUInteger index = arc4random()%count;
        _startImage = [_imageLoadedArray objectAtIndex:index];
        [self saveDisplayImageName:_startImage.fileName];
    }else {
        _startImage = nil;
    }
    [self refreshAdvertisement];
    return _startImage;
}

- (void)loadStartImage {
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:[self pathOfSTPlist]];
    plistArray = [NSArray yy_modelArrayWithClass:[StartImage class] json:plistArray];
    
    NSMutableArray *imageLoadedArray = [[NSMutableArray alloc] init];
    NSFileManager *fm = [NSFileManager defaultManager];
    for (StartImage *st in plistArray) {
        if ([fm fileExistsAtPath:st.pathDisk]) {
            [imageLoadedArray addObject:st];
        }
    }
    
    //上一次显示的图片，这次就应该把它换掉
    NSString *preDisplayImageName = [self getDisplayImageName];
    if (preDisplayImageName && preDisplayImageName.length > 0) {
        NSInteger index = [imageLoadedArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if ([[(StartImage *)obj fileName] isEqualToString:preDisplayImageName]) {
                *stop = YES;
                return YES;
            }
            return NO;
        }];
        
        if (index != NSNotFound && imageLoadedArray.count > 1) { //imageLoadedArray.count > 1 是因为，如果一共就一张图片，那么即便上次显示了这张图片，也应该再次显示它
            [imageLoadedArray removeObjectAtIndex:index];
        }
    }
    self.imageLoadedArray = imageLoadedArray;
}

#pragma mark - Get Image
- (void)refreshAdvertisement {
    [[BrickManAPIManager shareInstance] requestAdvertisementWithParams:@{@"advertisementType" : @"1"} andBlock:^(id data, NSError *error) {
        if (data) {
            if ([self createFolder:[self downloadPath]]) {
                if (([data writeToFile:[self pathOfSTPlist] atomically:YES])) {
                    [self startDownloadImage];
                }
            }
        }
    }];
}

- (void)startDownloadImage {
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:[self pathOfSTPlist]];
    plistArray = [NSArray yy_modelArrayWithClass:[StartImage class] json:plistArray];
    
    NSMutableArray *needToDownloadArray = [NSMutableArray array];
    NSFileManager *fm = [NSFileManager defaultManager];
    for (StartImage *curST in plistArray) {
        if (![fm fileExistsAtPath:curST.pathDisk]) {
            [needToDownloadArray addObject:curST];
        }
    }
    
    for (StartImage *st in needToDownloadArray) {
        [st startDownloadImage];
    }
}

#pragma mark - Others
- (BOOL)createFolder:(NSString *)path{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    BOOL isCreated = NO;
    if (!(isDir == YES && existed == YES)){
        isCreated = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }else{
        isCreated = YES;
    }
    return isCreated;
}

- (NSString *)downloadPath{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *downloadPath = [documentPath stringByAppendingPathComponent:@"StartImage"];
    return downloadPath;
}

- (NSString *)pathOfSTPlist{
    return [[self downloadPath] stringByAppendingPathComponent:@"startImage.plist"];
}

- (void)saveDisplayImageName:(NSString *)name{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:name forKey:kStartImageName];
    [defaults synchronize];
}

- (NSString *)getDisplayImageName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:kStartImageName];
}

@end


@implementation StartImage

- (NSString *)pathDisk {
    if (!_pathDisk && _advertisementUrl) {
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        _pathDisk = [[docPath stringByAppendingPathComponent:@"StartImage"]
                     stringByAppendingPathComponent:[[_advertisementUrl componentsSeparatedByString:@"/"] lastObject]];
    }
    return _pathDisk;
}

- (NSString *)fileName {
    if (!_fileName && _advertisementUrl) {
        _fileName = [[_advertisementUrl componentsSeparatedByString:@"/"] lastObject];
    }
    return _fileName;
}

- (UIImage *)image{
    return [UIImage imageWithContentsOfFile:self.pathDisk];
}

- (void)startDownloadImage {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.advertisementUrl]];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *pathDisk = [[documentPath stringByAppendingPathComponent:@"StartImage"] stringByAppendingPathComponent:[response suggestedFilename]];
        return [NSURL fileURLWithPath:pathDisk];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        DebugLog(@"downloaded file_path is to: %@", filePath);
    }];
    [downloadTask resume];
}

@end
