//
//  ZSContactHeaderView.h
//  IM
//
//  Created by Vincent_Guo on 2016/11/7.
//  Copyright © 2016年 微信号: vg-ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSContactHeaderView : UIView

@property(nonatomic,strong)UIView *badgeView;
+(instancetype)headerView;

@property(nonatomic,copy)void (^selectedBlock) (NSInteger index);
@end
