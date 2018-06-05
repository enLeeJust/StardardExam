//
//  ExamQuestionModel.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/21.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "ExamQuestionModel.h"

@implementation ExamModel

-(void)setQues_Arr:(NSArray *)ques_Arr{

    
    if (NOT_NULL(ques_Arr)) {
        _ques_Arr = [ques_Arr mapWithBlock:^id(id item, NSInteger idx) {
            if (INSTANCE_OF(item, NSDictionary)) {
                return [[ExamQuestionModel alloc]initWithDictionary:item];
            }else if (INSTANCE_OF(item, ExamQuestionModel)){
                return item;
            }
            return nil;
        }];
    }

   
}


@end



@implementation ExamQuestionModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName  {
    return @{@"exam_id" : @"EId",
             @"ques_point" : @"Point",
             @"ques_answer" : @"QAnswer",
             @"ques_answer_count" : @"QAnswerCount",
             @"ques_answer_key" : @"QAnswerKey",
             @"ques_body" : @"QBody",
             @"ques_id" : @"QId",
             @"ques_mark" : @"QMark",
             
             @"ques_title" : @"QTitle",
             @"type_id" : @"TypeId",
             @"exam_key" : @"examKey",
             @"ModuleUrl": @"ModuleUrl",
        
          
             };
}


@end
@implementation ErrorQuestionModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName  {
    return @{@"err_plan_name" : @"PlanName",
             @"err_ques_body" : @"QBODY",
             @"err_ques_answer" : @"QAnswer",
             @"err_ques_id" : @"QID",
             @"err_ques_mark" : @"QMARK",
             @"err_ques_title" : @"QTITLE",
             @"err_type_id" : @"QTYPE",
             @"user_ques_answer" : @"UserAnswer",
             
             };
}


@end

