//
//  UIViewController+BLList.m
//  BLList
//  https://github.com/ablettx/BLList
//
//  Created by ablett on 2018/11/5.
//  Copyright © 2018 ablett. All rights reserved.
//

#import "UIViewController+BLList.h"
#import <objc/runtime.h>
#import "BLList.h"
#import "UIScrollView+BLBlank.h"

@interface UIViewController ()
@property (strong, nonatomic) BLList *list;
@property (copy, nonatomic) void (^loadBlock) (BLList *list);
@end

@implementation UIViewController (BLList)

#pragma mark - setter, getter

//- (void)setDatas:(NSMutableArray *)datas {
//    objc_setAssociatedObject(self, @selector(datas), datas, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (NSMutableArray *)datas {
//    NSMutableArray *datas = objc_getAssociatedObject(self, _cmd);
//    if (!datas) {
//        datas = [NSMutableArray array];
//        [self setDatas:datas];
//    }
//    return datas;
//}

- (void)setList:(BLList *)list {
    objc_setAssociatedObject(self, @selector(list), list, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BLList *)list {
    BLList *list = objc_getAssociatedObject(self, _cmd);
    if (!list) {
        list = [BLList new];
        [self setList:list];
    }
    return list;
}

- (void)setLoadBlock:(void (^)(BLList *))loadBlock {
    objc_setAssociatedObject(self, @selector(loadBlock), loadBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(BLList *))loadBlock {
    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark - privite

#pragma mark - public

- (void)loadNew {
    self.list.loadStatus = BLLoadStatusNew;
    self.list.range = NSMakeRange(0, dataLength);
    if (self.loadBlock) {
        self.loadBlock(self.list);
    }
}

- (void)loadMore {
    self.list.loadStatus = BLLoadStatusMore;
    //int loc = ceil((float)self.datas.count/dataLength)?:1;
    int loc = ceil((float)self.list.listView.bl_itemsCount/dataLength)?:1;
    self.list.range = NSMakeRange(loc, dataLength);
    if (self.loadBlock) {
        self.loadBlock(self.list);
    }
}

- (void)loadData:(void(^)(BLList *config))block {
    self.loadBlock = block;
    self.list.listController = self;
    self.list.loadStatus = BLLoadStatusNew;
    self.list.range = NSMakeRange(0, dataLength);
    block(self.list);
}

@end
