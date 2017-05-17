//
//  ZSContactsVC.m
//  WeChat
//
//  Created by Vincent_Guo on 2017/4/15.
//  Copyright © 2017年 微信号: vg-ios. All rights reserved.
//

#import "ZSContactsVC.h"
#import "ZSAddVC.h"
#import "ZSContactHeaderView.h"
#import "DBUtil.h"
#import "ZSFirendRequestListVC.h"
#import "ZSChatVC.h"
#import "ZSGroupListVC.h"

@interface ZSContactsVC ()<EMContactManagerDelegate>
@property(nonatomic,strong)NSMutableArray *contactsM;
@end

@implementation ZSContactsVC

-(NSMutableArray *)contactsM{
    if(!_contactsM){
        _contactsM = [NSMutableArray array];
    }
    
    return _contactsM;
}


-(void)viewWillAppear:(BOOL)animated{
    //显示新朋友的badgeValue
    NSInteger count = [DBUtil friendRequestCount];
    ZSContactHeaderView *headerView = (ZSContactHeaderView *)self.tableView.tableHeaderView;
    headerView.badgeView.hidden = (count == 0);
    
    //更新通讯录的badge
    self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%zd",[DBUtil friendRequestCount]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通讯录";
    
    //添加一个加号按钮
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(toAddPage)];
    self.navigationItem.rightBarButtonItem = addItem;
    
    //显示好友数据
    [self showContactsData];
    
    //添加HeaderView
    [self setupHeaderView];
    
    //添加代理
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
}

-(void)setupHeaderView{
    ZSContactHeaderView *headerView = [ZSContactHeaderView headerView];
    self.tableView.tableHeaderView = headerView;
    
    //监听点击事件
    headerView.selectedBlock = ^(NSInteger index){
    
        UIViewController *vc = nil;
        if(index == 0){//新朋友点击
            //进入好友申请列表界面
           vc = [[ZSFirendRequestListVC alloc] init];
        }else{//群点击
            vc = [[ZSGroupListVC alloc] init];
        }
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
}

-(void)showContactsData{
//    显示好友数据
//    >默认情况下，好友的数据环信会保存在本地数据库中
//    >开发中只需要获取数据库的好友数据就行了
//    >如果本地没有好友数据，需要从服务器获取
    
    //1.获取数据库的好友数据
    NSArray *contacts = [[EMClient sharedClient].contactManager getContacts];
    
    
    //2.如果本地没有好友数据，需要从服务器获取
    if(contacts.count == 0){
        [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
            //获取到好友数据
            [self.contactsM addObjectsFromArray:aList];
            [self.tableView reloadData];
        }];
    }else{
        //本地有数据
        [self.contactsM addObjectsFromArray:contacts];
    }
}

- (void)toAddPage {
    //进入到添加好友的界面
    [self.navigationController pushViewController:[[ZSAddVC alloc] init] animated:YES];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactsM.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:ID];
    }
    
    //显示好友名字
    cell.textLabel.text = self.contactsM[indexPath.row];
    
    return cell;
}



// 好友关系建立
-(void)friendshipDidAddByUser:(NSString *)aUsername{
    NSLog(@"%s",__func__);
    [self.contactsM addObject:aUsername];
    [self.tableView reloadData];
}

//监听cell的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //进入到聊天界面
    NSString *friendUsername = self.contactsM[indexPath.row];
    ZSChatVC *chatVc = [[ZSChatVC alloc] initWithConversationChatter:friendUsername conversationType:EMConversationTypeChat];
    chatVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVc animated:YES];
}
@end
