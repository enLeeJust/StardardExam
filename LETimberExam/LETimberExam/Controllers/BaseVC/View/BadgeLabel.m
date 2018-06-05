//
//  BadgeLabel.m
//  SZLTimberTrain
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BadgeLabel.h"

@implementation BadgeLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.text = @"-1";
        self.backgroundColor = [UIColor redColor];
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:11];
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        
    }
    return self;
}

- (void)setText:(NSString *)text{
    [super setText:text];
    
    if ([text integerValue]<=0||text == nil) {
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
    if ([text integerValue] < 9) {
        self.font = [UIFont systemFontOfSize:12];
    }else if([text integerValue] > 9 && [text integerValue] < 99){
        self.font = [UIFont systemFontOfSize:11];
    }else{
        self.font = [UIFont systemFontOfSize:9];
    }
}

@end
