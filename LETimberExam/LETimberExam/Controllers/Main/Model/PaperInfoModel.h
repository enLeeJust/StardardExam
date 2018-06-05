//
//  PaperInfoModel.h
//  SZLTimber
//
//  Created by 桂舟 on 16/10/11.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "BaseModel.h"

@interface PaperInfoModel : BaseModel
@property(nonatomic,copy) NSString* paperIsunAnswer;//是否显示答案
@property(nonatomic,copy) NSString* paperIsunShowpoint;//是否立即显示答案
@property(nonatomic,assign) long paperPId;//
@property(nonatomic,copy) NSString* paperPlanDateBegin;//开始时间
@property(nonatomic,copy) NSString* paperPlanDateEnd;//结束时间
@property(nonatomic,assign) long paperPlanId;//
@property(nonatomic,copy) NSString* paperPlanModule;//
@property(nonatomic,copy) NSString* paperPlanName;//
@property(nonatomic,assign) float paperPlanPassPoint;//试卷通过分数
@property(nonatomic,assign) float paperPlanPoint;//试卷总分

@property(nonatomic,copy) NSString* paperPlanResultDate;//考试显示答案日期
@property(nonatomic,assign) long paperPlanTime;//
@property(nonatomic,assign) long paperPlanType;//1表示考试   2表示练习
@property(nonatomic,copy) NSString* paperTypeName;//
@property(nonatomic,copy) NSString* paperUserID;//
@property(nonatomic,copy) NSString* paperWKey;//
@property(nonatomic,assign) long paperPlanJoinnum;//
@property(nonatomic,copy) NSString* paperState;//用户是否通过

@end
