//
//  ExamDetailViewController.h
//  BigShark
//
//  Created by Mac on 16/2/26.
//  Copyright © 2016年 com.timber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZLBaseVC.h"
#import "examGradeModel.h"
#import "PaperInfoModel.h"
#import "examResultsViewController.h"


@protocol ChangeCurrentViewDelegate <NSObject>

- (void)changeToSelectedView:(int)index;

@end


/**
 *  改变考试剩余次数
 */
@protocol ChangePaperRemainTimesDelegate <NSObject>
- (void)ChangePaperRemainTimes:(NSInteger )remianTimes;
@end


@interface ExamDetailViewController : SZLBaseVC

@property (assign, nonatomic) id<ChangePaperRemainTimesDelegate> delegate;
@property(nonatomic,retain)NSString *PId;
@property(nonatomic,retain)NSString *PlanId;
@property(nonatomic,retain)NSString *examTime;
@property(nonatomic,retain)NSString *PlanName;
@property(nonatomic,retain)NSString *PlanPoint;
@property(nonatomic,retain)NSString *PlanPassPoint;
@property(nonatomic,retain)NSString *PaperWay;
@property(nonatomic,retain)NSString *PlanIsKey;
@property(nonatomic,strong)NSString *resourseType;

@property(nonatomic,strong)NSString *examBeginTime;
//新增属性
@property(nonatomic,retain)NSString *ShowPoint;
@property(nonatomic,retain)NSString *PlanResultDate;
@property(nonatomic,retain)NSString *isShowAnswer;
@property(nonatomic,strong)NSMutableArray *questionListsArr;//所有试题
@property(nonatomic,assign)long examOrPractice;//1表示考试试卷   2表示练习试卷 3表示错题   4表示收藏
@property(nonatomic,retain) PaperInfoModel *paperInfo;
@end
