//
//  examResultsViewController.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/21.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "SZLBaseVC.h"
#import "examGradeModel.h"
@interface ExamResultsViewController : SZLBaseVC<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *examInfoTabel;
@property (nonatomic, strong) UILabel *examGradelabel;
@property (nonatomic, strong) UILabel *examGradeNoticeLabel;
@property (nonatomic, strong) UIImageView *examGradeIV;
@property (nonatomic, strong) UIImageView *examPassIV;
@property (nonatomic, strong) ExamGradeModel *examGradeInfo;
@property(nonatomic,assign)long examOrPractice;//1表示考试试卷   2表示练习试卷 3表示错题   4表示收藏
@property(nonatomic,assign)float grade;
@end
