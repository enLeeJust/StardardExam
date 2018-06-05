//
//  TabBarBtn.m
//  SZLTimberTrain
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "TabBarBtn.h"
#import "BadgeLabel.h"

@implementation TabBarBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _badgeLabel = [[BadgeLabel alloc] initWithFrame:CGRectMake(16,-3, 20, 20)];
        [self addSubview:_badgeLabel];
        [self setExclusiveTouch:YES];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
}

@end
