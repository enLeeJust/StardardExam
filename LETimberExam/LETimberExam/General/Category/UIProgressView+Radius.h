//
//  UIProgressView+Radius.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIProgressView (Radius)

- (void)setRadiusTrackColor:(UIColor *)trackColor ;
- (void)setRadiusProgressColor:(UIColor *)progressColor;
- (void)setRadiusTrackColor:(UIColor *)trackColor
              progressColor:(UIColor *)progressColor;

@property (nonatomic, assign) CGFloat progressHeigt;

@end
