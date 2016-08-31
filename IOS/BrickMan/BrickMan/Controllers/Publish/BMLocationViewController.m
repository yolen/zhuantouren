//
//  BMLocationTableViewController.m
//  BrickMan
//
//  Created by TobyoTenma on 8/8/16.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import "BMCity.h"
#import "BMCityList.h"
#import "BMLocationViewController.h"

@interface BMLocationViewController () <UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate>
/**
 *  定位管理工具
 */
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
/**
 *  城市列表 tableView
 */
@property (nonatomic, strong) UITableView *tableView;
/**
 *  当前位置
 */
@property (nonatomic, copy) NSString *currentLocation;
/**
 *  省市列表数据
 */
@property (nonatomic, strong) NSArray<BMCityList *> *cityLists;
@end

@implementation BMLocationViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"地点";
    [self.view addSubview:self.tableView];
    [self getLocationAccess];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cityLists.count + 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else {
        NSArray *cities = [self.cityLists[section - 2] elements];
        return cities.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (self.currentLocation.length == 0) {
            cell.textLabel.text = @"正在获取您当前的位置,请稍后...";
        }else{
            cell.textLabel.text = self.currentLocation;
        }
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"暂无";
    } else {
        NSArray *cities     = [self.cityLists[indexPath.section - 2] elements];
        BMCity *city        = cities[indexPath.row];
        cell.textLabel.text = city.name;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *location = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
    if (self.locationFinish) {
        self.locationFinish(location);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"当前定位城市";
    } else if (section == 1) {
        return @"热门城市";
    } else {
        NSString *title = [self.cityLists[section - 2] title];
        return title;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.cityLists valueForKeyPath:@"title"];
}

#pragma mark - Location
- (void)getLocationAccess {
    // 获取定位权限
    if (![CLLocationManager locationServicesEnabled]) {
        kTipAlert(@"您尚未打开定位服务,请到设置中打开定位服务");
        return;
    }

    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestWhenInUseAuthorization];
        }
    }

    [self.locationManager startUpdatingLocation];
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    [self.geocoder reverseGeocodeLocation:location
                        completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError *_Nullable error) {
             CLPlacemark *lastMark = placemarks.lastObject;
             // 拼接位置信息
             NSString *currentLocation =
             [NSString stringWithFormat:@"%@", lastMark.addressDictionary[@"City"]];
             self.currentLocation = currentLocation;
             if (self.locationFinish) {
                 self.locationFinish(currentLocation);
             }
         }];
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    switch (error.code) {
    case kCLErrorNetwork: {
        kTipAlert(@"网络错误,请检查您的网络连接");
    } break;
    default:
        break;
    }
}

#pragma mark - Getter && Setter
- (void)setCurrentLocation:(NSString *)currentLocation {
    _currentLocation = currentLocation;
    UITableViewCell *cell =
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.textLabel.text = currentLocation;
}

#pragma mark - lazy loading
- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager          = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}
- (CLGeocoder *)geocoder {
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView    = [[UITableView alloc] init];
        CGRect origin = self.view.bounds;
        origin.size.height -= 64;
        self.tableView.frame  = origin;
        _tableView.dataSource = self;
        _tableView.delegate   = self;
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        self.tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        self.tableView.sectionIndexColor = [UIColor colorWithHexString:@"0x666666"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CityCell"];
    }
    return _tableView;
}
- (NSArray<BMCityList *> *)cityLists {
    if (_cityLists == nil) {
        _cityLists = [BMCityList cityList];
    }
    return _cityLists;
}

@end
