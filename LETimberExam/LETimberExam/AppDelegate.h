//
//  AppDelegate.h
//  LETimberExam
//
//  Created by 桂舟 on 16/11/7.
//  Copyright © 2016年 桂舟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimberExam.h"
#import "IQUIWindow+Hierarchy.h"
#import "ZWIntroductionViewController.h"
#import "SZLTabBarController.h"
@class SZLNavigationController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) ZWIntroductionViewController *introductionView;

@property (strong, nonatomic) SZLNavigationController * mainNavc;
@property (strong, nonatomic) SZLNavigationController * loginNavc;
@property (strong, nonatomic) SZLNavigationController * guideNavc;

@property (assign, nonatomic) BOOL automaticLogin;
@property (assign, nonatomic) BOOL showNetChangedHUD;


/**
 *  通过切换window的RVC实现登录登出
 *
 *  @param toViewController 目标ViewController
 *  @param fromController   原始ViewController
 *  @param isLogin          判断登入还是登出
 */
+(void)setRootViewController:(UIViewController *)toViewController fromController:(UIViewController *)fromController isLogin:(BOOL)isLogin;

@end
