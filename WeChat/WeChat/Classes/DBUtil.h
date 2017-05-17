//
//  DBUtil.h
//  WeChat
//
//  Created by Vincent_Guo on 2017/4/16.
//  Copyright © 2017年 微信号: vg-ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendRequestModel.h"

@interface DBUtil : NSObject

/**
 * 存储好友申请的数据到本地数据库
 */
+(void)saveFriendRequestWithUsername:(NSString *)username message:(NSString *)msg;

/**
 * 获取好友申请的数据条数
 */
+(NSInteger)friendRequestCount;


/**
 *好友申请的列表数据,数组里存<FriendRequestModel>
 */
+(NSArray *)friendRequestList;

+(void)deleteFriendRequestWithUsername:(NSString *)username;

+(NSString *)getGroupNameById:(NSString *)ID;

@end
