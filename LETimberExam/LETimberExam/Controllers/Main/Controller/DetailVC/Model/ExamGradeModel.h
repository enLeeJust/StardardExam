//
//  examGradeModel.h
//  SZLTimber
//
//  Created by 桂舟 on 16/10/11.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "BaseModel.h"

@interface ExamGradeModel : BaseModel
@property(nonatomic,assign) int paperTrueNum;
@property(nonatomic,assign) int paperFalseNum;
@property(nonatomic,assign) int paperUndoNum;
@property(nonatomic,assign) float paperGrade;
@property(nonatomic,copy) NSString* paperIsunAnswer;//是否显示答案
@property(nonatomic,copy) NSString* paperIsunShowpoint;//是否立即显示成绩

@property(nonatomic,copy) NSString* paperTime;//考试所用时间

@property(nonatomic,assign) float paperPlanPassPoint;//试卷通过分数
@property(nonatomic,copy) NSString* paperPlanResultDate;//考试显示答案日期

@end

