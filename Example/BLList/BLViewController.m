//
//  BLViewController.m
//  BLList
//
//  Created by ablettx on 11/05/2018.
//  Copyright (c) 2018 ablettx. All rights reserved.
//

#import "BLViewController.h"
#import <BLList.h>

@interface BLViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation BLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
    
    //加载数据
    [self loadData:^(BLList * _Nonnull list) {
        //列表刷新配置
        list.loadType = BLLoadTypeAll;
        list.listView = self.tableView;
        [list start];

        //请求数据
        void (^block)(void) = ^(void) {
            if (list.loadStatus == BLLoadStatusNew) [self.datas removeAllObjects];
            for (int i=0; i<20; i++) {
                NSString *obj = [NSString stringWithFormat:@"index:%lu", (unsigned long)list.range.location*list.range.length+i+1];
                [self.datas addObject:obj];
            }
            [list finish];
        };
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setter, getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.estimatedRowHeight = 0.f;
        _tableView.estimatedSectionHeaderHeight = 0.f;
        _tableView.estimatedSectionFooterHeight = 0.f;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DemoCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DemoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}


@end
