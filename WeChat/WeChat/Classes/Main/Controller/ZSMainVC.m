//
//  ZSMainVC.m
//  WeChat
//
//  Created by Vincent_Guo on 2017/4/14.
//  Copyright © 2017年 微信号: vg-ios. All rights reserved.
//

#import "ZSMainVC.h"
#import "ZSContactsVC.h"
#import "ZSWeChatVC.h"

@interface ZSMainVC ()

@end

@implementation ZSMainVC

+(void)initialize{
    //类第一次加载时调用,在此方法设置所有的主题
    //1.设置UITabbar的文字颜色
    [UITabBar appearance].tintColor = [UIColor colorWithRed:0 green:188/255.0 blue:39/255.0 alpha:1];
    
    //2.设置导航栏背景
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_64"] forBarMetrics:UIBarMetricsDefault];
    
    //3.设置导航栏的文字颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //4.设置导航栏的item也为白色
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    
    //5.设置状态栏的样式（白色）,需要在Info.plist配置
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加3个子控制器
    ZSWeChatVC *vc1 = [[ZSWeChatVC alloc] init];
    [self addChildVcToTabBarController:vc1 title:@"WeChat" normalImg:@"tabbar_mainframe" selectedImg:@"tabbar_mainframeHL"];
    ZSContactsVC *vc2 = [[ZSContactsVC alloc] init];
    [self addChildVcToTabBarController:vc2 title:@"通讯录" normalImg:@"tabbar_contacts" selectedImg:@"tabbar_contactsHL"];
    
    
    UIViewController *vc3 = [UIStoryboard storyboardWithName:@"MySetting" bundle:nil].instantiateInitialViewController;
    [self addChildVcToTabBarController:vc3 title:@"我的设置" normalImg:@"tabbar_me" selectedImg:@"tabbar_meHL"];
    
    
}

//添加tabar控制器的子控制器
-(void)addChildVcToTabBarController:(UIViewController *)vc title:(NSString *)title normalImg:(NSString *)nmlImg selectedImg:(NSString *)sltImg{
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    //设置tabbar的标题
    nav.tabBarItem.title = title;
    
    //设置普通和选中状态的图片
    nav.tabBarItem.image = [UIImage imageNamed:nmlImg];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:sltImg];
    
    [self addChildViewController:nav];
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
//在控制器中实现此方法可以设置状态栏的样式
#warning 在此位置设置样式是无效，应该在导航控制器实现这个方法
-(UIStatusBarStyle)preferredStatusBarStyle{
    return  UIStatusBarStyleLightContent;
}

@end
