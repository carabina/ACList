# ACList

[![CI Status](https://img.shields.io/travis/ablettchen@gmail.com/ACList.svg?style=flat)](https://travis-ci.org/ablettchen@gmail.com/ACList)
[![Version](https://img.shields.io/cocoapods/v/ACList.svg?style=flat)](https://cocoapods.org/pods/ACList)
[![License](https://img.shields.io/cocoapods/l/ACList.svg?style=flat)](https://cocoapods.org/pods/ACList)
[![Platform](https://img.shields.io/cocoapods/p/ACList.svg?style=flat)](https://cocoapods.org/pods/ACList)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

```objectiveC

    //加载数据
    [self loadData:^(ACList * _Nonnull list) {
        
        //1. 列表刷新配置
        list.loadType = ACLoadTypeAll;
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
            if (list.loadStatus == ACLoadStatusNew) [self.datas removeAllObjects];
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

ACList is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ACList'
```

## Author

ablettchen, ablettchen@gmail.com

## License

ACList is available under the MIT license. See the LICENSE file for more info.


