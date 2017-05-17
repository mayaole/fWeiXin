//
//  ZSConversationCell.h
//  WeChat
//
//  Created by Vincent_Guo on 2017/4/17.
//  Copyright © 2017年 微信号: vg-ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSConversationCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;


@property(nonatomic,strong)EMConversation *conversation;
@end
