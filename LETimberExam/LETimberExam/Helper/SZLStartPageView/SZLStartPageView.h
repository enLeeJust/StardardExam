//
//  SZLStartPageView.h
//  SZLTimberTrain
//
//  Created by Apple on 16/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZLStartPageView : UIView

@property (nonatomic, copy) void (^completeBlock)(void (^callback)());

- (void)showInView:(UIView *)view animated:(BOOL)animated;

- (void)showInView:(UIView *)view animated:(BOOL)animated completeBlock:(void (^)(void (^callback)()))completeBlock;

- (void)dismissWithAnimated:(BOOL)animated;

@end
