//
//  BLList.h
//  Beile
//
//  Created by ablett on 2018/11/4.
//  Copyright © 2018 ablett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+BLList.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BLBlankType) {
    BLBlankTypeFailure = 1,     //加载失败
    BLBlankTypeNoData,          //暂无数据
    BLBlankTypeNoNetwork,       //暂无网络
};

static int const dataLength = 20;

@interface BLBlank : NSObject

@property (copy, nonatomic) NSString *icon;         //图标
@property (copy, nonatomic) NSString *title;        //标题
@property (assign, nonatomic) BLBlankType type;     //空白页类型

@end

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

@class BLListVC;

/** 配置下拉刷新、上拉加载、空白页。适用于 UITableView, UICollectionView, UIScrollView */

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
