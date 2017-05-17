//
//  ZSFirendRequestListVC.m
//  WeChat
//
//  Created by Vincent_Guo on 2017/4/16.
//  Copyright © 2017年 微信号: vg-ios. All rights reserved.
//

#import "ZSFirendRequestListVC.h"
#import "DBUtil.h"
#import <Hyphenate/EMClient.h>

@interface ZSFirendRequestListVC ()

@property(nonatomic,strong)NSMutableArray *friendRquestListM;
@end

@implementation ZSFirendRequestListVC

-(NSMutableArray *)friendRquestListM{
    if(!_friendRquestListM){
        _friendRquestListM = [NSMutableArray array];
    }
    return _friendRquestListM;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"好友申请列表";
    
    //显示数据
    NSArray *list = [DBUtil friendRequestList];
    if(list) [self.friendRquestListM addObjectsFromArray:list];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendRquestListM.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"FriendRequestCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
        //cell的右边添加同意按钮
        UIButton *acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [acceptBtn setTitle:@"同意" forState:UIControlStateNormal];
        [acceptBtn setBackgroundColor:[UIColor grayColor]];
        [acceptBtn sizeToFit];
        
        [acceptBtn addTarget:self action:@selector(acceptAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = acceptBtn;
    }
    
    
    cell.accessoryView.tag = indexPath.row;
    FriendRequestModel  *model = self.friendRquestListM[indexPath.row];
    //显示username
    cell.textLabel.text = model.username;
    //显示message
    cell.detailTextLabel.text = model.messsage;
    
    return cell;
}

-(void)acceptAction:(UIButton *)btn{
    
    NSLog(@"同意 %zd",btn.tag);
    FriendRequestModel *model = self.friendRquestListM[btn.tag];
    
    //1.发送请求给服务器
    [[EMClient sharedClient].contactManager approveFriendRequestFromUser:model.username completion:^(NSString *aUsername, EMError *aError) {
        if(!aError){
            NSLog(@"同意请求发送成功");
            //2.当前记录从数据库删除
            [DBUtil deleteFriendRequestWithUsername:model.username];
            
            //3.当前记录从表格数据源删除
            [self.friendRquestListM removeObject:model];
            
            //4.刷新表格
            [self.tableView reloadData];
        }else{
            NSLog(@"同意请求发送失败");
        }
    }];
    
   
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"删除 %zd",indexPath.row);
    
    FriendRequestModel *model = self.friendRquestListM[indexPath.row];
    
    //1.发送请求给服务器
    [[EMClient sharedClient].contactManager declineFriendRequestFromUser:model.username completion:^(NSString *aUsername, EMError *aError) {
        if(!aError){
            NSLog(@"拒绝请求发送成功");
            //2.当前记录从数据库删除
            [DBUtil deleteFriendRequestWithUsername:model.username];
            
            //3.当前记录从表格数据源删除
            [self.friendRquestListM removeObject:model];
            
            //4.刷新表格
            [self.tableView reloadData];
        }else{
            NSLog(@"拒绝请求发送失败");
        }
    }];

}

@end
