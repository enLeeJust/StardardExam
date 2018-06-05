//
//  myGradePlanModel.m
//  SZLTimber
//
//  Created by 桂舟 on 16/10/26.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "myGradePlanModel.h"
@implementation MyGradeExamLogModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName  {
    return @{
             @"department_id" : @"DEP_ID",
             @"department_name" : @"DEP_NAME",
             @"exam_begin_time" : @"EXAM_BEGIN_TIME",
             @"exam_end_time" : @"EXAM_END_TIME",
             @"exam_key" : @"EXAM_KEY",
             
             @"exam_mode" : @"EXAM_MODE",
             @"exam_point" : @"EXAM_POINT",
             @"exam_state" : @"EXAM_STATE",
             @"isun_showpoint" : @"ISUN_ANSWER",
             @"plan_date" : @"PLAN_DATE",
            
             @"plan_date_begin" : @"PLAN_DATE_BEGIN",
             @"plan_date_end" : @"PLAN_DATE_END",
             @"plan_id" : @"PLAN_ID",
             
             @"q_answer_correct" : @"Q_ANSWER_CORRECT",
             @"q_answer_error" : @"Q_ANSWER_ERROR",
             @"q_answer_undo" : @"Q_ANSWER_NULL",
             @"q_answer_num" : @"Q_ANSWER_NUM",
             @"q_answer_semi" : @"Q_ANSWER_SEMI",
             @"q_num" : @"Q_NUM",
             
    
             
             @"plan_joinnum":@"PLAN_JOINNUM",
             @"plan_module" : @"PLAN_MODULE",
             @"plan_name" : @"PLAN_NAME",
             
             @"plan_pass_point" : @"PLAN_PASS_POINT",
             @"plan_point" : @"PLAN_POINT",
             @"plan_result_date" : @"PLAN_RESULT_DATE",
             @"user_id" : @"USER_ID",
             @"w_key" : @"W_KEY",
             
             @"paper_url" : @"url",
             @"paper_unshow" : @"ISUN_SHOW_PAPER",
             
             
             };
}


@end




@implementation myGradePlanModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName  {
    return @{@"exam_top_point" : @"ExamPoint",
             @"exam_plan_id" : @"PlanId",
             @"exam_plan_name" : @"PlanName",
             @"exam_state" : @"State",
             @"exam_type_Name" : @"TypeName",
             @"examlog" : @"dtExam",
             
             };
}

- (void)setExamlog:(NSArray<MyGradeExamLogModel *> *)examlog {
    
    if (NOT_NULL(examlog)) {
        _examlog = [examlog mapWithBlock:^id(id item, NSInteger idx) {
            if (INSTANCE_OF(item, NSDictionary)) {
                return [[MyGradeExamLogModel alloc]initWithDictionary:item];
            }else{
                return item;
            }
            return nil;
        }];
    }
}

@end
