//
//  SearchViewController.m
//  ReactiveCocoaUtilityDemo
//
//  Created by TangJR on 10/21/15.
//  Copyright © 2015 tangjr. All rights reserved.
//

#import "SearchViewController.h"
#import "ReactiveCocoa.h"

@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSearchSignal];
}

- (void)setupSearchSignal {
    
    @weakify(self);
    [[[[[self.searchTextField.rac_textSignal
    // 先将不合法的搜索词过滤掉（返回的bool值决定了signal是否继续向下传递）
    filter:^BOOL(NSString *searchKeyword) {
        
        return @(searchKeyword.length);
    }]
    // 因为没必要每次一输入便进行网络请求，所以0.5s之后，才进行搜索。(throttle是在规定时间后，信号继续向下传递)
    throttle:0.5]
    // 网络请求将会返回signal，所以直接使用flattenMap来映射，而不必用map
    flattenMap:^RACStream *(NSString *searchKeyword) {
        
        @strongify(self);
        // 发起网络请求
        return [self searchWithKeyword:searchKeyword];
    }]
    // 回到主线程，因为在signal订阅中可能更新界面
    deliverOnMainThread]
    // 订阅网络请求返回的信号
    subscribeNext:^(id x) {
        
        NSLog(@"%@", x);
    }];
}

- (RACSignal *)searchWithKeyword:(NSString *)keyword {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 模拟网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [subscriber sendNext:keyword];
            [subscriber sendCompleted];
        });
        
        return nil;
    }];
}

@end