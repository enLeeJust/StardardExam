//
//  TimberExam.h
//  TimberExam
//
//  Created by Mac on 15/9/14.
//  Copyright (c) 2015年 Uniq Labs. All rights reserved.
//

#ifndef TimberExam_TimberExam_h
#define TimberExam_TimberExam_h

//#define WIDTH self.view.frame.size.width

//#define HEIGHT self.view.frame.size.height
#endif

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "ODRefreshControl.h"
#import "RADataObject.h"

#import "Reachability.h"

#import "AZNotification.h"
#import "SZLAlertView.h"
#import "JCAlertView.h"
#import "AFNetworkReachabilityManager.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif