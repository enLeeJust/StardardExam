//
//  SZLAlertView.m
//  SZLTimberTrain
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SZLAlertView.h"

@implementation SZLAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (self.alertBlock) {
        self.alertBlock(buttonIndex);
    }
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate withMyAlertBlock:(MyAlertBlock)alertBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    
    self = [ super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if (self) {
        self.alertBlock = alertBlock;
        va_list _arguments;
        va_start(_arguments, otherButtonTitles);
        for (NSString *key = otherButtonTitles; key != nil; key = (__bridge NSString *)va_arg(_arguments, void *)) {
            [self addButtonWithTitle:key];
        }
        va_end(_arguments);
    }
    
    return self;
}

+ (void)MyAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate withMyAlertBlock:(MyAlertBlock)alertBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    
    SZLAlertView * alert = [[SZLAlertView alloc]initWithTitle:title message:message delegate:self withMyAlertBlock:alertBlock cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
    [alert show];
}

@end
