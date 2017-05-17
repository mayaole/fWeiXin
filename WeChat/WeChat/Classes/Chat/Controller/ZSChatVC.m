//
//  ZSChatVC.m
//  WeChat
//
//  Created by Vincent_Guo on 2017/4/17.
//  Copyright © 2017年 微信号: vg-ios. All rights reserved.
//

#import "ZSChatVC.h"
#import "DBUtil.h"
#import "ZSIdCardCell.h"

@interface ZSChatVC ()<EaseChatBarMoreViewDelegate,EaseMessageViewControllerDelegate>

@end

@implementation ZSChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //1.标题显示好友名字
    if(self.conversation.type == EMConversationTypeChat){
        //单聊显示好友名称
        NSString *friendName = self.conversation.conversationId;
        self.title = friendName;
    }else if(self.conversation.type == EMConversationTypeGroupChat){
        NSString *groupID = self.conversation.conversationId;
        //显示群的名称(从数据通过id找到名称)
        self.title = [DBUtil getGroupNameById:groupID];
    }
    
    //2.在moreView添加一个子控制
    [self.chatBarMoreView insertItemWithImage:[UIImage imageNamed:@"IDCard"] highlightedImage:nil title:nil];
    self.chatBarMoreView.delegate = self;
    
    //3.实现自定义的聊天cell
    self.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//监听moreView的按钮点击
-(void)moreView:(EaseChatBarMoreView *)moreView didItemInMoreViewAtIndex:(NSInteger)index{
    ZSLog(@"%zd",index);
    /*发名片
     * 环信提供的消息类型：文字、图片、语音、视频、文件、扩展、位置、透传、插入
     * 扩展消息可以用于实现名片、红包、游戏消息。。。
     */

    //构造扩展字典（名片消息）type:1 名片 2：发红包
    NSDictionary *idCardInfo = @{
                                 @"type":@"1",
                                 @"name":@"郭永峰",
                                 @"icon":@"http://xxx/1.png"
                                 };

    [self sendTextMessage:@"名片消息" withExt:idCardInfo];
 
}


-(void)test1{
    //1.创建一个消息体
    EMTextMessageBody *txtBody = [[EMTextMessageBody alloc] initWithText:@"名片消息"];
    
    //2.构造扩展字典（名片消息）type:1 名片 2：发红包
    NSDictionary *idCardInfo = @{
                                 @"type":@"1",
                                 @"name":@"郭永峰",
                                 @"icon":@"http://xxx/1.png"
                                 };
    
    
    //3.构造消息对象
    NSString *to = self.conversation.conversationId;
    NSString *from = [EMClient sharedClient].currentUsername;
    EMMessage *msg = [[EMMessage alloc] initWithConversationID:to from:from to:to body:txtBody ext:idCardInfo];
    
    
    [[EMClient sharedClient].chatManager sendMessage:msg progress:nil completion:^(EMMessage *message, EMError *error) {
        
    }];
}

//聊天控制器的代理
/**
 * 1.下面两个方法返回空和0，表示cell的实现由环信来做
 */
- (UITableViewCell *)messageViewController:(UITableView *)tableView
                       cellForMessageModel:(id<IMessageModel>)messageModel{
    
  
    
    EMMessage *msg = [messageModel message];
    
    //1.获取扩展消息
    NSDictionary *ext = msg.ext;
    if(ext == nil) return nil;//没有自定义扩展
    
    ZSIdCardCell *cell = nil;
    //2.判断名片消息的cell
    if([ext[@"type"] isEqualToString:@"1"]){//名片
        ZSLog(@"%@",ext);
        //判断接收方&发送方
        bool sender = [msg.from isEqualToString:[EMClient sharedClient].currentUsername];
        if(sender){
            cell = [ZSIdCardCell senderCellWithTableView:tableView];
        }else{
            cell = [ZSIdCardCell receiverCellWithTableView:tableView];
        }
        
        //赋值，显示数据
        cell.message = msg;
    }
    
    return cell;
}

-(CGFloat)messageViewController:(EaseMessageViewController *)viewController
           heightForMessageModel:(id<IMessageModel>)messageModel
                 withCellWidth:(CGFloat)cellWidth{
    EMMessage *msg = [messageModel message];
    
    //1.获取扩展消息
    NSDictionary *ext = msg.ext;
    if(ext == nil) return 0;//没有自定义扩展
    
    
    //2.判断名片消息的cell
    if([ext[@"type"] isEqualToString:@"1"]){//名片
        return 100;
    }
    
    return 0;
}
@end
