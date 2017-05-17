//
//  DBUtil.m
//  WeChat
//
//  Created by Vincent_Guo on 2017/4/16.
//  Copyright © 2017年 微信号: vg-ios. All rights reserved.
//

#import "DBUtil.h"
#import <FMDB/FMDB.h>
#import <Hyphenate/EMClient.h>

@implementation DBUtil

+(void)saveFriendRequestWithUsername:(NSString *)username message:(NSString *)msg{
//    •默认环信内部不会保存"好友的添加申请"的数据
//    •创建表 create table if not exists friendrequest (username text,message text);
//    •插入数据 insert friendrequest (username,message) values(?,?)
//    使用FMDB -OC框架,cocoapods
    
    //1.获取本地的数据库文件路径
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *loginAcount = [EMClient sharedClient].currentUsername;
    NSString *dbPath = [NSString stringWithFormat:@"%@/HyphenateSDK/easemobDB/%@.db",doc,loginAcount];
    
    //2.插入表
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if([db open]){
        NSString *tableSQL = @"create table if not exists friendrequest (username text,message text);";
        [db executeUpdate:tableSQL];
        
        //把以前同名的添加申请给删除
        NSString *deleteSQL = @"delete from friendrequest where username = ?";
        [db executeUpdate:deleteSQL withArgumentsInArray:@[username]];
        
        //3.插入数据
        NSString *insertSQL = @"insert into friendrequest (username,message) values(?,?)";
        BOOL success = [db executeUpdate:insertSQL withArgumentsInArray:@[username,msg]];
        NSLog(@"插入数据的结果 %zd",success);
    }
    
   
    //数据库
    [db close];
}


+(FMDatabase *)db{
    //1.获取本地的数据库文件路径
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *loginAcount = [EMClient sharedClient].currentUsername;
    NSString *dbPath = [NSString stringWithFormat:@"%@/HyphenateSDK/easemobDB/%@.db",doc,loginAcount];
    
    //2.插入表
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    return db;
}
+(NSInteger)friendRequestCount{
    
    NSString *sql = @"select count(*) from friendrequest;";
    FMDatabase *db = [self db];
    if(![db open]) return 0;
    FMResultSet *result = [db executeQuery:sql];
    NSInteger count = 0;
    while(result.next){
        count = [result intForColumnIndex:0];
    }
    [db close];
    
    return count;
}

+(NSArray *)friendRequestList{
    FMDatabase *db = [self db];
    if(![db open]) return nil;
    //1.执行查询的sql语句
    NSString *sql = @"select * from friendrequest";
    FMResultSet *result = [db executeQuery:sql];
    NSMutableArray *arrM = [NSMutableArray array];
    //2.遍历结果
    while(result.next){
        //3.封装成模型添加到数组
        FriendRequestModel *model = [[FriendRequestModel alloc] init];
        model.username = [result stringForColumn:@"username"];
        model.messsage = [result stringForColumn:@"message"];
        [arrM addObject:model];
    }
    
    [db close];
   
    return [arrM copy];
}

+(void)deleteFriendRequestWithUsername:(NSString *)username{
    FMDatabase *db = [self db];
    if(![db open]) return;
    
    [db executeUpdate:@"delete from friendrequest where username = ?" withArgumentsInArray:@[username]];
    [db close];
}

+(NSString *)getGroupNameById:(NSString *)ID{
    
    //sql
    NSString *sql = @"select groupsubject from 'group' where groupid = ?";
    
    //查询
    FMDatabase *db = [self db];
    if(![db open]) return nil;
    
    FMResultSet *result = [db executeQuery:sql withArgumentsInArray:@[ID]];
    NSString *groupName = nil;
    while(result.next){
        groupName = [result stringForColumn:@"groupsubject"];
    }
    
    [db close];
    return groupName;
}
@end
