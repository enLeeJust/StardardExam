//
//  AppDelegate.m
//  LETimberExam
//
//  Created by 桂舟 on 16/11/7.
//  Copyright © 2016年 桂舟. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "SZLNavigationController.h"
#import "GuidePageViewController.h"
#import "SZLStartPageView.h"
#import "MainViewController.h"
#import "LoginInfoDomain.h"

@interface AppDelegate ()<UIAlertViewDelegate>
@property (assign, nonatomic) BOOL firstOpenApp;

@property (strong, nonatomic) SZLStartPageView * startPageView;
@end

@implementation AppDelegate

#pragma mark - lazy loading

- (SZLStartPageView *)startPageView {
    if (!_startPageView) {
        _startPageView = [[SZLStartPageView alloc]init];
    }
    return _startPageView;
}

- (SZLNavigationController *)mainNavc {
    if (!_mainNavc) {
        MainViewController *mainVC = [[MainViewController alloc] init];
        _mainNavc = [[SZLNavigationController alloc] initWithRootViewController:mainVC];
        _mainNavc.interactivePopGestureRecognizerType = InteractivePopGestureRecognizerEdge;
    }
    return _mainNavc;
}

- (SZLNavigationController *)loginNavc {
    if (!_loginNavc) {
        //TODO:添加登录
         LoginViewController *loginVC = [[LoginViewController alloc]init];
        _loginNavc = [[SZLNavigationController alloc]initWithRootViewController:loginVC];
        _loginNavc.interactivePopGestureRecognizerType = InteractivePopGestureRecognizerEdge;
    }
    return _loginNavc;
}


- (SZLNavigationController *)guideNavc {
    if (!_guideNavc) {
        GuidePageViewController * guideVC = [[GuidePageViewController alloc]initWithGuideImages:@[@"pic1", @"pic2", @"pic3",@"pic4"]];
        _guideNavc = [[SZLNavigationController alloc]initWithRootViewController:guideVC];
    }
    return _guideNavc;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self motinorCurrentNetWork];
    
    if (SZLInfoHelperManager.isFirstInstall) {
        self.window.rootViewController = self.guideNavc;
        
    }else{
//        [NSThread sleepForTimeInterval:3.0];
        [[NSNotificationCenter defaultCenter] postNotificationName:kTBStartPageShowCompletionNotification object:nil];
        
        [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        LoginInfoDomain * domain = [[LoginInfoDomain alloc]initWithDictionary:SZLInfoHelperManager.userInfoArr.firstObject];
        if (SZLInfoHelperManager.isLogin && domain.autoLogin) {
            APPDELEGATE.automaticLogin = YES;
            self.window.rootViewController = self.mainNavc;
            
        }else{
            self.window.rootViewController = self.loginNavc;
            
        }

    }
     self.window.backgroundColor = WhiteColor;

    [self.window makeKeyAndVisible];
    
//    [self updateStartPageImage];
    [self showAdImageView];

    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        //     设置打开app数据流量界面
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    
}



+(void)setRootViewController:(UIViewController *)toViewController fromController:(UIViewController *)fromController isLogin:(BOOL)isLogin {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    __weak AppDelegate * wself = appDelegate;
    __block UIViewController * blockFromController = fromController;
    
    [UIView transitionWithView:appDelegate.window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void) {
                        BOOL oldState = [UIView areAnimationsEnabled];
                        [UIView setAnimationsEnabled:NO];
                        wself.window.rootViewController = toViewController;
                        [UIView setAnimationsEnabled:oldState];
                    }
                    completion:^(BOOL finished) {
                        if (finished) {
                            if (!fromController.navigationController) {
                                blockFromController = nil;
                            }else {
                                NSArray * viewControllers = [fromController.navigationController viewControllers];
                                for (NSInteger i = 0; i < viewControllers.count; i++) {
                                    id tmp = viewControllers[i];
                                    tmp = nil;
                                }
                            }
                            
                            // 释放前一个导航
                            if (isLogin) {
                               
                                
                            }else {
                                NSArray * viewControllers = [wself.mainNavc viewControllers];
                                for (NSInteger i = 0; i < viewControllers.count; i++) {
                                    id tmp = viewControllers[i];
                                    tmp = nil;
                                }
                                
                                wself.mainNavc = nil;
                            }
                        }
                    }];
}


#pragma mark - 监测网络变化
-(void)motinorCurrentNetWork {
    [AFNetworkReachabilityManager managerForDomain:@"www.baidu.com"];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    self.firstOpenApp = YES;
    self.showNetChangedHUD = YES;
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                if (_showNetChangedHUD) {
                    [CURRENTVIEWCONTROLLER.view makeToast:@"网络无连接"];
                }
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                if (!_firstOpenApp && _showNetChangedHUD) {
                    [CURRENTVIEWCONTROLLER.view makeToast:@"Wifi已连接"];
                }
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                if (!_firstOpenApp && _showNetChangedHUD) {
                    [CURRENTVIEWCONTROLLER.view makeToast:@"3G/4G已连接"];
                }
            }
                break;
            default:
                break;
        }
        _firstOpenApp = NO;
    }];
}
#pragma mark - 展示启动图
- (void)showAdImageView {
    __weak AppDelegate * wself = self;
    self.startPageView.frame = self.window.bounds;
    self.startPageView.completeBlock = ^(void (^callback)()){
        [wself removeAdImageView:callback];
    };
    
    [self.startPageView showInView:self.window animated:YES];
}
#pragma mark - 更新启动图
- (void)updateStartPageImage {
    [SZLServerHelper getStartPageImageWithCallback:^(NSInteger errCode, ApiResponse *response, BOOL success) {
        if (success) {
            [[SZLStartPageManager sharedInstance] setImgURL:response.data[@"url"]];
        }
    }];
}
#pragma mark - 移除启动图
#pragma mark - 移除广告启动图
- (void)removeAdImageView:(void (^)())completeBlock {
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         self.startPageView.alpha = 0.0f;
                         self.startPageView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.2, 1.2, 1);
                         
                     }
                     completion:^(BOOL finished) {
                         
                         if (completeBlock) {
                             completeBlock();
                         }
                         
                         [self.startPageView removeFromSuperview];
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:kTBStartPageShowCompletionNotification object:nil];
                     }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
    //        //    检测网络和账户名和密码
    //        Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    //        if ([r currentReachabilityStatus] ==NotReachable) {
    //            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"设置网络:" message:@"没有网络,是否去设置网络?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
    //            [alertView show];
    //        }
    //    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

@end
