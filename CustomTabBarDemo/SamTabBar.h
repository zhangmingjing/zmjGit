//
//  SamTabBar.h
//  CustomTabBarDemo
//
//  Created by zhangMingJing on 2018/3/14.
//  Copyright © 2018年 zhangMingJing. All rights reserved.
//

#import <UIKit/UIKit.h>
//tab页面个数
typedef NS_ENUM(NSInteger, SamItemUIType) {
    SamItemUIType_Three = 3,//底部3个选项
    SamItemUIType_Five = 5,//底部5个选项
};

@class SamTabBar;

@protocol SamTabBarDelegate <NSObject>

-(void)tabBar:(SamTabBar *)tabBar clickCenterButton:(UIButton *)sender;

-(void)tabBar:(SamTabBar *)tabBar clickSystemButton:(UIControl *)control;

@end

@interface SamTabBar : UITabBar

@property (nonatomic, weak) id<SamTabBarDelegate> tabDelegate;
@property (nonatomic, strong) NSString *centerBtnTitle;
@property (nonatomic, strong) NSString *centerBtnIcon;

+(instancetype)instanceCustomTabBarWithType:(SamItemUIType)type;

@end
