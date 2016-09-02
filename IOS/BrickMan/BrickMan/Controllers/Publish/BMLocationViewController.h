//
//  BMLocationTableViewController.h
//  BrickMan
//
//  Created by TobyoTenma on 8/8/16.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMLocationViewController : UIViewController

@property (nonatomic, copy) void (^locationFinish)(NSString *location);

@end
