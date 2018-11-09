//
//  ACList.h
//  ACList
//  https://github.com/ablettx/ACList
//
//  Created by ablett on 2018/11/5.
//  Copyright © 2018 ablett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+ACList.h"

NS_ASSUME_NONNULL_BEGIN

static int const dataLength = 20;

typedef NS_OPTIONS(NSUInteger, ACLoadType) {
    ACLoadTypeNone = 0,                             //无
    ACLoadTypeNew = 1 << 0,                         //下拉刷新
    ACLoadTypeMore = 1 << 1,                        //上拉加载
    ACLoadTypeAll = ACLoadTypeNew | ACLoadTypeMore  //下拉刷新和上拉加载
};

typedef NS_ENUM(NSUInteger, ACLoadStatus) {
    ACLoadStatusIdle,                               //闲置
    ACLoadStatusNew,                                //下拉刷新
    ACLoadStatusMore,                               //上拉加载
};

/** 快速配置下拉刷新、上拉加载、空白页，适用于 UITableView、UICollectionView、UIScrollView */

@class ACBlank;
@interface ACList : NSObject

/** 空白页 */
@property (strong, nonatomic) ACBlank *blank;

/** 空白页是否可见 */
@property (assign, getter=isBlankEnable, nonatomic) BOOL blankEnable;

/** 加载类型 */
@property (assign, nonatomic) ACLoadType loadType;

/** 加载状态 */
@property (assign, nonatomic) enum ACLoadStatus loadStatus;

/** 数据范围 */
@property (assign, nonatomic) NSRange range;

/** 目标View */
@property (strong, nonatomic) __kindof UIScrollView *listView;

/** 所属的listvc */
@property (strong, nonatomic) __kindof UIViewController *listController;

/** 开始加载 */
- (void)start;

/** 结束加载 */
- (void)finish;

@end

NS_ASSUME_NONNULL_END
