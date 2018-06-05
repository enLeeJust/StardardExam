//
//  FillBlankViewController.h
//  TimberExam
//
//  Created by Mac on 15/9/16.
//  Copyright (c) 2015年 timber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamQuestionModel.h"

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
@protocol countFillAnswer <NSObject>
@optional
- (void)userAnserCount;

@end

@interface FillBlankViewController : UIViewController<UIWebViewDelegate>
{
    UIButton *markQuesBtn;
    UIView *divideLineView;

    Boolean _isShowAnswer;
    UIView *showMarkView;
    UIButton *showMarkBtn;
    long _examOrPractice;//1表示考试 2表示练习
    
    ExamQuestionModel *quesDetailModel;
}


@property(nonatomic,retain)NSString *isShow;//判断是否显示解析和正确答案

@property(nonatomic,retain)NSString *childQTitleLable;
@property(nonatomic,retain)NSString *childQTypeLable;
@property(nonatomic,retain)NSString *childQIdLable;
@property(nonatomic,retain)NSString *childQPointLable;
@property(nonatomic,retain)NSString *childQAnswerLable;
@property(nonatomic,retain)NSString *childQBodyLable;
@property(nonatomic,retain)NSString *childQMmarkLable;
@property(nonatomic,retain)NSString *childHistoryAnswer;

@property(nonatomic,strong)id<countFillAnswer>delegate;
@property(nonatomic,retain)NSString *answerUser;//用户的答案

@property(nonatomic,retain)NSString *quesPlanName;//这题所在的安排

@property(nonatomic,assign)BOOL isMarkQuestion;//用户标记题目
@property(nonatomic,assign)BOOL isCollectQuestion;//用户收藏题目
@property(nonatomic,assign)BOOL isShowAndMarkQuesFlag;//用户是否显示解析标记

- (id)initWithFrame:(CGRect)frame :(NSString *)title1 :(NSString *)title2 :(NSString *)title3 :(NSString *)title4 :(NSString *)title5 :(NSString *)title6 :(NSString *)title7 :(Boolean)isShowAnswer :(NSString *)isShow;

- (id)initWithFrame:(CGRect)frame :(NSString *)title1 :(NSString *)title2 :(NSString *)title3 :(NSString *)title4 :(NSString *)title5 :(NSString *)title6 :(NSString *)title7 :(Boolean)isShowAnswer :(NSString *)isShow examOrPractice:(long)examFlag inPaper:(NSString *)planName;

- (id)initWithFrame:(CGRect)frame :(NSString *)title1 :(NSString *)title2 :(NSString *)title3 :(NSString *)title4 :(NSString *)title5 :(NSString *)title6 :(NSString *)title7 :(Boolean)isShowAnswer :(NSString *)isShow :(NSString *)title8;

//考试 练习
- (id)initWithFrame:(CGRect)frame questitle:(NSString*)quesTitle examInfo:(ExamQuestionModel*)examinfo isShowAnswer:(BOOL)ShowAnswer examOrPractice:(long)examFlag inPaper:(NSString *)planName;

//错题  收藏
-(id)initWithFrame:(CGRect)frame questitle:(NSString*)quesTitle QBody:(NSString *)quesBody Qmark:(NSString *)quesMark QAnswer:(NSString *)quesAnswer UserAnswer:(NSString *)userAsnser QType:(long)quesType Qid:(long)quesId PlanName:(NSString *)planName examOrPractice:(long)examFlag isShowAnswer:(BOOL)isShow;

@end
