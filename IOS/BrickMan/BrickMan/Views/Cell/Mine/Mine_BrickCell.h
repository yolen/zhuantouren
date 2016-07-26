//
//  Mine_BrickCell.h
//  BrickMan
//
//  Created by 段永瑞 on 16/7/26.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mine_BrickModel.h"

@interface Mine_BrickCell : UITableViewCell

@property (nonatomic, strong) Mine_BrickModel *model;

+ (CGFloat)cellHeight;

@end
