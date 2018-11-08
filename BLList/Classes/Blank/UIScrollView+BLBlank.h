//
//  UIScrollView+BLBlank.h
//  BLList
//  https://github.com/ablettx/BLList
//
//  Created by ablett on 2018/11/5.
//  Copyright © 2018 ablett. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BLBlank;
@interface UIScrollView (BLBlank)

/** 空白页是否可见 */
@property (nonatomic, readonly, getter = isBlankVisible) BOOL blankVisible;

- (void)setBlank:(BLBlank *)blank;

/** 刷新l空白页 */
- (void)reloadBlankData;

- (NSInteger)bl_itemsCount;

@end

NS_ASSUME_NONNULL_END
