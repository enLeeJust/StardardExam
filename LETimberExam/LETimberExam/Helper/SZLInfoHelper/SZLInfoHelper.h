//
//  SZLInfoHelper.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

#define SZLInfoHelperManager [SZLInfoHelper shareInstance]

extern NSString * const kTBFirstInstall;
extern NSString * const kTBUserLoginInfoKey;

@class LoginInfoDomain;
@class UserBaseInfoModel;
@interface SZLInfoHelper : NSObject

+(instancetype)shareInstance;

/** 用户ID */
@property (nonatomic, strong) NSString * userId;
/** 用户是否首次安装应用 */
@property (nonatomic, assign) BOOL isFirstInstall;
/** 是否在登录状态 */
@property (nonatomic, assign) BOOL isLogin;
/** 登录账户信息 */
@property (nonatomic, strong) NSArray * userInfoArr;
/** 公告数目 */
@property (nonatomic, assign) NSInteger totalNotices;
/** 新闻数目 */
@property (nonatomic, assign) NSInteger totalNews;

/** 弹框 */
@property (nonatomic, strong) MBProgressHUD * myhud;

/** 用户登录后返回的基本信息 */
@property (nonatomic, strong) NSDictionary * userBaseInfo;
/**
 *  更新账户登录本地保存记录
 *
 *  @param dict 账户登录数据字典
 *
 *  @return 保存结果
 */
- (BOOL)updateUserLoginInfoWithDict:(NSDictionary *)dict;

/**
 *  根据账户名查找账户本地登录模型
 *
 *  @param userName 账户名
 *
 *  @return 账户登录模型
 */
- (LoginInfoDomain *)findUserLoginInfoWithUserName:(NSString *)userName;

/**
 *  根据用户名删除本地登录记录
 *
 *  @param userName 账户名
 *
 *  @return 删除结果
 */
- (BOOL)deleteUserLoginInfoWithUserName:(NSString *)userName;


/**
 *  添加Hud弹框
 *
 *  @param msg  弹框信息
 *  @param time 持续时间
 *  @param view 所在界面显示
 */
-(void)JumpAlter:(NSString *)msg after:(float)time To:(UIView *)view;

#pragma mark - 数据简单存取
/** 缓存数据 */
-(void)setAsynchronous:(id)object withKey:(NSString *)key;
/** 清除缓存 */
-(void)clearAsynchronousWithKey:(NSString *)key;
/** 取缓存 */
-(id)getAsynchronousWithKey:(NSString *)key;
@end
