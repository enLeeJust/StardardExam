//
//  CALayer+Addtion.m
//  SZLTimberTrain
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CALayer+Addtion.h"

@implementation CALayer (Addtion)

- (void)setBorderUIColor:(UIColor*)color {
    self.borderColor = color.CGColor;
}

- (UIColor*)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

-(void)setContentsUIImage:(UIImage*)bgImage{
    self.contents=(__bridge id)(bgImage.CGImage);
}
-(UIImage*)contentsUIImage{
    return self.contents;
}

@end
