//
//  SZLAlertView.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/19.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZLAlertView : UIAlertView <UIAlertViewDelegate>

typedef void (^MyAlertBlock)(NSInteger buttonIndex);

@property (nonatomic,copy) MyAlertBlock alertBlock;

+ (void)MyAlertWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate withMyAlertBlock:(MyAlertBlock)alertBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
