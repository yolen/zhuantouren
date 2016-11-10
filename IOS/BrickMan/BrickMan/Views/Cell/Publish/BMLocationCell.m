//
//  BMLocationCell.m
//  BrickMan
//
//  Created by TobyoTenma on 8/9/16.
//  Copyright © 2016 BrickMan. All rights reserved.
//

#import "BMLocationCell.h"

@implementation BMLocationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if (!self.locationLabel) {
            self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kScreen_Width - 40, 30)];
            self.locationLabel.font= [UIFont systemFontOfSize:14];
            [self.contentView addSubview:self.locationLabel];
        }
        
        if (!self.locationImg) {
            self.locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.locationLabel.right, 10, 20, 20)];
            self.locationImg.contentMode = UIViewContentModeScaleAspectFill;
            self.locationImg.image = [UIImage imageNamed:@"bm_btn_lbs"];
            [self.contentView addSubview:self.locationImg];
        }
    }
    return self;
}

@end
