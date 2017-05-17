//
//  ZSAddVC.m
//  WeChat
//
//  Created by Vincent_Guo on 2017/4/15.
//  Copyright © 2017年 微信号: vg-ios. All rights reserved.
//

#import "ZSAddVC.h"
#import <Hyphenate/EMClient.h>

@interface ZSAddVC ()
@property (weak, nonatomic) IBOutlet UITextField *friendField;

@end

@implementation ZSAddVC
- (IBAction)addAction:(id)sender {
    
    //1.获取用户输入的名字
    NSString *friendUsername = self.friendField.text;
    
    //2.发送 『添加好友的请求』给服务器
    [[EMClient sharedClient].contactManager addContact:friendUsername message:@"我是你大爷..." completion:^(NSString *aUsername, EMError *aError) {
       
        if(!aError){
            NSLog(@"发送 『添加好友的请求』 成功");
        }else{
            NSLog(@"发送 『添加好友的请求』 失败%zd",aError.code);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"添加好友";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
