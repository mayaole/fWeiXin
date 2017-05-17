//
//  ZSIdCardCell.h
//  WeChat
//
//  Created by Vincent_Guo on 2017/4/18.
//  Copyright © 2017年 微信号: vg-ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSIdCardCell : UITableViewCell

+(instancetype)senderCellWithTableView:(UITableView *)tableView;

+(instancetype)receiverCellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)EMMessage *message;
@end
