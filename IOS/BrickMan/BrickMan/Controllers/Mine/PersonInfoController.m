//
//  PersonInfoController.m
//  BrickMan
//
//  Created by 段永瑞 on 16/7/22.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "PersonInfoController.h"
#import "Mine_infoCell.h"
#import "HeadEditController.h"

const static NSString *reuseInfoCell = @"infoCell";

@interface PersonInfoController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSArray *subTitles;

@end

@implementation PersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"compose"] style:UIBarButtonItemStylePlain target:self action:@selector(compose:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (void)compose:(UIBarButtonItem *)sender {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Mine_infoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseInfoCell forIndexPath:indexPath];
    cell.titleLabel.text = self.titles[indexPath.row];
    if (indexPath.row == 0) {
        cell.subImgView.image = [UIImage imageNamed:@"user_icon"];
        [cell.subLabel setHidden:YES];
        [cell.subImgView setHidden:NO];
    } else {
        cell.subLabel.text = self.subTitles[indexPath.row - 1];
        [cell.subLabel setHidden:NO];
        [cell.subImgView setHidden:YES];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            HeadEditController *headEdit = [[HeadEditController alloc]init];
            headEdit.headImgView.image = [UIImage imageNamed:@"user_icon"];
            [self.navigationController pushViewController:headEdit animated:YES];
        }
            break;
        case 1: {
            
        }
            break;
        case 2: {
            
        }
            break;
        case 3: {
            
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(247, 247, 247);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = [Mine_infoCell cellHeight];
        [_tableView registerClass:[Mine_infoCell class] forCellReuseIdentifier:reuseInfoCell];
    }
    return _tableView;
}

- (NSArray *)titles {
    if (!_titles) {
        _titles = @[@"我的头像",@"我的昵称",@"我的性别",@"座右铭"];
    }
    return _titles;
}

- (NSArray *)subTitles {
    if (!_subTitles) {
        _subTitles = @[@"砖头人",@"男",@"路见不平,拍砖相助!"];
    }
    return _subTitles;
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
