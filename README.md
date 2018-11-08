# BLList

[![CI Status](https://img.shields.io/travis/ablettx/BLList.svg?style=flat)](https://travis-ci.org/ablettx/BLList)
[![Version](https://img.shields.io/cocoapods/v/BLList.svg?style=flat)](https://cocoapods.org/pods/BLList)
[![License](https://img.shields.io/cocoapods/l/BLList.svg?style=flat)](https://cocoapods.org/pods/BLList)
[![Platform](https://img.shields.io/cocoapods/p/BLList.svg?style=flat)](https://cocoapods.org/pods/BLList)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```objective-c

//加载数据
    [self loadData:^(BLList * _Nonnull list) {
        
        //1. 列表刷新配置
        list.loadType = BLLoadTypeAll;
        list.listView = self.tableView;
        [list start];

        //2. 请求数据
        
        //请求参数
        NSDictionary *parameters = @{
                                     @"offset"  : @(list.range.location),
                                     @"number"  : @(list.range.length),
                                     };

        NSLog(@"parameters:%@", parameters);

        void (^requestFinish)(void) = ^(void) {
            //当前加载状态为下拉刷新时移除旧数据
            if (list.loadStatus == BLLoadStatusNew) [self.datas removeAllObjects];
            //3. 添加数据
            for (int i=0; i<20; i++) {
                NSString *obj = [NSString stringWithFormat:@"index:%lu", (unsigned long)list.range.location*list.range.length+i+1];
                [self.datas addObject:obj];
            }
            //4. 刷新
            [list finish];
        };
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), requestFinish);
    }];


```

## Requirements

## Installation

BLList is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BLList'
```

## Author

ablettx, ablettchen@gmail.com

## License

BLList is available under the MIT license. See the LICENSE file for more info.


