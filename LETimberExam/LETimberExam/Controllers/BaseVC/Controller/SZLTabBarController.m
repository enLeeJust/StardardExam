//
//  SZLTabBarController.m
//  SZLTimberTrain
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SZLTabBarController.h"
#import "SZLBaseVC.h"
#import "TabBarBtn.h"

@interface SZLTabBarController () {
    NSArray * _viewControllers;
    NSArray * _titles;
    NSArray * _unSelectArray;
    NSArray * _selectArray;
    NSMutableArray * _navs;
}

@property (assign, nonatomic) NSInteger preBtnIndex;
@property (strong, nonatomic) UIImageView * unreadNewMsgImageView;

@end

@implementation SZLTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titles             = @[@"首页", @"学习", @"考试", @"我的"];
    _viewControllers    = @[@"MainViewController", @"LearnViewController", @"ExamViewController", @"MineViewController"];
    _unSelectArray      = @[@"ic_main_unselected", @"ic_learn_unselected", @"ic_exam_unselected", @"ic_mine_unselected"];
    _selectArray        = @[@"ic_main_selected", @"ic_learn_selected", @"ic_exam_selected", @"ic_mine_selected"];
    
    _navs = [[NSMutableArray alloc]init];
    self.preBtnIndex = self.selectedIndex;
    [self createViewControllers];
    
    self.selectedIndex = 0;
    
    [self customTabBarController];
}

- (void)createViewControllers {
    for (int i = 0;i < _viewControllers.count ; i++) {
        Class cls = NSClassFromString(_viewControllers[i]);
        SZLBaseVC * bvc = [[cls alloc]init];
        [bvc setNavigationTitle:_titles[i]];

        [_navs addObject:bvc];
    }
    self.viewControllers = _navs;
}

#pragma mark - 自定义UIView的tabBar
- (void)customTabBarController {
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
    // 设置图标
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.tabBar.bounds];
    imageView.userInteractionEnabled = YES;
    imageView.tag = 999;
    self.view.backgroundColor = WhiteColor;
    imageView.backgroundColor = [UIColor clearColor];
    
    CGFloat startSpace = 20;// 从20 像素开始
    CGFloat everyWidth = (WIDTH -20 * 2) / 1.0 / _viewControllers.count; // 每个宽度是多少
    CGFloat btnSpace = (everyWidth - 25) / 2.0; // btn 的偏移
    CGFloat btnHeightSpace = 5 ; // btn 高的偏移
    
    for (int i = 0; i < _selectArray.count; i++) {
        TabBarBtn *button = [[TabBarBtn alloc]initWithFrame: CGRectMake(startSpace + btnSpace+ (25 + btnSpace * 2) * i, btnHeightSpace, 25, 25)];
        [button setBackgroundImage:[UIImage imageNamed:_unSelectArray[i]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:_selectArray[i]] forState:UIControlStateSelected];
        
        if (i == self.selectedIndex) {
            button.selected = YES;
        }
        
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        [imageView addSubview:button];
        
        //添加小圆点图标
        if (i == _selectArray.count-1) {
            _unreadNewMsgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(button.v_width-8, 0, 8, 8)];
            _unreadNewMsgImageView.image = [UIImage imageNamed:@"main_weidu_warn"];
            _unreadNewMsgImageView.hidden = YES;
            [button addSubview:_unreadNewMsgImageView];
        }
        
        // label
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(startSpace + everyWidth * i, btnHeightSpace + 25 + 4, everyWidth, 12)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.text = _titles[i];
        
        if (self.selectedIndex == i) {
            label.textColor = MyNavColor;
        }else{
            label.textColor = [UIColor grayColor];
        }
        label.tag = button.tag+200;
        [imageView addSubview:label];
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(startSpace + everyWidth * i, 0, everyWidth, 49)];
        view.backgroundColor = [UIColor clearColor];
        view.tag = button.tag + 300;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [view addGestureRecognizer:tap];
        [imageView addSubview:view];
    }
    [self.tabBar addSubview:imageView];
}

- (void)tap:(UITapGestureRecognizer *)tap{
    UIView * view = (UIView * )tap.view;
    UIImageView *imageView = (UIImageView *)[self.tabBar viewWithTag:999];
    UIButton * btn = (UIButton *)[imageView viewWithTag:view.tag - 300];
    [self buttonClick:btn];
}

- (void)buttonClick:(UIButton *)btn{
    self.selectedIndex = btn.tag - 100;
    if (self.selectedIndex == self.preBtnIndex) {
        
        return;
    }
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:999];
    for (id obj in imageView.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btnTemp = (UIButton *)obj;
            UILabel * label = (UILabel *)[imageView viewWithTag:btnTemp.tag + 200];
            if (btnTemp.tag == btn.tag) {
                btnTemp.selected = YES;
                label.textColor = MyNavColor;
            } else {
                btnTemp.selected = NO;
                label.textColor = [UIColor grayColor];
            }
        }
    }
    self.preBtnIndex = self.selectedIndex;
}

- (void)hideCustomeTabBar
{
    UIImageView *imageView = (UIImageView *)[self.tabBar viewWithTag:999];
    imageView.hidden = YES;
}

- (void)showCustomeTabBar
{
    UIImageView *imageView = (UIImageView *)[self.tabBar viewWithTag:999];
    imageView.hidden = NO;
}

- (void)setTabbarHide:(BOOL)tabbarHide{
    if (tabbarHide == YES) {
        [self hideCustomeTabBar];
    }else{
        [self showCustomeTabBar];
    }
}

-(void)setStartIndex:(NSUInteger)startIndex {
    UIImageView *imageView = (UIImageView *)[self.tabBar viewWithTag:999];
    UIButton * btn = (UIButton *)[imageView viewWithTag:startIndex + 100];
    [self buttonClick:btn];
}


@end
