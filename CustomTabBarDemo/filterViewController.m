//
//  filterViewController.m
//  CustomTabBarDemo
//
//  Created by zhangMingJing on 2018/8/8.
//  Copyright © 2018年 zhangMingJing. All rights reserved.
//

#import "filterViewController.h"
#import "UIView+DCPagerFrame.h"
/** 屏幕高度 */
#define ScreenH [UIScreen mainScreen].bounds.size.height
/** 屏幕宽度 */
#define ScreenW [UIScreen mainScreen].bounds.size.width
/**
 非iPhone X ：
 StatusBar 高20px，NavigationBar 高44px，底部TabBar高49px
 iPhone X：
 StatusBar 高44px，NavigationBar 高44px，底部TabBar高83px
 */
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
//底部导航
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
//顶部导航
#define kTopHeight (kStatusBarHeight + kNavBarHeight)
//判断是否为iphoneX
#define IS_IPHONE_X ([[UIApplication sharedApplication] statusBarFrame].size.height>20?1:0)

#define IPHONE_X_BOTTOM ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34.0:0)

@interface filterViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSIndexPath *_currentStaffIndex;
    NSIndexPath *_currentDaysIndex;//记录当前选择状态
    NSIndexPath *_currentStatusIndex;//记录当前选择日期
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *statusAry;//状态
@property (nonatomic,strong) NSArray *dateAry;//日期
@property (nonatomic,strong) NSMutableArray *requireAry;//本人或全场

@property(nonatomic, readonly) UITapGestureRecognizer *tappedDismissGestureRecognizer;

@property (nonatomic,strong) UIView *coverView;//遮罩

@end

@implementation filterViewController

@synthesize tappedDismissGestureRecognizer = _tappedDismissGestureRecognizer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.leftConstraint.constant    = ScreenW * 0.2;
    self.topConstraint.constant     = kTopHeight;
    self.bottomConstraint.constant  = kTabBarHeight;
    
    self.statusAry               = @[@"待交接",@"维修中",@"待检验",@"待结算",@"待付款",@"待取车",@"全部状态"];
    self.dateAry                 = @[@"当天",@"3天内",@"7天内",@"15天内",@"全部"];
    self.requireAry              = [NSMutableArray arrayWithObjects:@"本人",@"全厂", nil];
    
    _currentStaffIndex  = [NSIndexPath indexPathForRow:1 inSection:0];
    _currentStatusIndex = [NSIndexPath indexPathForRow:self.statusAry.count-1 inSection:1];
    _currentDaysIndex   = [NSIndexPath indexPathForRow:self.dateAry.count-1 inSection:1];
    
    [self.view insertSubview:self.coverView atIndex:0];
    [self.coverView addGestureRecognizer:self.tappedDismissGestureRecognizer];
    
    //添加手势
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panEvent:)]; //滑动
    [self.view addGestureRecognizer:pan];
}

- (IBAction)restartBtn:(UIButton *)sender {
    
}

- (IBAction)submitBtn:(UIButton *)sender {
    [self dismissWithCompletion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.requireAry.count;
    }
    if (section == 1) {
        return self.statusAry.count;
    }
    return self.dateAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString*cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.font      = [UIFont systemFontOfSize:15.0];
    cell.selectionStyle      = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        cell.textLabel.text = self.requireAry[indexPath.row];
        //防止滑动改变勾选
        if (indexPath.row == _currentStaffIndex.row) {
            cell.accessoryType       = UITableViewCellAccessoryCheckmark;
            cell.textLabel.textColor = [UIColor blueColor];
        }else{
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.textLabel.textColor = [UIColor blackColor];
        }
        return cell;
    }
    
    if (indexPath.section == 1){
        cell.textLabel.text = self.statusAry[indexPath.row];
        //防止滑动改变勾选
        if (indexPath.row == _currentStatusIndex.row) {
            cell.accessoryType       = UITableViewCellAccessoryCheckmark;
            cell.textLabel.textColor = [UIColor blueColor];
        }else{
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.textLabel.textColor = [UIColor blackColor];
        }
        return cell;
    }
    
    cell.textLabel.text = self.dateAry[indexPath.row];
    //防止滑动改变勾选
    if (indexPath.row == _currentDaysIndex.row) {
        cell.accessoryType       = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor blueColor];
    }else{
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            _currentStaffIndex = indexPath;
            break;
        case 1:
             _currentStatusIndex = indexPath;
            break;
        case 2:
            _currentDaysIndex = indexPath;
            break;
            
        default:
            break;
    }
    
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    if (section == 1) {
        return @"状态:";
    }
    return @"日期:";
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section ==2) {
        return 28.0f;
    }
    return 0.01f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01f;
    }
    return 40.0f;
}

-(UITapGestureRecognizer *)tappedDismissGestureRecognizer
{
    if (_tappedDismissGestureRecognizer == nil)
    {
        _tappedDismissGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    }
    
    return _tappedDismissGestureRecognizer;
}

#pragma mark - 点击手势事件
- (void) handleTapFrom: (UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        //Code to handle the gesture
        [self dismissWithCompletion:nil];
    }
}

#pragma mark - 滑动手势事件
- (void)panEvent:(UIPanGestureRecognizer *)recognizer{
    
    CGPoint translation = [recognizer translationInView:self.view];
    
    if(UIGestureRecognizerStateBegan == recognizer.state || UIGestureRecognizerStateChanged == recognizer.state){
        
        if (translation.x > 0 ) {//右滑
            self.contentView.dc_x = ScreenW * 0.2 + translation.x;
        }else{//左滑
            
            if (self.contentView.dc_x < ScreenW * 0.2) {
                self.contentView.dc_x = self.contentView.dc_x - translation.x;
            }else{
                self.contentView.dc_x = ScreenW * 0.2;
            }
        }
    }else{
        [self dismissWithCompletion:nil];
    }
}

-(void)showAddPrinterViewCompletion:(void (^)(void))completion
{
    //  Getting topMost ViewController
    UIViewController *topController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    while ([topController presentedViewController])    topController = [topController presentedViewController];
    
    [topController.view endEditing:YES];
    
    //Adding self.view to topMostController.view and adding self as childViewController to topMostController
    {
        self.view.frame = CGRectMake(0, 0, topController.view.bounds.size.width, topController.view.bounds.size.height);
        self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [topController addChildViewController: self];
        [topController.view addSubview: self.view];
        [self didMoveToParentViewController:topController];
    }
    
    [self becomeFirstResponder];
    
    //Sliding up the pickerView with animation
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|7<<16 animations:^{
        self.coverView.alpha = 0.5;
        self.contentView.dc_x = ScreenW * 0.2;
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

-(void)dismissWithCompletion:(void (^)(void))completion
{
    [self resignFirstResponder];
    
    //Sliding down the pickerView with animation.
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|7<<16 animations:^{
        
        self.coverView.backgroundColor = [UIColor clearColor];
        self.contentView.dc_x = ScreenW;
    } completion:^(BOOL finished) {
        
        //Removing self.view from topMostController.view and removing self as childViewController from topMostController
        [self willMoveToParentViewController:nil];
        [self removeAllSubviews];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
        if (completion) completion();
    }];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)canResignFirstResponder
{
    return YES;
}

- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc]initWithFrame:self.view.bounds];
        _coverView.backgroundColor = [UIColor blackColor];
        _coverView.alpha = 0.0;
    }
    return _coverView;
}

#pragma mark - 移除SubViews
- (void)removeAllSubviews {
    
    if (self.view.subviews.count) {
        UIView* child = self.view.subviews.lastObject;
        [child removeFromSuperview];
    }
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
