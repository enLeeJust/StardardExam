//
//  QuestionnaireFillViewController.h
//  SZLTimber
//
//  Created by 桂舟 on 16/10/17.
//  Copyright © 2016年 timber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimberExam.h"
#import "questionnaireDetailModel.h"

@protocol countFillAnswer <NSObject>
@optional
- (void)userAnserCount;

@end

@interface QuestionnaireFillViewController : UIViewController{
    questionnaireDetailModel * _questionnaireInfo;

}
@property(nonatomic,strong) UITextField * textFiled;
@property(nonatomic,strong) UITextView * textUView;

@property(nonatomic,strong)UIScrollView *scroollView;

@property(nonatomic,strong)id<countFillAnswer>delegate;

@property(nonatomic,assign)long questionnaireID;
@property(nonatomic,retain)NSString *answerUser;//用户的答案

@property(nonatomic,retain)NSString *QuestionnaireTitle;
@property(nonatomic,retain)NSString *QuestionnaireOption;
@property(nonatomic,retain)NSString *childHistoryAnswer;

- (id)initWithFrame:(CGRect)frame QuestionnaireInfo:(questionnaireDetailModel*)questionnaireInfo;

@end
