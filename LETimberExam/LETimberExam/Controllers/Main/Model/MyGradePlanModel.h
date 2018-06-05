//
//  myGradePlanModel.h
//  SZLTimber
//
//  Created by 桂舟 on 16/10/26.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "BaseModel.h"
@interface MyGradeExamLogModel : BaseModel

@property(nonatomic,copy) NSString *department_id;
@property(nonatomic,copy) NSString *department_name;
@property(nonatomic,copy) NSString *exam_begin_time;
@property(nonatomic,copy) NSString *exam_end_time;
@property(nonatomic,copy) NSString *exam_key;
@property(nonatomic,copy) NSString *exam_mode;
@property(nonatomic,assign) float exam_point;
@property(nonatomic,copy) NSString *exam_state;
@property(nonatomic,assign) long isun_showpoint;
@property(nonatomic,copy) NSString *plan_date;
@property(nonatomic,copy) NSString *plan_date_begin;
@property(nonatomic,copy) NSString *plan_date_end;
@property(nonatomic,assign) long plan_id;
@property(nonatomic,assign) long q_answer_correct;
@property(nonatomic,assign) long q_answer_error;
@property(nonatomic,assign) long q_answer_undo;
@property(nonatomic,assign) long q_answer_num;
@property(nonatomic,assign) long q_answer_semi;
@property(nonatomic,assign) long q_num;


@property(nonatomic,assign) long plan_joinnum;
@property(nonatomic,copy) NSString *plan_module;
@property(nonatomic,copy) NSString *plan_name;
@property(nonatomic,assign) long plan_pass_point;
@property(nonatomic,assign) long plan_point;
@property(nonatomic,copy) NSString *plan_result_date;
@property(nonatomic,copy) NSString *user_id;
@property(nonatomic,copy) NSString *w_key;
@property(nonatomic,copy) NSString *paper_url;
@property(nonatomic,assign) BOOL paper_unshow;
@end


@interface myGradePlanModel : BaseModel
@property(nonatomic,assign)float exam_top_point;
@property(nonatomic,assign)long exam_plan_id;
@property(nonatomic,copy)NSString *exam_plan_name;
@property(nonatomic,assign)long exam_state;
@property(nonatomic,copy)NSString *exam_type_Name;
@property(nonatomic,strong)NSArray  <MyGradeExamLogModel *>*examlog;

@end




