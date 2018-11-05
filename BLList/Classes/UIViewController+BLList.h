//
//  UIViewController+BLList.h
//  Beile
//
//  Created by ablett on 2018/11/5.
//  Copyright © 2018 ablett. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@class BLList;
@interface UIViewController (BLList)

/** 数据 */
@property (strong, nonatomic) NSMutableArray *datas;

/** 下拉刷新 */
- (void)loadNew;

/** 上拉加载 */
- (void)loadMore;

/**
 数据加载
 @param block 刷新配置、数据加载
 */
- (void)loadData:(void(^)(BLList *list))block;

@end

NS_ASSUME_NONNULL_END
