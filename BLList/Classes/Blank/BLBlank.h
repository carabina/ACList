//
//  BLBlank.h
//  BLList
//  https://github.com/ablettx/BLList
//
//  Created by ablett on 2018/11/5.
//  Copyright © 2018 ablett. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BLBlankType) {
    BLBlankTypeFailure = 1,                 //加载失败
    BLBlankTypeNoData = 2,                  //暂无数据
    BLBlankTypeNoNetwork = 3,               //暂无网络
};

@interface BLBlank : NSObject

@property (copy, nonatomic) NSString *image;
@property (copy, nonatomic) NSAttributedString *title;
@property (copy, nonatomic) NSAttributedString *desc;

@property (copy, nonatomic) NSString *btnImage;
@property (copy, nonatomic) NSString *btnBackgroundImage;
@property (copy, nonatomic) NSAttributedString *btnTitle;

@property (copy, nonatomic) NSString *backgroundColor;

@property (assign, nonatomic) CGFloat verticalOffset;
@property (assign, nonatomic) CGFloat spaceHeight;

@property (assign, nonatomic) BLBlankType type;

@end

NS_ASSUME_NONNULL_END
