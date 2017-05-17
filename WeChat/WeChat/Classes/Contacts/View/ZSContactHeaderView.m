//
//  ZSContactHeaderView.m
//  IM
//
//  Created by Vincent_Guo on 2016/11/7.
//  Copyright © 2016年 微信号: vg-ios. All rights reserved.
//

#import "ZSContactHeaderView.h"

@implementation ZSContactHeaderView

+(instancetype)headerView{
//    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    
    //两个按钮
    ZSContactHeaderView *headerView = [[ZSContactHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 90)];
    return headerView;
}



-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
        [self setupBtn:@"add_friend_icon_offical" title:@" 新朋友"];
        [self setupBtn:@"add_friend_icon_addgroup" title:@" 群聊"];
    }
    
    return self;
}


-(UIView *)badgeView{
    
    if(!_badgeView){
        _badgeView = [[UIView alloc] initWithFrame:CGRectMake(35, 0, 16, 16)];
        _badgeView.backgroundColor = [UIColor redColor];
        _badgeView.layer.cornerRadius = 8;
        _badgeView.layer.masksToBounds = YES;
        [self addSubview:_badgeView];
    }
    
    return _badgeView;
}


-(void)setupBtn:(NSString *)img title:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:0];
    [btn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    btn.tag = self.subviews.count;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

-(void)btnClick:(UIButton *)btn{
    if(_selectedBlock){
        _selectedBlock(btn.tag);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
             btn.frame = CGRectMake(0, btn.tag * 45, [UIScreen mainScreen].bounds.size.width, 44);
        }
       
    }
}


@end
