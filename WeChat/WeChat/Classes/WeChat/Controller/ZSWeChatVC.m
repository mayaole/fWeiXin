//
//  ZSWeChatVC.m
//  WeChat
//
//  Created by Vincent_Guo on 2017/4/17.
//  Copyright © 2017年 微信号: vg-ios. All rights reserved.
//

#import "ZSWeChatVC.h"
#import "ZSConversationCell.h"
#import "ZSChatVC.h"

@interface ZSWeChatVC ()<EMChatManagerDelegate>

@property(nonatomic,strong)NSMutableArray *conversationsM;
@end

@implementation ZSWeChatVC

-(NSMutableArray *)conversationsM{
    if(!_conversationsM){
        _conversationsM = [NSMutableArray array];
    }
    
    return _conversationsM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取历史会话数据
    NSArray *cons = [[EMClient sharedClient].chatManager getAllConversations];
    [self.conversationsM addObjectsFromArray:cons];
    ZSLog(@"%@",self.conversationsM);
    
//    //显示总的未读消息数
//    [self showTotalUnreadCount];
    
    //添加chatManager代理
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

- (void)showTotalUnreadCount {
    int count = 0;
    for(EMConversation *con in self.conversationsM){
        count += [con unreadMessagesCount];
    }
    
    self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",count];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversationsM.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZSConversationCell *cell = [ZSConversationCell cellWithTableView:tableView];
    
    cell.conversation = self.conversationsM[indexPath.row];
    //显示内容
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//监听接收到新的消息
- (void)messagesDidReceive:(NSArray *)aMessages{
    [self.tableView reloadData];
    [self showTotalUnreadCount];
}

//监听会话列表数据更新
-(void)conversationListDidUpdate:(NSArray *)aConversationList{
    
    //把最新的数据添加到数据源
    [self.conversationsM removeAllObjects];
    [self.conversationsM addObjectsFromArray:aConversationList];
    
    //刷新表格
    [self.tableView reloadData];
    //刷新总的未读消息数
    [self showTotalUnreadCount];
}


//实现此方法，会出现删除按钮
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    //获取删除的好友
    EMConversation *con = self.conversationsM[indexPath.row];
    
    //删除会话
    [[EMClient sharedClient].chatManager deleteConversation:con.conversationId isDeleteMessages:YES completion:^(NSString *aConversationId, EMError *aError) {
        ZSLog(@"删除会话成功");
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //会话对象
    EMConversation *con = self.conversationsM[indexPath.row];
    
    //进入聊天界面
    /**
     * conversationChatter 会话对方的用户名. 如果是群聊, 则是群组的id
     * conversationType 会话类型
     */
    ZSChatVC *chatVc = [[ZSChatVC alloc] initWithConversationChatter:con.conversationId conversationType:con.type];
    chatVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    //刷新未读消息数
    [self.tableView reloadData];
    [self showTotalUnreadCount];
}

@end
