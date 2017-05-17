//
//  ZSIdCardCell.m
//  WeChat
//
//  Created by Vincent_Guo on 2017/4/18.
//  Copyright © 2017年 微信号: vg-ios. All rights reserved.
//

#import "ZSIdCardCell.h"
static NSString *senderID = @"SenderIdCardCell";
static NSString *receiverID = @"ReceiverIdCardCell";

@interface ZSIdCardCell()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ZSIdCardCell
+(instancetype)senderCellWithTableView:(UITableView *)tableView{

    ZSIdCardCell *cell = [tableView dequeueReusableCellWithIdentifier:senderID];
    if(cell == nil){
        cell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    }
    
    return cell;
}

+(instancetype)receiverCellWithTableView:(UITableView *)tableView{
    
    ZSIdCardCell *cell = [tableView dequeueReusableCellWithIdentifier:receiverID];
    if(cell == nil){
        cell = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    }
    
    return cell;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    //设置背景
    NSString *senderBgName = @"EaseUIResource.bundle/chat_sender_bg";
    NSString *receiverBgName = @"EaseUIResource.bundle/chat_receiver_bg";
    
    UIImage *img = nil;
    if([self.reuseIdentifier isEqualToString:senderID]){
        img = [UIImage imageNamed:senderBgName];
    }else{
        img = [UIImage imageNamed:receiverBgName];
    }
    
    //拉伸图片
    img = [img stretchableImageWithLeftCapWidth:img.size.width * 0.7 topCapHeight:img.size.height * 0.7];
    
    self.bgImageView.image = img;
}


-(void)setMessage:(EMMessage *)message{
    _message = message;
    
    //获取扩展
    NSDictionary *ext = message.ext;
    NSString *name = ext[@"name"];
    self.nameLabel.text = name;
}

@end
