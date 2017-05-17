1.如果集成时，遇到image not found的问题
解决办法是:向General → Embedded Binaries 中添加依赖库Hyphenate。


2.自动登录
  需求：
  1.如果曾经登录过，下次启动程序时直接进入到主界面
  2.在后台发送一个登录请求给服务器(当用户第一次登录的时候，把用户名和密码保存到沙盒)

  环信内部已经实现了自动登录的功能
  1.[[EMClient sharedClient].options setIsAutoLogin:YES]; 设置自动登录的开关
  2.[[EMClient sharedClient].options isAutoLogin] == YES 判断用户是否登录过
  3.- (void)autoLoginDidCompleteWithError:(EMError *)aError 自动登录的回调

3.在其它设备登录
  有个代理方法可以监听- (void)userAccountDidLoginFromOtherDevice
  在演示其它设备登录时，一定要设置两个应用的APPKey是一样的

4.好友
  1.实现添加好友的界面
  2.发送 『添加好友的请求』给服务器
  3.监听好友 对申请的回复"但凡是监听的功能，都是通过代理来实现的"
    >添加contact代理
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    >实现两个代理方法
    - (void)friendRequestDidApproveByUser://同意
    - (void)friendRequestDidDeclineByUser://拒绝

  4.显示好友数据
    >默认情况下，好友的数据环信会保存在本地数据库中
    >开发中只需要获取数据库的好友数据就行了
    >如果本地没有好友数据，需要从服务器获取


5.实现通讯录顶部的排版

6.实现监听 "好友的添加申请"
业务
  1>监听 "好友的添加申请"
    实现方式：使用好友模块的代理
  2>保存"好友的添加申请"的数据到本地（sqlite）
    •默认环信内部不会保存"好友的添加申请"的数据
    •创建表 create table if not exists friendrequest (username text,message text);
    •插入数据 insert friendrequest (username,message) values(?,?)
    •使用FMDB -OC框架,cocoapods
  3>设置通讯录tabbarbutton的badge（数字）
  4>设置新朋友的badge
  5>点击 新朋友，显示 "好友的添加申请" 列表
  6>同意&拒绝添加好友
  7>刷新好友的数据
    好友同意了我的请求
    我同意了好友

7.开发中的一些技巧
  .添加pch
  •自定义日志输入（需要带类名和行号）


8.导入EaseUI到项目
1>直接拖入V3.3.1的EaseUI文件夹到项目
2>使用cocopod导入下面的框架
pod 'MBProgressHUD', '~> 0.9'
pod 'SDWebImage', '~> 3.7'
pod 'MJRefresh', '~> 3.1.12'
pod 'MWPhotoBrowser', '~> 2.1.2'
3>在当前自己项目的pch添加下面的内容
#ifdef __OBJC__
#import <UIKit/UIKit.h>
#endif


9.使用EaseUI的聊天界面
  写一个类继承EaseMessageViewController来使用就可以

10.集成EaseUI的聊天界面的问题
  1》不能发图片
     xcode8.0以的版本需要在info.plist配置权限
  2》聊天界面的中英文问题（"多语言国际化集成"）
     a)访问http://blog.sina.com.cn/s/blog_7b9d64af0101jncz.html，添加多国语言的支持
     b)把环信的Demo中的Localizable.strings文件的内容copy到当前项目


11.获取历史会话的数据
12.显示历史会话cell的内容

13.未读消息数和会话列表数据的更新
   步骤
   1.添加chatmanager的代理
   2.未读消息数的更新，监听- (void)messagesDidReceive:(NSArray *)aMessages方法
   3.传话列表的更新,监听-(void)conversationListDidUpdate:(NSArray *)aConversationList

14.设置状态栏的样式
   a>第一种方式，状态栏的样式是由控制器决定的
     •如果通过控制器来实现，你需要自定义一个导航控制器，内部实现-(UIStatusBarStyle)preferredStatusBarStyle
   b>第二方式，可以通过UIApplication来实现,
     •需要在Info.plist配置View controller-based status bar appearance = NO
     •[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
15.表格实现多选的功能
/**
 * 步骤
 1.设置tableView的一个editing属性
 2.实现一个代理方法
 -(UITableViewCellEditingStyle)tableView:editingStyleForRowAtIndexPath:
 3.返回return UITableViewCellEditingStyleDelete |
 UITableViewCellEditingStyleInsert
 */


16.自定义扩展发名片消息
  1.在工具栏添加一个按钮
  2.发送名片消息
  3.显示名片的cell（发送方的cell&接收方的cell）
    a.用xib创建一个cell
  4.在chat控制器里添加自定义的cell,只需要通过代理方法来实现
