//
//  SZLInfoHelper.m
//  SZLTimberTrain
//
//  Created by Apple on 16/9/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SZLInfoHelper.h"
#import "LoginInfoDomain.h"
NSString * const kTBUserIdChangedKey    = @"useridchanged";
NSString * const kTBUserLogin        = @"userlogin";

NSString * const kTBNewsChangedKey    = @"tatalNews";
NSString * const kTBNotices        = @"totalNotices";

NSString * const kTBFirstInstall        = @"firstinstall";
NSString * const kTBUserLoginInfoKey    = @"userlogininfokey";
NSString * const kTBUserBaseInfoKey        = @"userbaseinfo";
@implementation SZLInfoHelper

+ (instancetype)shareInstance {
    static dispatch_once_t onceTonken;
    static SZLInfoHelper * shareInstance = nil;
    dispatch_once(&onceTonken, ^{
        shareInstance = [[SZLInfoHelper alloc]init];
    });
    
    return shareInstance;
}

- (void)setUserId:(NSString *)userId {
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:userId forKey:kTBUserIdChangedKey];
    [userDefault synchronize];
}

- (NSString *)userId {
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSString * userid = [userDefault objectForKey:kTBUserIdChangedKey];
    if (userid) {
        return userid;
    }
    return nil;
}

- (void)setTotalNews:(NSInteger)totalNews {
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@(totalNews) forKey:kTBNewsChangedKey];
    [userDefault synchronize];
}

- (NSInteger)totalNews {
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger tatalNewsNum = [[userDefault objectForKey:kTBNewsChangedKey] integerValue];
    if (tatalNewsNum) {
        return tatalNewsNum;
    }
    return 0;
}

- (void)setTotalNotices:(NSInteger)totalNotices{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:@(totalNotices) forKey:kTBNotices];
    [userDefault synchronize];
}

- (NSInteger)totalNotices {
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger totalNoticesNum = [[userDefault objectForKey:kTBNotices] integerValue];
    if (totalNoticesNum) {
        return totalNoticesNum;
    }
    return 0;
}

- (void)setIsFirstInstall:(BOOL)isFirstInstall {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isFirstInstall forKey:kTBFirstInstall];
    [userDefaults synchronize];
}

- (BOOL)isFirstInstall {
    BOOL isFirstInstall = YES;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:kTBFirstInstall]) {
        isFirstInstall = [userDefaults boolForKey:kTBFirstInstall];
    }
    return isFirstInstall;
}


-(void)setIsLogin:(BOOL)isLogin{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isLogin forKey:kTBUserLogin];
    [userDefaults synchronize];


}
- (BOOL)isLogin{
    BOOL isLogin = NO;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:kTBUserLogin]) {
        isLogin = [userDefaults boolForKey:kTBUserLogin];
    }
    return isLogin;
}

-(void)setUserBaseInfo:(NSDictionary *)userBaseInfo{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userBaseInfo forKey:kTBUserBaseInfoKey];
    [userDefaults synchronize];

}

-(NSDictionary *)userBaseInfo{
    NSDictionary * info = [[NSDictionary alloc] init];
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:kTBUserBaseInfoKey]) {
        info = [userDefault objectForKey:kTBUserBaseInfoKey];
    }
    return info;

}


- (NSArray *)userInfoArr {
    NSArray * infoArr = [NSArray array];
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:kTBUserLoginInfoKey]) {
        infoArr = [userDefault objectForKey:kTBUserLoginInfoKey];
    }
    return infoArr;
}

- (BOOL)updateUserLoginInfoWithDict:(NSDictionary *)dict {
    self.isLogin = YES;
    NSMutableArray * userNameArr = [NSMutableArray array];
    for (NSDictionary * tmpDict in self.userInfoArr) {
        [userNameArr addObject:[tmpDict objectForKey:@"userName"]];
    }
    
    NSMutableArray * tmpArr = self.userInfoArr.mutableCopy;
    if ([userNameArr containsObject:[dict objectForKey:@"userName"]]) { //账户已存在
        for (NSDictionary * tmpDict in self.userInfoArr) {
            if ([[tmpDict objectForKey:@"userName"] isEqualToString:[dict objectForKey:@"userName"]]) {
                [tmpArr removeObject:tmpDict];
                [tmpArr insertObject:dict atIndex:0];
            }
        }
    }else{ //账户不存在
        [tmpArr insertObject:dict atIndex:0];
    }
    
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:tmpArr forKey:kTBUserLoginInfoKey];
    [userDefault synchronize];
    
    return YES;
}

- (LoginInfoDomain *)findUserLoginInfoWithUserName:(NSString *)userName {
    NSMutableArray * userNameArr = [NSMutableArray array];
    for (NSDictionary * tmpDict in self.userInfoArr) {
        [userNameArr addObject:[tmpDict objectForKey:@"userName"]];
    }
    
    if ([userNameArr containsObject:userNameArr]) {
        for (NSDictionary * tmpDict in self.userInfoArr) {
            if ([[tmpDict objectForKey:@"userName"] isEqualToString:userName]) {
                LoginInfoDomain * domain = [[LoginInfoDomain alloc]initWithDictionary:tmpDict];
                return domain;
            }
        }
    }
    return nil;
}

- (BOOL)deleteUserLoginInfoWithUserName:(NSString *)userName {
    for (NSDictionary * tmpDict in self.userInfoArr) {
        if ([[tmpDict objectForKey:@"userName"] isEqualToString:userName]) {
            NSMutableArray * tmpArr = self.userInfoArr.mutableCopy;
            [tmpArr removeObject:tmpDict];
            NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:tmpArr forKey:kTBUserLoginInfoKey];
            [userDefault synchronize];
            break;
        }
    }
    return YES;
}


#pragma mark - 数据简单存取
-(void)setAsynchronous:(id)object withKey:(NSString *)key {
    if ([object isKindOfClass:[NSNull class]]) {
        return;
    }
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary * tmpdict = (NSDictionary *)object;
        NSMutableDictionary * dict = tmpdict.mutableCopy;
        NSMutableArray * tmp = [[NSMutableArray alloc]init];
        for (NSString * key in [dict allKeys]) {
            NSString * str = [dict objectForKey:key];
            if ([str isKindOfClass:[NSNull class]]) {
                [tmp addObject:key];
            }
        }
        [dict removeObjectsForKeys:tmp];
        object = dict.copy;
    }
    
    NSUserDefaults * info = [NSUserDefaults standardUserDefaults];
    [info setObject:object forKey:key];
    [info synchronize];
}
-(void)clearAsynchronousWithKey:(NSString *)key {
    NSUserDefaults * info = [NSUserDefaults standardUserDefaults];
    [info removeObjectForKey:key];
    [info synchronize];
}
-(id)getAsynchronousWithKey:(NSString *)key {
    NSUserDefaults * info = [NSUserDefaults standardUserDefaults];
    return [info valueForKey:key];
}

-(void)JumpAlter:(NSString *)msg after:(float)time To:(UIView *)view{
    
    _myhud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    _myhud.mode = MBProgressHUDModeText;
    _myhud.labelText = msg;
    _myhud.margin = 10.f;
    _myhud.removeFromSuperViewOnHide = YES;
    [_myhud hide:YES afterDelay:time];
    
}


@end
