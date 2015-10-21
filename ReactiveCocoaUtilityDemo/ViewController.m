//
//  ViewController.m
//  ReactiveCocoaUtilityDemo
//
//  Created by TangJR on 10/21/15.
//  Copyright © 2015 tangjr. All rights reserved.
//

/*
 案例一：登录或注册时的输入基本验证
 
 假设验证条件如下：
 
 用户名：在1-16位之间
 密码：在1-16位之间
 确认密码：与密码相同
 
 当以上3个条件均成功，则登录按钮可点击
 */

#import "ViewController.h"
#import "ReactiveCocoa.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *comfirmTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupRegisterButtonEnableSignal];
}

// 设置注册按钮是否可用的信号

- (void)setupRegisterButtonEnableSignal {
    
    // 设置用户名是否合法的信号
    // map用于改变信号返回的值，在信号中判断后，返回bool值
    RACSignal *usernameSignal = [self.usernameTextField.rac_textSignal map:^id(NSString *usernameText) {
        
        NSUInteger length = usernameText.length;
        
        if (length >= 1 && length <= 16) {
            return @(YES);
        }
        
        return @(NO);
    }];
    
    // 设置密码是否合法的信号
    RACSignal *passwordSignal = [self.passwordTextField.rac_textSignal map:^id(NSString *passwordText) {
        
        NSUInteger length = passwordText.length;
        
        if (length >= 1 && length <= 16) {
            return @(YES);
        }
        
        return @(NO);
    }];
    
    // 设置确认密码合法的信号
    // 因为确认密码的文本要和密码的文本有关联，无论确认密码修改还是密码修改，都需要及时判断，所以需要绑定两个信号量
    RACSignal *comfirmSignal = [RACSignal combineLatest:@[self.passwordTextField.rac_textSignal, self.comfirmTextField.rac_textSignal] reduce:^id(NSString *passwordText, NSString *comfirmText){
        
        NSUInteger length = comfirmText.length;
        
        if (length >= 1 && [comfirmText isEqualToString:passwordText]) {
            return @(YES);
        }
        return @(NO);
    }];
    
    // 绑定用户名、密码、确认密码判断结果的三个信号量，如果三个都为真，则按钮可用
    RAC(self.registerButton, enabled) = [RACSignal combineLatest:@[usernameSignal, passwordSignal, comfirmSignal] reduce:^(NSNumber *isUsernameCorrect, NSNumber *isPasswordCorrect, NSNumber *isComfirmCorrect){
        
        return @(isUsernameCorrect.boolValue && isPasswordCorrect.boolValue && isComfirmCorrect.boolValue);
    }];
}

@end