//
//  BLList.m
//  Beile
//
//  Created by ablett on 2018/11/4.
//  Copyright © 2018 ablett. All rights reserved.
//

#import "BLList.h"
#import "BLRefreshHeader.h"
#import "BLRefreshAutoFooter.h"

@implementation BLBlank

@end


@interface BLList ()
@property (strong, nonatomic) BLRefreshHeader *header;
@property (strong, nonatomic) BLRefreshAutoFooter *footer;
@end

@implementation BLList

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.loadStatus = BLLoadStatusIdle;
    self.loadType = BLLoadTypeNone;
    self.range = NSMakeRange(0, dataLength);
    
    return self;
}

#pragma mark - setter, getter

- (BLRefreshHeader *)header {
    if (!_header) {
        _header = [BLRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
        // 设置文字
        [_header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        [_header setTitle:@"释放更新" forState:MJRefreshStatePulling];
        [_header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        
        // 设置字体
        _header.stateLabel.font = [UIFont systemFontOfSize:13];
        _header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
        
        // 设置颜色
        _header.stateLabel.textColor = [UIColor colorWithWhite:0.584 alpha:1.000];
        _header.lastUpdatedTimeLabel.textColor = [UIColor colorWithWhite:0.584 alpha:1.000];
        
        // 设置自动切换透明度(在导航栏下面自动隐藏)
        _header.automaticallyChangeAlpha = YES;
        
        // 隐藏时间
        _header.lastUpdatedTimeLabel.hidden = YES;
        
    }
    return _header;
}

- (BLRefreshAutoFooter *)footer {
    if (!_footer) {
        _footer = [BLRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        // 设置文字
        [_footer setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
        [_footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        [_footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
        
        // 设置字体
        _footer.stateLabel.font = [UIFont systemFontOfSize:13];
        
        // 设置颜色
        _footer.stateLabel.textColor = [UIColor colorWithWhite:0.584 alpha:1.000];
        
    }
    return _footer;
}

#pragma mark - privite

- (void)loadNew {
    if (self.listController) [self.listController loadNew];
}

- (void)loadMore {
    if (self.listController) [self.listController loadMore];
}

#pragma mark - public

- (void)start {
    switch (self.loadType) {
        case BLLoadTypeNone:{
            self.listView.mj_header = nil;
            break;
        }
        case BLLoadTypeNew:
        case BLLoadTypeMore:
        case BLLoadTypeAll:{
            self.listView.mj_header = self.header;
            break;
        }
    }
}

- (void)finish {
    
    [self.listView.mj_header endRefreshing];
    
    if (self.loadStatus == BLLoadStatusNew) {
        if (self.listController.datas.count == 0) {
#warning TOFO
            //设置空白页
        }else {
            if (self.loadType == BLLoadTypeAll) {
                if (self.listController.datas.count >= dataLength) {
                    self.listView.mj_footer = self.footer;
                }else {
                    self.listView.mj_footer = nil;
                }
            }
        }
    }else {
        self.listView.mj_footer = self.footer;
    }
    
    [self.listView.mj_footer resetNoMoreData];
    
    if (self.listView && [self.listView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = self.listView;
        [tableView reloadData];
    }else if (self.listView && [self.listView isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = self.listView;
        [collectionView reloadData];
    }else if (self.listView && [self.listView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = self.listView;
        [scrollView setNeedsDisplay];
    }
    self.loadStatus = BLLoadStatusIdle;
}

@end
