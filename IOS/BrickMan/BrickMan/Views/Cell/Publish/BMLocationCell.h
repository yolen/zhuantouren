//
//  BMLocationCell.h
//  BrickMan
//
//  Created by TobyoTenma on 8/9/16.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#define kCellIdentifier_BMLocationCell @"BMLocationCell"
#import <UIKit/UIKit.h>

@interface BMLocationCell : UITableViewCell

@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UIImageView *locationImg;

@end
