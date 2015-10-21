//
//  BlockViewController.m
//  ReactiveCocoaUtilityDemo
//
//  Created by TangJR on 10/21/15.
//  Copyright © 2015 tangjr. All rights reserved.
//

#import "BlockViewController.h"
#import "ReactiveCocoa.h"

@interface BlockViewController ()

@end

@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupRequestSignal];
}

- (void)setupRequestSignal {
    
    RACSignal *signal1 = [self request1];
    RACSignal *signal2 = [self request2];
    
    [[signal1 concat:signal2] subscribeNext:^(id x) {
        
        NSLog(@"%@", x);
    }];
}

- (RACSignal *)request1 {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [subscriber sendNext:@"请求1完成"];
            [subscriber sendCompleted];
        });
        
        return nil;
    }];
}

- (RACSignal *)request2 {
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [subscriber sendNext:@"请求2完成"];
            [subscriber sendCompleted];
        });
        
        return nil;
    }];
}

@end