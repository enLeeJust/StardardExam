//
//  MainViewController.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/8.
//  Copyright © 2016年 timber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZLBaseVC.h"
typedef NS_ENUM(NSInteger, AutoLoginState) {
    AutoLoginStateUnknown = 0,
    AutoLoginStateSucceed,
    AutoLoginStateFailed
};
@interface MainViewController : SZLBaseVC

@end
