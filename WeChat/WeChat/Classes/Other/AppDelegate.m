//
//  AppDelegate.m
//  WeChat
//
//  Created by Vincent_Guo on 2017/4/14.
//  Copyright © 2017年 微信号: vg-ios. All rights reserved.
//

#import "AppDelegate.h"
#import "ZSLoginVC.h"
#import "ZSMainVC.h"
#import "DBUtil.h"
//#import <Hyphenate/EMSDK.h>

@interface AppDelegate ()<EMClientDelegate,EMContactManagerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ZSLog(@"%@",NSHomeDirectory());
    
    // Override point for customization after application launch.
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"vgios#gyfchat"];
//    options.apnsCertName = @"istore_dev";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    
    //添加EMClient的代理
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    
    //添加contactManager的代理
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    
    
    //创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    //设置根控制器
    //如查登录过，要进入到主界面
    if([[EMClient sharedClient].options isAutoLogin] == YES){
        self.window.rootViewController = [[ZSMainVC alloc] init];
        
        //显示联系人的badgeValue
         [self showContactBadgeValue];
    }else{
        self.window.rootViewController = [[ZSLoginVC alloc] init];
    }
    
    
    //设置主窗口并可见
    [self.window makeKeyAndVisible];
    return YES;
}

// APP进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

#pragma mark - EMClient的代理

//自动登录完成时的回调
- (void)autoLoginDidCompleteWithError:(EMError *)aError{
    NSLog(@"自动登录结果  %@",aError);
}


//当前登录账号在其它设备登录时会接收到此回调
- (void)userAccountDidLoginFromOtherDevice{
    //1.回到登录界面
    self.window.rootViewController = [[ZSLoginVC alloc] init];
    
    //2.给用户一个提醒
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"当前帐号在其它设备登录，如非本人操作，请及时修改密码" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark - contactManager的代理
//用户B同意用户A的加好友请求后，用户A会收到这个回调
- (void)friendRequestDidApproveByUser:(NSString *)aUsername{
    NSString *msg =  [NSString stringWithFormat:@"%@ 同意了好友请求",aUsername];
    [self showAlertMessage:msg title:@"好友请求结果"];
}

//用户B拒绝用户A的加好友请求后，用户A会收到这个回调
- (void)friendRequestDidDeclineByUser:(NSString *)aUsername{
//    NSLog(@"%@ 拒绝了好友请求",aUsername);
    NSString *msg =  [NSString stringWithFormat:@"%@ 拒绝了好友请求",aUsername];
    [self showAlertMessage:msg title:@"好友请求结果"];
}


-(void)showAlertMessage:(NSString *)msg title:(NSString *)title{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

//监听好友的添加申请
- (void)friendRequestDidReceiveFromUser:(NSString *)aUsername
                                message:(NSString *)aMessage{
    
    NSLog(@"%@ %@",aUsername,aMessage);
    //保存好友申请的数据到数据库
    [DBUtil saveFriendRequestWithUsername:aUsername message:aMessage];
    
    
    //显示tabbarbutton的badge
    [self showContactBadgeValue];
    
    
}

-(void)showContactBadgeValue{
    UITabBarController *tbContr = (UITabBarController *)self.window.rootViewController;
    UINavigationController *contactNav = tbContr.childViewControllers[1];
    //获取friendRequest的记录条数
    contactNav.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",[DBUtil friendRequestCount]];
}
@end
