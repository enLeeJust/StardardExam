//
//  SZLNavigationController.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, InteractivePopGestureRecognizerType) {
    InteractivePopGestureRecognizerNone, //没有返回手势
    InteractivePopGestureRecognizerEdge, //边缘返回手势
    InteractivePopGestureRecognizerFullScreen //全屏返回手势
};

@interface SZLNavigationController : UINavigationController <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenInteractiveTransition;

//选择返回手势方式（边缘触发/全屏触发）
@property (nonatomic, assign) InteractivePopGestureRecognizerType interactivePopGestureRecognizerType;

@end
