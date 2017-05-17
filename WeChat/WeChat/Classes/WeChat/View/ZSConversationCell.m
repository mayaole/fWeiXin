//
//  ZSConversationCell.m
//  WeChat
//
//  Created by Vincent_Guo on 2017/4/17.
//  Copyright © 2017年 微信号: vg-ios. All rights reserved.
//

#import "ZSConversationCell.h"
#import "NSDate+Category.h"
#import "DBUtil.h"

@interface ZSConversationCell()
@property (weak, nonatomic) IBOutlet UILabel *mTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mSubTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mUnreadcountLabel;

@end

@implementation ZSConversationCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ZSConversationCell";
    ZSConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    }
    
    return cell;
}


-(void)setConversation:(EMConversation *)conversation{
    _conversation = conversation;
    
    
    if(conversation.type == EMConversationTypeGroupChat){
        //显示群名称
        NSString *groupName = [DBUtil getGroupNameById:conversation.conversationId];
        self.mTitleLabel.text = [NSString stringWithFormat:@"群:%@",groupName];
    }else{//显示好友名字
        self.mTitleLabel.text = conversation.conversationId;
    }
    
    //显示内容
    EMMessage *message = conversation.latestMessage;//最新的一条消息
//    EMMessageBodyTypeText   = 1,    /*! \~chinese 文本类型 \~english Text */
//    EMMessageBodyTypeImage,         /*! \~chinese 图片类型 \~english Image */
//    EMMessageBodyTypeVideo,         /*! \~chinese 视频类型 \~english Video */
//    EMMessageBodyTypeLocation,      /*! \~chinese 位置类型 \~english Location */
//    EMMessageBodyTypeVoice,         /*! \~chinese 语音类型 \~english Voice */
//    EMMessageBodyTypeFile,          /*! \~chinese 文件类型 \~english File */
//    EMMessageBodyTypeCmd,
    if(message.body.type == EMMessageBodyTypeText){//文本消息
        EMTextMessageBody *textBody = (EMTextMessageBody *)message.body;
        self.mSubTitleLabel.text = textBody.text;
    }else if(message.body.type == EMMessageBodyTypeImage){
        self.mSubTitleLabel.text = @"[图片]";
    }else if(message.body.type == EMMessageBodyTypeVoice){
        self.mSubTitleLabel.text = @"[语音]";
    }else{
        self.mSubTitleLabel.text = @"未知消息类型";
    }
    
    
    //显示时间
    NSString *timeStr =  [NSDate formattedTimeFromTimeInterval:message.timestamp];
    self.mTimeLabel.text = timeStr;
    
    
    //显示未读消息数
    int count = [conversation unreadMessagesCount];
    self.mUnreadcountLabel.text = [NSString stringWithFormat:@"%zd",count];
}
@end
