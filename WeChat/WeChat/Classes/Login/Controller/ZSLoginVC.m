//
//  ZSLoginVC.m
//  WeChat
//
//  Created by Vincent_Guo on 2017/4/14.
//  Copyright © 2017年 微信号: vg-ios. All rights reserved.
//

#import "ZSLoginVC.h"
#import "ZSMainVC.h"
#import <Hyphenate/EMSDK.h>

@interface ZSLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation ZSLoginVC
- (IBAction)loginAction:(id)sender {
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    if(username.length == 0 || password.length == 0){
        NSLog(@"用户名和密码不能为空");
        return;
    }
    
    
    //执行登录的请求
    [[EMClient sharedClient] loginWithUsername:username password:password completion:^(NSString *aUsername, EMError *aError) {
       
        if(!aError){
            NSLog(@"登录成功");
            //自动登录(内部会把用户名和密码保存到用户的偏好设置里)
            [[EMClient sharedClient].options setIsAutoLogin:YES];
            
            //进入主界面
            self.view.window.rootViewController = [[ZSMainVC alloc] init];
        }else{
            NSLog(@"登录失败 %zd",aError.code);
            
#warning 如何判断错误消息
            if(aError.code == EMErrorUserAuthenticationFailed){
                NSLog(@"密码错误");
            }
        }
    }];
    
}
- (IBAction)registerAction:(id)sender {
    //同步的请求
//    EMError *error = [[EMClient sharedClient] registerWithUsername:@"8001" password:@"111111"];
//    
//    if (error==nil) {
//        NSLog(@"注册成功");
//    }
    
    //异步
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    if(username.length == 0 || password.length == 0){
        NSLog(@"用户名和密码不能为空");
        return;
    }
    
    [[EMClient sharedClient] registerWithUsername:username password:password completion:^(NSString *aUsername, EMError *aError) {
        if(aError){
            NSLog(@"注册失败");
        }else{
            NSLog(@"注册成功");
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}

@end
