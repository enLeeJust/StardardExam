//
//  MainView.h
//  TNCheckBoxDemo
//
//  Created by Frederik Jacques on 02/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNCheckBoxGroup.h"

#import "ExamQuestionModel.h"
@protocol countCheckAnswer <NSObject>
@optional
- (void)userAnserCount;

@end

@interface CheckBoxMainView : UIViewController<UIWebViewDelegate>
{
    NSMutableArray *saveAnswer;
    NSString *str;
    UILabel *labltTitle;
    UILabel *hideLable;
    UIScrollView *scrollView;
    Boolean _isShowAnswer;
    
    UIButton *markQuesBtn;
    UIView *divideLineView;
}

@property(nonatomic,retain)NSString *childQTitleLable;
@property(nonatomic,retain)NSString *childQTypeLable;
@property(nonatomic,retain)NSString *childQIdLable;
@property(nonatomic,retain)NSString *childQPointLable;
@property(nonatomic,retain)NSString *childQAnswerLable;
@property(nonatomic,retain)NSString *childQBodyLable;
@property(nonatomic,retain)NSString *childQMmarkLable;
@property(nonatomic,retain)NSString *childHistoryAnswer;

@property(nonatomic,strong)id<countCheckAnswer>delegate;
@property(nonatomic,retain)NSString *answerUser;//用户的答案

@property(nonatomic,assign)BOOL isMarkQuestion;//用户的答案

@property (nonatomic, strong) TNCheckBoxGroup *loveGroup;

- (id)initWithFrame:(CGRect)frame :(NSString *)title1 :(NSString *)title2 :(NSString *)title3 :(NSString *)title4 :(NSString *)title5 :(NSString *)title6 :(NSString *)title7 :(Boolean)isShowAnswer;

- (id)initWithFrame:(CGRect)frame :(NSString *)title1 :(NSString *)title2 :(NSString *)title3 :(NSString *)title4 :(NSString *)title5 :(NSString *)title6 :(NSString *)title7 :(Boolean)isShowAnswer :(NSString *)title8;


- (id)initWithFrame:(CGRect)frame questitle:(NSString*)quesTitle examInfo:(ExamQuestionModel*)examinfo isShowAnswer:(BOOL)ShowAnswer;
@end
