
//
//  ScrollContrainerView.m
//  SZLTimberTrain
//
//  Created by Apple on 16/9/18.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ScrollContrainerView.h"

@implementation ScrollContrainerView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView * subview in self.subviews) {
        if (CGRectContainsPoint(subview.frame, point)) {
            return subview;
        }
    }
    return [super hitTest:point withEvent:event];
}

@end
