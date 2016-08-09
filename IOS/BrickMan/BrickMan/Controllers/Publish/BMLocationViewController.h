//
//  BMLocationTableViewController.h
//  BrickMan
//
//  Created by TobyoTenma on 8/8/16.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMLocationViewController : UIViewController
/**
 *  定位成功后回调,显示位置到发布页面
 */
@property (nonatomic, copy) void (^locationFinish)(NSString *location);

@end
