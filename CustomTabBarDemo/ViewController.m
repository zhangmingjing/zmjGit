//
//  ViewController.m
//  CustomTabBarDemo
//
//  Created by zhangMingJing on 2018/3/14.
//  Copyright © 2018年 zhangMingJing. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
#import "filterViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction)filterBtnClick:(UIBarButtonItem *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    filterViewController *filterVc = [storyboard instantiateViewControllerWithIdentifier:@"filterViewControllerId"];
    [filterVc showAddPrinterViewCompletion:nil];
}

- (IBAction)btnClick:(UIButton *)sender {
    TestViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TestViewControllerId"];
    //self.navigationController.viewControllers = @[vc];
    [self.navigationController setViewControllers:@[vc] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
