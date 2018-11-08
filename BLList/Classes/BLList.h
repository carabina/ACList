//
//  BLList.h
//  BLList
//  https://github.com/ablettx/BLList
//
//  Created by ablett on 2018/11/5.
//  Copyright © 2018 ablett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+BLList.h"

NS_ASSUME_NONNULL_BEGIN

static int const dataLength = 20;

typedef NS_OPTIONS(NSUInteger, BLLoadType) {
    BLLoadTypeNone = 0,                             //无
    BLLoadTypeNew = 1 << 0,                         //下拉刷新
    BLLoadTypeMore = 1 << 1,                        //上拉加载
    BLLoadTypeAll = BLLoadTypeNew | BLLoadTypeMore  //下拉刷新和上拉加载
};

typedef NS_ENUM(NSUInteger, BLLoadStatus) {
    BLLoadStatusIdle,                               //闲置
    BLLoadStatusNew,                                //下拉刷新
    BLLoadStatusMore,                               //上拉加载
};

/** 快速配置下拉刷新、上拉加载、空白页，适用于 UITableView、UICollectionView、UIScrollView */

@class BLBlank;
@interface BLList : NSObject

/** 空白页 */
@property (strong, nonatomic) BLBlank *blank;

/** 空白页是否可见 */
@property (assign, getter=isBlankEnable, nonatomic) BOOL blankEnable;

/** 加载类型 */
@property (assign, nonatomic) BLLoadType loadType;

/** 加载状态 */
@property (assign, nonatomic) enum BLLoadStatus loadStatus;

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
