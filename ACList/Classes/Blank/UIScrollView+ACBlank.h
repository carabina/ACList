//
//  UIScrollView+ACBlank.h
//  ACList
//  https://github.com/ablettx/ACList
//
//  Created by ablett on 2018/11/5.
//  Copyright © 2018 ablett. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ACBlank;
@interface UIScrollView (ACBlank)

/** 空白页是否可见 */
@property (nonatomic, readonly, getter = isBlankVisible) BOOL blankVisible;

- (void)setBlank:(ACBlank *)blank;

/** 刷新l空白页 */
- (void)reloadBlankData;

- (NSInteger)ac_itemsCount;

@end

NS_ASSUME_NONNULL_END
