//
//  BrickController.m
//  BrickMan
//
//  Created by 段永瑞 on 16/7/22.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BrickController.h"
#import "Mine_BrickModel.h"
#import "Mine_BrickCell.h"

#define TITLE_FONT [UIFont systemFontOfSize:16]

@interface BrickController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
/**
 *  顶部等级图片和砖数显示视图
 */
@property (nonatomic, strong) UIView *tableHeaderView;
/**
 *  砖数显示视图
 */
@property (nonatomic, strong) UILabel *numberOfBrick;

@end

@implementation BrickController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的砖头";
    
    self.dataList = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[Mine_BrickCell class] forCellReuseIdentifier:kCellIdentifier_Mine_BrickCell];
    
    [self sendRequest];
}

- (void)sendRequest {
    __weak typeof(self) weakSelf = self;
    [[BrickManAPIManager shareInstance] requestMyBrickFlowerWithParams:@{@"type":@"1"} andBlock:^(id data, NSError *error) {
        if (data) {
            [weakSelf.dataList addObjectsFromArray:data];
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Mine_BrickCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Mine_BrickCell forIndexPath:indexPath];
    Mine_BrickModel *model = self.dataList[indexPath.row];
    cell.rankingLbl.text = [NSString stringWithFormat:@"%ld",(long)(indexPath.row + 1)];
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:model.userHead] placeholderImage:[UIImage imageNamed:@"user_icon"]];
    cell.gradeLbl.text = @"砖头";
    cell.nicknameLbl.text = model.userAlias;
    cell.numberLbl.text = [model.count stringValue];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [Mine_BrickCell cellHeight];
}

- (UIView *)tableHeaderView {
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width - 20, 210.f)];
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    UIImageView *brickImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"about_icon"]];
    brickImgView.center = CGPointMake(self.view.center.x, 57.f);
    brickImgView.bounds = CGRectMake(0, 0, 61.f, 61.f);
    [tableHeaderView addSubview:brickImgView];
    self.numberOfBrick = [[UILabel alloc]initWithFrame:CGRectMake(brickImgView.left, brickImgView.bottom, brickImgView.width, 70.f)];
    self.numberOfBrick.font = [UIFont boldSystemFontOfSize:19.f];
    self.numberOfBrick.text = @"52000";
    self.numberOfBrick.textAlignment = NSTextAlignmentCenter;
    [tableHeaderView addSubview:self.numberOfBrick];
    CGFloat cellWidth = kScreen_Width - 20;
    CGFloat rankingLblWidth = cellWidth * 148/1185.f;
    CGFloat headWidth = cellWidth * 258/1185.f;
    CGFloat nicknameLblWidth = cellWidth * 258/1185.f;
    CGFloat gradeLblWidth = cellWidth * 260/1185.f;
    CGFloat numberLblWidth = cellWidth * 261/1185.f;
    UILabel *rankingLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, self.numberOfBrick.bottom, rankingLblWidth, 46.f)];
    rankingLbl.font = TITLE_FONT;
    rankingLbl.text = @"排名";
    rankingLbl.textAlignment = NSTextAlignmentCenter;
    rankingLbl.backgroundColor = RGBCOLOR(240, 239, 254);
    UILabel *head = [[UILabel alloc]initWithFrame:CGRectMake(rankingLbl.right, self.numberOfBrick.bottom, headWidth, rankingLbl.height)];
    head.font = TITLE_FONT;
    head.text = @"头像";
    head.textAlignment = NSTextAlignmentCenter;
    head.backgroundColor = RGBCOLOR(224, 255, 249);
    UILabel *nicknameLbl = [[UILabel alloc]initWithFrame:CGRectMake(head.right, self.numberOfBrick.bottom, nicknameLblWidth, rankingLbl.height)];
    nicknameLbl.font = TITLE_FONT;
    nicknameLbl.text = @"昵称";
    nicknameLbl.textAlignment = NSTextAlignmentCenter;
    nicknameLbl.numberOfLines = 0;
    nicknameLbl.backgroundColor = RGBCOLOR(249, 246, 229);
    UILabel *gradeLbl = [[UILabel alloc]initWithFrame:CGRectMake(nicknameLbl.right, self.numberOfBrick.bottom, gradeLblWidth, rankingLbl.height)];
    gradeLbl.font = TITLE_FONT;
    gradeLbl.text = @"等级";
    gradeLbl.textAlignment = NSTextAlignmentCenter;
    gradeLbl.backgroundColor = RGBCOLOR(253, 238, 240);
    UILabel *numberLbl = [[UILabel alloc]initWithFrame:CGRectMake(gradeLbl.right, self.numberOfBrick.bottom, numberLblWidth, rankingLbl.height)];
    numberLbl.font = TITLE_FONT;
    numberLbl.text = @"砖数";
    numberLbl.textAlignment = NSTextAlignmentCenter;
    numberLbl.backgroundColor = RGBCOLOR(196, 226, 240);
    [tableHeaderView addSubview:rankingLbl];
    [tableHeaderView addSubview:head];
    [tableHeaderView addSubview:nicknameLbl];
    [tableHeaderView addSubview:gradeLbl];
    [tableHeaderView addSubview:numberLbl];
    
    return tableHeaderView;
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, kScreen_Width - 20, kScreen_Height - 64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        _tableView.tableHeaderView = [self tableHeaderView];
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
