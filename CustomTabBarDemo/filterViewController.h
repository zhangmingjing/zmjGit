//
//  filterViewController.h
//  CustomTabBarDemo
//
//  Created by zhangMingJing on 2018/8/8.
//  Copyright © 2018年 zhangMingJing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface filterViewController : UIViewController

-(void)showAddPrinterViewCompletion:(void (^)(void))completion;

-(void)dismissWithCompletion:(void (^)(void))completion;

@end
