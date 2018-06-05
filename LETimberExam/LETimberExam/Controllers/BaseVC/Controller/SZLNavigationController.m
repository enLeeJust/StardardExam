//
//  SZLNavigationController.m
//  SZLTimberTrain
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SZLNavigationController.h"
#import "PushTransitionAnimation.h"
#import "PopTransitionAnimation.h"
#import "SZLBaseVC.h"

@interface SZLNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *edgePanGestureRecognizer; //添加边缘返回手势
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer; //添加全屏返回手势

@end

@implementation SZLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarHidden = YES;
    self.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self interactivePopGestureRecognizerType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 转场动画
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (operation == UINavigationControllerOperationPush) {
        if ([version floatValue]>=8.0) {
            PushTransitionAnimation *pushTransitionAnimation = [PushTransitionAnimation new];
            return pushTransitionAnimation;

        }
    }
    else if (operation == UINavigationControllerOperationPop) {
        if ([version floatValue]>=8.0) {
            PopTransitionAnimation *popTransitionAnimation = [PopTransitionAnimation new];
            return popTransitionAnimation;
            
        }
    }
    return nil;
}

#pragma mark - 判断页面数，页面数>1时执行手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.viewControllers.count > 1) {
        return YES;
    }
    else{
        return NO;
    }
}

#pragma mark- 添加百分比驱动
- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    
    PopTransitionAnimation *popTransitionAnimation = [PopTransitionAnimation new];
    if ([animationController isKindOfClass:[popTransitionAnimation class]]) {
        return self.percentDrivenInteractiveTransition;
    }
    return nil;
}

#pragma mark - 手势具体方法
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)gesture{
    CGPoint point = [gesture translationInView:gesture.view];
    CGFloat progress = point.x / gesture.view.bounds.size.width;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.percentDrivenInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self popViewControllerAnimated:YES];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self.percentDrivenInteractiveTransition updateInteractiveTransition:progress];
    }
    else if (gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateEnded) {
        //判断手势滑动距离是否超过屏幕的一半，如果超过一半则完成pop动画
        if (progress > 0.5) {
            [self.percentDrivenInteractiveTransition finishInteractiveTransition];
        }
        else{
            [self.percentDrivenInteractiveTransition cancelInteractiveTransition];
        }
        self.percentDrivenInteractiveTransition = nil;
    }
}

#pragma mark - 判断滑动返回手势方式
- (void)setInteractivePopGestureRecognizerType:(InteractivePopGestureRecognizerType)interactivePopGestureRecognizerType{
    switch (interactivePopGestureRecognizerType) {
        case InteractivePopGestureRecognizerNone:
        {
            if (self.edgePanGestureRecognizer) {
                [self.view removeGestureRecognizer:self.edgePanGestureRecognizer];
                self.edgePanGestureRecognizer = nil;
            }else if (self.panGestureRecognizer) {
                [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.panGestureRecognizer];
                self.panGestureRecognizer = nil;
            }
        }

            break;
        case InteractivePopGestureRecognizerEdge:
        {
            //添加边缘返回手势
            if (self.panGestureRecognizer) {
                [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.panGestureRecognizer];
                self.panGestureRecognizer = nil;
            }
            if (!_edgePanGestureRecognizer) {
                _edgePanGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
                _edgePanGestureRecognizer.edges = UIRectEdgeLeft;
                [self.view addGestureRecognizer:_edgePanGestureRecognizer];
            }

        }
            break;
        case InteractivePopGestureRecognizerFullScreen:
        {
            //添加全屏返回手势
            if (self.edgePanGestureRecognizer) {
                [self.view removeGestureRecognizer:self.edgePanGestureRecognizer];
                self.edgePanGestureRecognizer = nil;
            }
            if (!_panGestureRecognizer) {
                _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
                [self.interactivePopGestureRecognizer.view addGestureRecognizer:_panGestureRecognizer];
            }
        }
            break;
    }
}


@end
