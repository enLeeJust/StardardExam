//
//  UserBaseInfoModel.m
//  SZLTimber
//
//  Created by 桂舟 on 16/10/21.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "UserBaseInfoModel.h"

@implementation UserBaseInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName  {
    return @{@"user_cnname" : @"STU_CNNAME",
             @"user_email" : @"STU_EMAIL",
             @"user_enname" : @"STU_ENNAME",
             @"user_phone" : @"STU_PHONE",
             @"user_pic" : @"STU_PIC",
             @"user_sex" : @"STU_SEX",
             @"user_id" : @"USER_ID",
             @"user_name" : @"USER_NAME",
             @"user_dep_name":@"DEP_NAME",
             @"user_p_name":@"P_NAME",
             @"user_role_name":@"ROLE_NAME",
             
             };
}

@end
