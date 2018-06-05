//
//  PaperInfoModel.m
//  SZLTimber
//
//  Created by 桂舟 on 16/10/11.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "PaperInfoModel.h"

@implementation PaperInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName  {
    return @{@"paperIsunAnswer" : @"IsunAnswer",
             @"paperIsunShowpoint" : @"IsunShowpoint",
             @"paperPId" : @"PId",
             @"paperPlanDateBegin" : @"PlanDateBegin",
             @"paperPlanDateEnd" : @"PlanDateEnd",
             @"paperPlanId" : @"PlanId",
             @"paperPlanModule" : @"PlanModule",
             @"paperPlanName" : @"PlanName",
             
             @"paperPlanPassPoint" : @"PlanPassPoint",
             @"paperPlanPoint" : @"PlanPoint",
             @"paperPlanResultDate" : @"PlanResultDate",
             
             @"paperPlanTime" : @"PlanTime",
             @"paperPlanType" : @"PlanType",
             @"paperState"    : @"STATE",
             @"paperTypeName" : @"TypeName",
             
             @"paperUserID" : @"UserId",
             @"paperWKey" : @"WKey",
             @"paperPlanJoinnum" : @"planJoinnum",
             
             
             };
}






@end
