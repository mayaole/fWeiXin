//
//  ZSCreateGroupVC.m
//  WeChat
//
//  Created by Vincent_Guo on 2017/4/18.
//  Copyright © 2017年 微信号: vg-ios. All rights reserved.
//

#import "ZSCreateGroupVC.h"

@interface ZSCreateGroupVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *groupNameField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSArray *contacts;
@property(nonatomic,strong)NSMutableArray *selectedContacts;
@end

@implementation ZSCreateGroupVC

-(NSMutableArray *)selectedContacts{
    if(!_selectedContacts){
        _selectedContacts = [NSMutableArray array];
    }
    
    return _selectedContacts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"创建群";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:0 target:self action:@selector(createGroup)];
    //1.获取好友的数据
    self.contacts = [[EMClient sharedClient].contactManager getContacts];
    
    //2.实现多选的功能
    /**
     * 步骤1.设置tableView的一个editing属性
     * 2.实现一个代理方法
        -(UITableViewCellEditingStyle)tableView:editingStyleForRowAtIndexPath:
     3.返回return UITableViewCellEditingStyleDelete |
     UITableViewCellEditingStyleInsert
     */
    self.tableView.editing = YES;
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete |
    UITableViewCellEditingStyleInsert;
}

- (void)createGroup {
    ZSLog(@"%@",self.selectedContacts);
    //创建群
    
//    *  @param aSubject         群组名称
    NSString *subject = self.groupNameField.text;
//    *  @param aDescription     群组描述
    NSString *desc = @"欢迎来到本群交流";
//    *  @param aInvitees        群组成员（不包括创建者自己）
    NSArray *invitees = self.selectedContacts;
//    *  @param aMessage         邀请消息
    NSString *message = @"welcome";
//    *  @param aSetting         群组属性
    EMGroupOptions *options = [[EMGroupOptions alloc] init];
    options.style = EMGroupStylePublicOpenJoin;//群的类型:公开加入的
//    *  @param aCompletionBlock 完成的回调
    
    
    [[EMClient sharedClient].groupManager createGroupWithSubject:subject description:desc invitees:invitees message:message setting:options completion:^(EMGroup *aGroup, EMError *aError) {
        ZSLog(@"创建群的结果 %@",aError.errorDescription);
    }];
}


//表格的数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contacts.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"CreateGroupContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:ID];
    }
    
    //显示好友名字
    cell.textLabel.text = self.contacts[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //选中
    [self.selectedContacts addObject:self.contacts[indexPath.row]];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //未选中
    [self.selectedContacts removeObject:self.contacts[indexPath.row]];
}

@end
