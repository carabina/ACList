//
//  ACList.m
//  ACList
//  https://github.com/ablettx/ACList
//
//  Created by ablett on 2018/11/5.
//  Copyright © 2018 ablett. All rights reserved.
//

#import "ACList.h"
#import "ACRefreshHeader.h"
#import "ACRefreshFooter.h"
#import "UIScrollView+ACBlank.h"


@interface ACList ()
@property (strong, nonatomic) ACRefreshHeader *header;
@property (strong, nonatomic) ACRefreshFooter *footer;
@property (strong, nonatomic) NSArray <ACBlank *>*blanks;
@end

@implementation ACList

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    self.loadStatus = ACLoadStatusIdle;
    self.loadType = ACLoadTypeNone;
    self.range = NSMakeRange(0, dataLength);
    
    
    return self;
}

#pragma mark - setter, getter

- (ACRefreshHeader *)header {
    if (!_header) {
        _header = [ACRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNew)];
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

- (ACRefreshFooter *)footer {
    if (!_footer) {
        _footer = [ACRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
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
    SEL selector = NSSelectorFromString(@"loadNew");
    if (self.listController && [self.listController respondsToSelector:selector]) {
        [self.listController performSelector:selector withObject:nil afterDelay:0.0f];
    }
}

- (void)loadMore {
    SEL selector = NSSelectorFromString(@"loadMore");
    if (self.listController && [self.listController respondsToSelector:selector]) {
        [self.listController performSelector:selector withObject:nil afterDelay:0.0f];
    }
}

#pragma mark - public

- (void)start {
    switch (self.loadType) {
        case ACLoadTypeNone:{
            self.listView.mj_header = nil;
            break;
        }
        case ACLoadTypeNew:
        case ACLoadTypeMore:
        case ACLoadTypeAll:{
            self.listView.mj_header = self.header;
            break;
        }
    }
}

- (void)finish {
    
    [self.listView.mj_header endRefreshing];
    
    if (self.loadStatus == ACLoadStatusNew) {
        if (self.listView.ac_itemsCount == 0) {
            //设置空白页
            
            //待完善...
            
            //self.blank =
            
            
        }else {
            if (self.loadType == ACLoadTypeAll) {
                if (self.listView.ac_itemsCount >= dataLength) {
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
    self.loadStatus = ACLoadStatusIdle;
}

@end
