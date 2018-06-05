//
//  ExamQuestionModel.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/21.
//  Copyright © 2016年 timber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface ExamModel : BaseModel

@property(nonatomic,strong) NSArray* ques_Arr;
@end

@interface ExamQuestionModel : BaseModel
/**  */
@property(nonatomic,assign) long exam_id;
@property(nonatomic,copy) NSString* ques_point;
@property(nonatomic,copy) NSString* ques_answer;
@property(nonatomic,copy) NSString* ques_answer_count;
@property(nonatomic,copy) NSString* ques_answer_key;
@property(nonatomic,copy) NSString* ques_body;
@property(nonatomic,assign) long  ques_id;
@property(nonatomic,copy) NSString* ques_mark;
@property(nonatomic,copy) NSString* ques_title;
@property(nonatomic,assign) long type_id;
/** ddd */
@property(nonatomic,copy) NSString* exam_key;

@property (nonatomic, copy) NSString *ModuleUrl;

//@property (nonatomic, assign) NSMutableArray *quesArr;
@end


@interface ErrorQuestionModel : BaseModel
/**  */
@property(nonatomic,copy) NSString* err_plan_name;
@property(nonatomic,copy) NSString* err_ques_body;
@property(nonatomic,copy) NSString* err_ques_answer;
@property(nonatomic,assign) long  err_ques_id;
@property(nonatomic,copy) NSString* err_ques_mark;
@property(nonatomic,copy) NSString* err_ques_title;
@property(nonatomic,assign) long err_type_id;
@property(nonatomic,copy) NSString* user_ques_answer;

/** ddd */
@property(nonatomic,copy) NSString* exam_key;

//@property (nonatomic, assign) NSMutableArray *quesArr;
@end
