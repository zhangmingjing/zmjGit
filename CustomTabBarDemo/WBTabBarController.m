//
//  WBTabBarController.m
//  CustomTabBarDemo
//
//  Created by zhangMingJing on 2018/3/14.
//  Copyright © 2018年 zhangMingJing. All rights reserved.
//

#import "WBTabBarController.h"
#import "SamTabBar.h"
#import "FristViewController.h"
#import "SecondFristViewController.h"
#import "HyPopMenuView.h"

@interface WBTabBarController ()<SamTabBarDelegate,HyPopMenuViewDelegate,UITabBarDelegate>

@property (nonatomic, strong) HyPopMenuView* menu;

@end

@implementation WBTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self configPopMenuView];
}

-(void)setupUI{
    [self setupVC];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    //kvo形式添加自定义的 UITabBar
    SamTabBar *tab = [SamTabBar instanceCustomTabBarWithType:SamItemUIType_Three];
    //tab.centerBtnTitle = @"发布";
    tab.centerBtnIcon = @"add";
    tab.tabDelegate = self;
    tab.delegate = self;
    [self setValue:tab forKey:@"tabBar"];
    
    //去除顶部很丑的border
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    
    //自定义分割线颜色
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(self.tabBar.bounds.origin.x-0.5, self.tabBar.bounds.origin.y, self.tabBar.bounds.size.width+1, self.tabBar.bounds.size.height+2)];
    bgView.layer.borderColor = [UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0].CGColor;
    bgView.layer.borderWidth = 0.5;
    [tab insertSubview:bgView atIndex:0];
    tab.opaque = YES;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//    UIView *animationView;
//    Class class = NSClassFromString(@"UITabBarButton");
//    Class btnClass = [UIButton class];
//    for (UIView *view in tabBar.subviews) {
//        if ([view isKindOfClass:btnClass]) {//self.centerButton
//            NSLog(@"sss");
//        }else if ([view isKindOfClass:class]){
//            NSLog(@"hahah");
//            for (UIView *subView in view.subviews) {
//                if ([subView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
//                    animationView = subView;
//                }
//            }
//        }
//    }
//
//    //[self addScaleAnimationOnView:animationView];
//    [self addRotateAnimationOnView:animationView];
}

-(void)tabBar:(SamTabBar *)tabBar clickSystemButton:(UIControl *)control{
    UIView *animationView;
    for (UIView *subView in control.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            animationView = subView;
        }
    }
    [self addRotateAnimationOnView:animationView];
}

//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.repeatCount = 1;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

//旋转动画
- (void)addRotateAnimationOnView:(UIView *)animationView {
    // 针对旋转动画，需要将旋转轴向屏幕外侧平移，最大图片宽度的一半
    // 否则背景与按钮图片处于同一层次，当按钮图片旋转时，转轴就在背景图上，动画时会有一部分在背景图之下。
    // 动画结束后复位
    animationView.layer.zPosition = 65.f / 2;
    [UIView animateWithDuration:0.32 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        animationView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.70 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            animationView.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0, 1, 0);
        } completion:nil];
    });
}

- (void)setupVC{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *navc1 = [storyBoard instantiateViewControllerWithIdentifier:@"FristViewControllerId"];
    UINavigationController *navc2 = [storyBoard instantiateViewControllerWithIdentifier:@"SecondFristViewControllerId"];
    [self addChildVc:navc1.viewControllers[0] title:@"工作台" image:@"autoDamage" selectedImage:@"autoDamage"];
    [self addChildVc:navc2.viewControllers[0] title:@"发现" image:@"weChatCode" selectedImage:@"weChatCode"];
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
    childVc.title = title;
    // 设置子控制器的tabBarItem图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    // 禁用图片渲染
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置文字的样式
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateSelected];
    // 添加子控制器
    [self addChildViewController:childVc.navigationController];
}

