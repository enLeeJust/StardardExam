//
//  registerViewController.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/6.
//  Copyright © 2016年 timber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimberExam.h"
#import "SZLBaseVC.h"
@protocol signDelegate<NSObject>

-(void)signDelegteName:(NSString *)name passWord:(NSString *)pass;

@end


@interface RegisterViewController : SZLBaseVC
@property(nonatomic,assign)id<signDelegate>delegate;

@end
