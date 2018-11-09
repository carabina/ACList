//
//  ACBlank.h
//  ACList
//  https://github.com/ablettx/ACList
//
//  Created by ablett on 2018/11/5.
//  Copyright © 2018 ablett. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ACBlankType) {
    ACBlankTypeFailure = 1,                 //加载失败
    ACBlankTypeNoData = 2,                  //暂无数据
    ACBlankTypeNoNetwork = 3,               //暂无网络
};

@interface ACBlank : NSObject

@property (copy, nonatomic) NSString *image;
@property (copy, nonatomic) NSAttributedString *title;
@property (copy, nonatomic) NSAttributedString *desc;

@property (copy, nonatomic) NSString *btnImage;
@property (copy, nonatomic) NSString *btnBackgroundImage;
@property (copy, nonatomic) NSAttributedString *btnTitle;

@property (copy, nonatomic) NSString *backgroundColor;

@property (assign, nonatomic) CGFloat verticalOffset;
@property (assign, nonatomic) CGFloat spaceHeight;

@property (assign, nonatomic) ACBlankType type;

@end

NS_ASSUME_NONNULL_END
