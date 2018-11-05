//
//  BLRefreshHeader.h
//  Beile
//
//  Created by ablett on 2018/11/4.
//  Copyright © 2018 ablett. All rights reserved.
//

#import "MJRefreshStateHeader.h"

@interface BLRefreshHeader : MJRefreshStateHeader
@property (weak, nonatomic, readonly) UIImageView *arrowView;
/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@end
