//
//  BrickListView.m
//  BrickMan
//
//  Created by TZ on 16/7/21.
//  Copyright © 2016年 BrickMan. All rights reserved.
//

#import "BrickListView.h"
#import "MainTableViewCell.h"
#import "ShareView.h"

@interface BrickListView()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) NSArray *imageArray;
@property (strong, nonatomic) NSArray *dataList;
@end

@implementation BrickListView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
        NSData *jsonData = [[NSData alloc] initWithContentsOfFile:resourcePath];
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if (!dict) {
            self.dataList = [NSArray array];
        }
        self.dataList = [dict objectForKey:@"list"];
        
        self.myTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.myTableView.dataSource = self;
        self.myTableView.delegate = self;
        self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.myTableView registerClass:[MainTableViewCell class] forCellReuseIdentifier:kCellIdentifier_MainTableViewCell];
        [self addSubview:self.myTableView];
    }
    return self;
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_MainTableViewCell forIndexPath:indexPath];
    [cell setData:self.dataList[indexPath.row]];
    cell.shareBlock = ^(){
        [ShareView showShareView];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataList[indexPath.row];
    return [MainTableViewCell cellHeightWithImageArray:dic];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataList[indexPath.row];
    if (self.goToDetailBlock) {
        self.goToDetailBlock(dic);
    }
}

#pragma mark - scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollBlock) {
        self.scrollBlock(scrollView.contentOffset.y);
    }
}

@end
