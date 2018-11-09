//
//  UIViewController+ACList.h
//  ACList
//  https://github.com/ablettx/ACList
//
//  Created by ablett on 2018/11/5.
//  Copyright © 2018 ablett. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@class ACList;
@interface UIViewController (ACList)

/**
 数据加载
 @param block 刷新配置、数据加载
 */
- (void)loadData:(void(^)(ACList *list))block;

@end

NS_ASSUME_NONNULL_END
