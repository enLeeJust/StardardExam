//
//  DefineHeader.h
//  SZLTimberExam
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#ifndef DefineHeader_h
#define DefineHeader_h

#import "AppDelegate.h"

#define APPDELEGATE             ((AppDelegate*)([UIApplication sharedApplication].delegate))
#define KEY_WINDOW              [[UIApplication sharedApplication] keyWindow]
#define CURRENTVIEWCONTROLLER   APPDELEGATE.window.currentViewController
#define TOP_VIEW                KEY_WINDOW.rootViewController.view

#define WIDTH       [UIScreen mainScreen].bounds.size.width
#define HEIGHT      [UIScreen mainScreen].bounds.size.height

#define VWIDTH  self.view.frame.size.width
#define NWIDTH self.frame.size.width

#define SHeight [UIScreen mainScreen].bounds.size.height
#define SWidth  [UIScreen mainScreen].bounds.size.width

#define Height [UIScreen mainScreen].bounds.size.height
#define Width  self.view.frame.size.width


#define kNavigationBarHeight    64

#define RGBColor(r, g, b, a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define MainColor    [UIColor colorWithRed:40/255.0 green:52/255.0 blue:89/255.0 alpha:1]
#define MyBlueColor             [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]
#define MyOrangeColor           [UIColor colorWithRed:1.000 green:0.397 blue:0.000 alpha:1.000]
#define MyYellowColor           [UIColor colorWithRed:200.0/255.0 green:160.0/255.0 blue:20.0/255.0 alpha:1.0]
#define MyBackColor             [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1]
//#define MyNavColor              [UIColor colorWithRed:0.165 green:0.710 blue:0.533 alpha:1.000]
//45,171,254
#define MyNavColor              [UIColor colorWithRed:(45.0/255.0) green:(171.0 / 255.0) blue:(254.0 / 255.0) alpha:1]
#define MyBlue              [UIColor colorWithRed:(45.0/255.0) green:(171.0 / 255.0) blue:(254.0 / 255.0) alpha:1]
#define MyHomeColor             [UIColor colorWithRed:73.0/255.0 green:178.0/255.0 blue:74.0/255.0 alpha:1.0]
#define MyAlphaColor            [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:0.5]
#define MySelectedColor         [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:0.6]
#define MyFxBlueColor           [UIColor colorWithRed:252.0/255.0 green:250.0/255.0 blue:1214.0/255.0 alpha:1.0]
#define MyTextColor             [UIColor colorWithRed:0.176 green:0.188 blue:0.200 alpha:1.000]
#define WhiteColor              [UIColor whiteColor];
#define BlackColor              [UIColor blackColor];
#define MyLineColor             [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:0.6]
#define MyOrange              [UIColor colorWithRed:(252.0/255.0) green:(124.0 / 255.0) blue:(85.0 / 255.0) alpha:1]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define EMPTY_IF_NIL(str) (str == nil ? @"" : (str == (id)[NSNull null] ? @"" : str))
#define NOT_NULL(v) (v && (v) != (id)[NSNull null])
#define INSTANCE_OF(obj,cls) ([obj isKindOfClass:[cls class]])

#define CURRENTVIEWCONTROLLER   APPDELEGATE.window.currentViewController
#define USERID        [[NSUserDefaults standardUserDefaults]objectForKey:@"userId"]
//#define USER_BASE_INFO        [[NSUserDefaults standardUserDefaults]objectForKey:@"userBaseInfo"]
#define kAlphaNum     @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_@."

//正式环境
#define webserviceUrl @"http://p1j4894351.51mypc.cn:11919"
#define TbExamUrl @"http://p1j4894351.51mypc.cn:11919/Interface/JsonAjax.aspx?servletName="
//测试环境  http://121.40.102.174:8020/
//#define webserviceUrl @"http://121.40.102.174:8020"
//#define TbExamUrl @"http://121.40.102.174:8020/Interface/JsonAjax.aspx?servletName="


#define DBNAME    @"personinfo.sqlite"
#define qPlanName  @"qPlanName"
#define qModuleUrl  @"ModuleUrl"
#define qId       @"qId"
#define qType     @"qType"
#define qTitle    @"qTitle"
#define qBody     @"qBody"
#define qAnswer   @"qAnswer"
#define qMark     @"qMark"
#define qMode     @"qMode"
#define userQAnswer     @"userQAnswer"
#define userID        @"userID"//用户ID 数据库操作

#define TABLECOLLECT @"COLLECTINFO"
#define TABLEERROR @"ERRORINFO"
#define TABLEEXERCISE @"EXERCISE"
#define kError_Network_NotReachable  @"请检查您的网络设置"


// 通知中心宏定义
#define kTBStartPageShowCompletionNotification @"startpageshowcompletion"

#define FONT(A)       [UIFont systemFontOfSize:A]
#define CELLFONT      [UIFont systemFontOfSize:16]
#define SECFONT1      [UIFont systemFontOfSize:20]
#define SECFONT2      [UIFont systemFontOfSize:14]
#endif /* DefineHeader_h */
