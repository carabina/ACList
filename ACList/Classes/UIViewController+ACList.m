//
//  UIViewController+ACList.m
//  ACList
//  https://github.com/ablettx/ACList
//
//  Created by ablett on 2018/11/5.
//  Copyright © 2018 ablett. All rights reserved.
//

#import "UIViewController+ACList.h"
#import <objc/runtime.h>
#import "ACList.h"
#import "UIScrollView+ACBlank.h"

@interface UIViewController ()
@property (strong, nonatomic) ACList *list;
@property (copy, nonatomic) void (^loadBlock) (ACList *list);
@end

@implementation UIViewController (ACList)

#pragma mark - setter, getter

- (void)setList:(ACList *)list {
    objc_setAssociatedObject(self, @selector(list), list, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ACList *)list {
    ACList *list = objc_getAssociatedObject(self, _cmd);
    if (!list) {
        list = [ACList new];
        [self setList:list];
    }
    return list;
}

- (void)setLoadBlock:(void (^)(ACList *))loadBlock {
    objc_setAssociatedObject(self, @selector(loadBlock), loadBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(ACList *))loadBlock {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - privite

#pragma mark - public

- (void)loadNew {
    self.list.loadStatus = ACLoadStatusNew;
    self.list.range = NSMakeRange(0, dataLength);
    if (self.loadBlock) {
        self.loadBlock(self.list);
    }
}

- (void)loadMore {
    self.list.loadStatus = ACLoadStatusMore;
    int loc = ceil((float)self.list.listView.ac_itemsCount/dataLength)?:1;
    self.list.range = NSMakeRange(loc, dataLength);
    if (self.loadBlock) {
        self.loadBlock(self.list);
    }
}

- (void)loadData:(void(^)(ACList *config))block {
    self.loadBlock = block;
    self.list.listController = self;
    self.list.loadStatus = ACLoadStatusNew;
    self.list.range = NSMakeRange(0, dataLength);
    block(self.list);
}

@end