-(void)tabBar:(SamTabBar *)tabBar clickCenterButton:(UIButton *)sender{
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"点击了中间按钮" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [alert addAction:action];
//    [self presentViewController:alert animated:YES completion:nil];
    
    _menu.backgroundType = HyPopMenuViewBackgroundTypeLightBlur;
    [_menu openMenu];
}

-(void)configPopMenuView{
    _menu = [HyPopMenuView sharedPopMenuManager];
    PopMenuModel* model = [PopMenuModel
                           allocPopMenuModelWithImageNameString:@"tabbar_compose_idea"
                           AtTitleString:@"新建接车"
                           AtTextColor:[UIColor grayColor]
                           AtTransitionType:PopMenuTransitionTypeCustomizeApi
                           AtTransitionRenderingColor:nil];
    
    PopMenuModel* model1 = [PopMenuModel
                            allocPopMenuModelWithImageNameString:@"tabbar_compose_photo"
                            AtTitleString:@"新建快捷"
                            AtTextColor:[UIColor grayColor]
                            AtTransitionType:PopMenuTransitionTypeSystemApi
                            AtTransitionRenderingColor:nil];
    
    PopMenuModel* model2 = [PopMenuModel
                            allocPopMenuModelWithImageNameString:@"tabbar_compose_camera"
                            AtTitleString:@"扫描接车"
                            AtTextColor:[UIColor grayColor]
                            AtTransitionType:PopMenuTransitionTypeCustomizeApi
                            AtTransitionRenderingColor:nil];
    
    PopMenuModel* model3 = [PopMenuModel
                            allocPopMenuModelWithImageNameString:@"tabbar_compose_lbs"
                            AtTitleString:@"扫描快捷"
                            AtTextColor:[UIColor grayColor]
                            AtTransitionType:PopMenuTransitionTypeSystemApi
                            AtTransitionRenderingColor:nil];
    
    PopMenuModel* model4 = [PopMenuModel
                            allocPopMenuModelWithImageNameString:@"tabbar_compose_review"
                            AtTitleString:@"点评"
                            AtTextColor:[UIColor grayColor]
                            AtTransitionType:PopMenuTransitionTypeCustomizeApi
                            AtTransitionRenderingColor:nil];
    
    PopMenuModel* model5 = [PopMenuModel
                            allocPopMenuModelWithImageNameString:@"tabbar_compose_more"
                            AtTitleString:@"更多"
                            AtTextColor:[UIColor grayColor]
                            AtTransitionType:PopMenuTransitionTypeSystemApi
                            AtTransitionRenderingColor:nil];
    PopMenuModel* model6 = [PopMenuModel
                            allocPopMenuModelWithImageNameString:@"tabbar_compose_lbs"
                            AtTitleString:@"扫描快捷"
                            AtTextColor:[UIColor grayColor]
                            AtTransitionType:PopMenuTransitionTypeSystemApi
                            AtTransitionRenderingColor:nil];
    
//    PopMenuModel* model7 = [PopMenuModel
//                            allocPopMenuModelWithImageNameString:@"tabbar_compose_review"
//                            AtTitleString:@"点评"
//                            AtTextColor:[UIColor grayColor]
//                            AtTransitionType:PopMenuTransitionTypeCustomizeApi
//                            AtTransitionRenderingColor:nil];
//    PopMenuModel* model8 = [PopMenuModel
//                            allocPopMenuModelWithImageNameString:@"tabbar_compose_review"
//                            AtTitleString:@"点评"
//                            AtTextColor:[UIColor grayColor]
//                            AtTransitionType:PopMenuTransitionTypeCustomizeApi
//                            AtTransitionRenderingColor:nil];
    
    _menu.dataSource = @[ model, model1, model2, model3, model4, model5 ,model6];
    _menu.delegate = self;
    _menu.popMenuSpeed = 12.0f;
    _menu.automaticIdentificationColor = false;
    _menu.animationType = HyPopMenuViewAnimationTypeSina;
}

- (void)popMenuView:(HyPopMenuView*)popMenuView didSelectItemAtIndex:(NSUInteger)index{
    NSLog(@"xx%lu,%@",(unsigned long)index,self.childViewControllers);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
