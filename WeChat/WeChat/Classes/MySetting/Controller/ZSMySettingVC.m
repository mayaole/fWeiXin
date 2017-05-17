//
//  ZSMySettingVC.m
//  WeChat
//
//  Created by Vincent_Guo on 2017/4/14.
//  Copyright © 2017年 微信号: vg-ios. All rights reserved.
//

#import "ZSMySettingVC.h"
#import <Hyphenate/EMClient.h>
#import "ZSLoginVC.h"

@interface ZSMySettingVC ()
@property (weak, nonatomic) IBOutlet UILabel *idLabel;

@end

@implementation ZSMySettingVC
- (IBAction)logoutAction:(id)sender {
    
    [[EMClient sharedClient] logout:YES completion:^(EMError *aError) {
        if(!aError){
            NSLog(@"退出成功");
            //切换到登录界面去
            self.view.window.rootViewController = [[ZSLoginVC alloc] init];
        }else{
            NSLog(@"退出失败%@",aError);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    //显示微信的ID
    NSString *loginUsername = [[EMClient sharedClient] currentUsername];
    self.idLabel.text = [NSString stringWithFormat:@"微信ID: %@",loginUsername];
}

@end
