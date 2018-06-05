//
//  questionListViewController.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/20.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "SZLBaseVC.h"
#import "ExamDetailViewController.h"
@interface QuestionListViewController : SZLBaseVC<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)NSMutableArray *questionDone;
@property (nonatomic,strong)NSMutableArray *questionMark;
@property (nonatomic,copy)NSString * paperString;
@property (nonatomic,copy)NSString *tmInfo ;
@property(nonatomic,strong)ExamGradeModel *gradeInfoModel;//答题情况
@property (nonatomic, strong) UICollectionView *cardCollectionView;
@property (nonatomic, strong) UIButton *endExamBtn;
@property(nonatomic,assign)long examOrPractice;//1表示考试试卷   2表示练习试卷 3表示错题   4表示收藏
@property (assign, nonatomic) id<ChangeCurrentViewDelegate> delegate;
@end
