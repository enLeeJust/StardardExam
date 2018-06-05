//
//  QuesTypeViewController.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/26.
//  Copyright © 2016年 timber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNRadioButtonGroup.h"
#import "TNCheckBoxGroup.h"
#import "ExamQuestionModel.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import <NSAttributedString+YYText.h>
#import <YYLabel.h>

@protocol countCheckAnswer <NSObject>
@optional
- (void)userCheckAnserCount;

@end

@protocol countRadioAnswer <NSObject>
@optional
- (void)userRadioAnserCount;
@end
@interface QuesTypeViewController : UIViewController<UIWebViewDelegate>{
    NSMutableArray *saveAnswer;
    YYLabel *labltTitle;
    Boolean _isShowAnswer;
    long _examOrPractice;//1表示考试 2表示练习 3表示错题  4表示收藏
    UIButton *markQuesBtn;
    UIView *divideLineView;
    
    UIButton *showMarkBtn;
    UIView *showMarkView;

    ExamQuestionModel *quesDetailModel;
    

}

//@property(nonatomic,strong)UIScrollView *scroollView;


@property(nonatomic,retain)NSString *childQTitleLable;
@property(nonatomic,retain)NSString *childQTypeLable;
@property(nonatomic,retain)NSString *childQIdLable;
@property(nonatomic,retain)NSString *childQPointLable;
@property(nonatomic,retain)NSString *childQAnswerLable;
@property(nonatomic,retain)NSString *childQBodyLable;
@property(nonatomic,retain)NSString *childQMmarkLable;
@property(nonatomic,retain)NSString *childHistoryAnswer;

@property(nonatomic,strong)id<countCheckAnswer>countCheckDelegate;
@property(nonatomic,strong)id<countRadioAnswer>countRadioDelegate;
@property(nonatomic,retain)NSString *answerUser;//用户的答案

@property(nonatomic,retain)NSString *userAnswerInErr;//在用户错题收藏中的答案
@property(nonatomic,retain)NSString *quesPlanName;


@property(nonatomic,assign)BOOL isMarkQuestion;//用户标记题目
@property(nonatomic,assign)BOOL isCollectQuestion;//用户收藏题目
@property(nonatomic,assign)BOOL isShowAndMarkQuesFlag;//用户是否显示解析标记


@property (nonatomic, strong) TNRadioButtonGroup *temperatureGroup;
@property (nonatomic, strong) TNCheckBoxGroup *loveGroup;
//@property (nonatomic, assign) int quesTypeFlag;//用于标识 题目类型:单选，多选，简答


//- (id)initWithFrame:(CGRect)frame questitle:(NSString*)quesTitle examInfo:(ExamQuestionModel*)examinfo isShowAnswer:(BOOL)ShowAnswer examOrPractice:(long)examFlag;


- (id)initWithFrame:(CGRect)frame questitle:(NSString*)quesTitle examInfo:(ExamQuestionModel*)examinfo isShowAnswer:(BOOL)ShowAnswer examOrPractice:(long)examFlag inPaper:(NSString *)planName;


-(id)initWithFrame:(CGRect)frame questitle:(NSString*)quesTitle QBody:(NSString *)quesBody Qmark:(NSString *)quesMark QAnswer:(NSString *)quesAnswer UserAnswer:(NSString *)userAsnser QType:(long)quesType Qid:(long)quesId PlanName:(NSString *)planName examOrPractice:(long)examFlag isShowAnswer:(BOOL)isShow;

@end
