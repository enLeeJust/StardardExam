//
//  PushTransitionAnimation.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushTransitionAnimation : NSObject <UIViewControllerAnimatedTransitioning>

//阴影图层
@property (nonatomic, strong) UIView *shadowView;

@end
