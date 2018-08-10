//
//  BackViewController.m
//  CustomTabBarDemo
//
//  Created by zhangMingJing on 2018/5/3.
//  Copyright © 2018年 zhangMingJing. All rights reserved.
//

#import "BackViewController.h"

@interface BackViewController ()

@end

@implementation BackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    [self VisualEffectView];
}

//毛玻璃一
-(void)VisualEffectView{
    //先生成图片背景
    UIImageView *blurImag = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    blurImag.image = [UIImage imageNamed:@"homePage2"];
    [self.view addSubview:blurImag];
    
    
    UILabel *blurLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 60, self.view.frame.size.width - 60, 300)];
    
    blurLabel.text = @"Our mind is sponge, our heart is stream.";
    
    /** 设置blurLabel的最大行数. */
    blurLabel.numberOfLines = 2;
    
    /** 设置blurLabel的字体颜色. */
    blurLabel.textColor = [UIColor whiteColor];
    
    /** 设置blurLabel的字体为系统粗体, 字体大小为34. */
    blurLabel.font = [UIFont boldSystemFontOfSize:34];
    
    
    /** 创建UIBlurEffect类的对象blur, 参数以UIBlurEffectStyleLight为例. */
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    /** 创建UIVisualEffectView的对象visualView, 以blur为参数. */
    UIVisualEffectView * visualView = [[UIVisualEffectView alloc] initWithEffect:blur];
    
    /** 将visualView的大小等于blurImageView的大小. (visualView的大小可以自行设定, 它的大小决定了显示毛玻璃效果区域的大小.) */
    visualView.frame = blurImag.bounds;
    
    visualView.alpha = 1;
    
    /** 将visualView添加到blurImageView上. */
    [blurImag addSubview:visualView];
    
    
    [visualView.contentView addSubview:blurLabel];
}

-(void)VisualEffectView2{
    /** 1. 创建UIImageView的对象vibrancyImageView. */
    UIImageView *vibrancyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 2*self.view.frame.size.width, self.view.frame.size.height)];
    
    UIImage *image = [UIImage imageNamed:@"homePage2"];
    
    /**
     * 在UIVibrancyEffect这种类型的毛玻璃中, 苹果官方API对UIImageView的image属性的渲染方式做出了要求:
     *      UIImageView will need its image to have a rendering mode of UIImageRenderingModeAlwaysTemplate to receive the proper effect.
     *
     * UIImageView的属性imgae的渲染方式要选择UIImageRenderingModeAlwaysTemplate, 会获得更好的效果.
     */
    
    /**
     * 给UIImage类的对象设置渲染方式的方法: - (UIImage * nonnull)imageWithRenderingMode:(UIImageRenderingMode)renderingMode
     * 参数renderingMode: typedef enum : NSInteger {
     UIImageRenderingModeAutomatic,
     UIImageRenderingModeAlwaysOriginal,
     UIImageRenderingModeAlwaysTemplate,
     information
     } UIImageRenderingMode;
     */
    [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    vibrancyImageView.image = image;
    
    vibrancyImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:vibrancyImageView];
    
    /** 2. 创建UILable的对象. */
    UILabel *vibrancyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, self.view.frame.size.width - 20, 300)];
    
    vibrancyLabel.text = @"Our mind is a sponge, our heart is a stream.";
    
    vibrancyLabel.numberOfLines = 2;
    
    vibrancyLabel.textColor = [UIColor whiteColor];
    
    vibrancyLabel.font = [UIFont boldSystemFontOfSize:34];
    
    
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    /**
     * 在上面我们提到过UIVisualEffectView类的类方法里的参数effect有两种类型:UIBlurEffect和UIVibrancyEffect.
     * 在这里我们创建UIVibrancyEffect类型的UIvisualEffectView;
     */
    
    /**
     * UIVibrancyEffect有两种创建方法, 在这里我们使用: + (UIVibrancyEffect *)effectForBlurEffect:(UIBlurEffect *)blurEffect
     *
     * 我们可以看出类方法中的参数类型是UIBlurEffect类型, 所以之前创建了一个UIBlurEffect的对象.
     */
    UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
    
    /** 下面的步骤同上. */
    UIVisualEffectView * visualView = [[UIVisualEffectView alloc] initWithEffect:vibrancy];
    
    visualView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    visualView.alpha = 1;
    
    [vibrancyImageView addSubview:visualView];
    
    [visualView.contentView addSubview:vibrancyLabel];
}

-(void)backBtnClick:(UIBarButtonItem *)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
