//
//  ZSGroupListVC.m
//  WeChat
//
//  Created by Vincent_Guo on 2017/4/18.
//  Copyright © 2017年 微信号: vg-ios. All rights reserved.
//

#import "ZSGroupListVC.h"
#import "ZSCreateGroupVC.h"
#import "ZSChatVC.h"

@interface ZSGroupListVC ()
@property(nonatomic,strong)NSMutableArray *groupListM;
@end

@implementation ZSGroupListVC


-(NSMutableArray *)groupListM{
    if(!_groupListM){
        _groupListM = [NSMutableArray array];
    }
    return _groupListM;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"群列表";
    
    
    //1.添加创建群的按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建群" style:0 target:self action:@selector(gotoCreateGroupVC)];
    
    //2.添加搜索条
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    searchBar.placeholder = @"请输入搜索的群名称";
    self.tableView.tableHeaderView = searchBar;
    
    //3.显示群列表数据
    [self showGroupListData];
}

-(void)showGroupListData{
    //获取群的数据
    NSArray *groupList = [[EMClient sharedClient].groupManager getJoinedGroups];
    
    if(groupList.count == 0){//从服务器获取
//        *  @param aPageNum  获取公开群的cursor，首次调用传空
//        *  @param aPageSize 期望返回结果的数量, 如果 < 0 则一次返回所有结果
//        *  @param aCompletionBlock      完成的回调
        [[EMClient sharedClient].groupManager getJoinedGroupsFromServerWithPage:0 pageSize:-1 completion:^(NSArray *aList, EMError *aError) {
           
            ZSLog(@"从服务器获取所有的群数据 %@",aList);
            [self.groupListM addObjectsFromArray:aList];
            [self.tableView reloadData];
        }];
    }else{
        [self.groupListM addObjectsFromArray:groupList];
        ZSLog(@"从本地获取 %@",groupList);
    }
}

- (void)gotoCreateGroupVC {
    ZSCreateGroupVC *vc = [[ZSCreateGroupVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groupListM.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"groupcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:ID];
    }
    
    //显示群的名称
    EMGroup *group = self.groupListM[indexPath.row];
    cell.textLabel.text = group.subject;
    
    
    return cell;
}

//监听点击事件进入群聊界面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //群信息
    EMGroup *group = self.groupListM[indexPath.row];
    
    //进入聊天界面
    ZSChatVC *chatVc = [[ZSChatVC alloc] initWithConversationChatter:group.groupId conversationType:EMConversationTypeGroupChat];
    [self.navigationController pushViewController:chatVc animated:YES];
}


@end
