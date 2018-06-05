//
//  examResultsViewController.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/21.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "ExamResultsViewController.h"
#import "ExamInfoTableCell.h"

@interface ExamResultsViewController ()

@end

@implementation ExamResultsViewController

#pragma mark LazyLoading


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNav];
    [self createExamInfoTabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    DLog(@"dealloc");
}
#pragma mark 创建Nav
-(void)createNav{
    if(self.examOrPractice == 1){
        self.navigationTitle = @"考试结果";
    }else if(self.examOrPractice == 2){
        self.navigationTitle = @"练习结果";
    
    }
    
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"ic_register_back"] forState:UIControlStateNormal];
    [self.navigationLeftButton addTarget:self action:@selector(buttonBackToMyExamView) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)buttonBackToMyExamView{
    NSMutableArray*viewsArray = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];

    [self.navigationController popToViewController:viewsArray[1] animated:YES ];

}
/**
 *  创建_examGradeIV
 *  用于放在tableView的headerView里
 *
 */

-(void)createTableHeaderView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,WIDTH, 180)];
    headView.backgroundColor = MyBlue;
    
    _examGradeIV = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/2-50, 10,100, 100)];
    [headView addSubview:_examGradeIV];//成绩栏

    //比较时间
    
    
    if ([_examGradeInfo.paperIsunShowpoint isEqualToString:@"0"]&&![self isOverShowPointDate:_examGradeInfo.paperPlanResultDate]) {//不显示成绩
        _examGradelabel = nil;
        _examGradeIV.image = [UIImage
                              imageNamed:@"ic_exam_grade_unknow"];
        
        _examGradeNoticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, WIDTH-20, 55)];
        _examGradeNoticeLabel.numberOfLines = 2;
        _examGradeNoticeLabel.textAlignment = NSTextAlignmentCenter;
        _examGradeNoticeLabel.textColor = WhiteColor;
        _examGradeNoticeLabel.font = [UIFont fontWithName:@"Arial" size:16];
        _examGradeNoticeLabel.text = [NSString stringWithFormat:@"考试结果将在:%@公布，请在我的成绩中查看！",_examGradeInfo.paperPlanResultDate];
        [headView addSubview:_examGradeNoticeLabel];
        
        _examPassIV = nil;
        
    }else {
        _examGradeNoticeLabel = nil;
        _examGradeIV.image = [UIImage
                              imageNamed:@"ic_exam_grade"];
        _examGradeIV.contentMode = UIViewContentModeScaleAspectFit;
        
        _examGradelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        _examGradelabel.textAlignment = NSTextAlignmentCenter;
        _examGradelabel.textColor = WhiteColor;
        _examGradelabel.font = [UIFont fontWithName:@"Arial" size:25];
        _examGradelabel.text = [NSString stringWithFormat:@"%0.1f分",self.grade];
        [_examGradeIV addSubview:_examGradelabel];
        
        
        if (self.examOrPractice == 1) {
            _examPassIV = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/2+40, 60,80, 50)];
            _examPassIV.contentMode = UIViewContentModeScaleAspectFit;
            [headView addSubview:_examPassIV];//成绩是否通过或待公布
        }else{
            
        }
        if (_examGradeInfo.paperGrade>_examGradeInfo.paperPlanPassPoint||_examGradeInfo.paperGrade==_examGradeInfo.paperPlanPassPoint) {
            _examPassIV.image = [UIImage
                                 imageNamed:@"ic_exam_pass"];
        }else{
            _examPassIV.image = [UIImage
                                 imageNamed:@"ic_exam_not_pass"];
        
        }
        
    }
    _examInfoTabel.tableHeaderView = headView;
}

/**
 *  创建table
 */


-(void)createExamInfoTabel{
   
    _examInfoTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    
    _examInfoTabel.delegate = self;
    _examInfoTabel.dataSource = self;

    [self.contentView addSubview:self.examInfoTabel];
    
    [self createTableHeaderView];
    
    
}

#pragma mark - 判断是否超过公布时间


-(BOOL)isOverShowPointDate:(NSString *)showPointDateStr{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale* local =[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateformatter setLocale: local];
    NSDate *  nowDate=[NSDate date];
    NSString *  locationString=[dateformatter stringFromDate:nowDate];
    NSDate *currentDate = [dateformatter dateFromString:locationString];
    
    
    NSDate* getDate = [dateformatter dateFromString:showPointDateStr];
    
    if ([currentDate timeIntervalSinceDate:getDate]<0.0) {//没到公布答案时间
        return NO;
    }else{
        return  YES;
    }
    
}

#pragma mark TabelViewData Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //    return trainName.count;
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
//根据是否展开返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static    NSString * cellString = @"NewsCell";
    ExamInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"ExamInfoTableCell" owner:self options:nil];
        cell = [nibViews objectAtIndex:0];
    }
    
    if([_examGradeInfo.paperIsunShowpoint isEqualToString:@"0"]&&![self isOverShowPointDate:_examGradeInfo.paperPlanResultDate]){
        
        switch (indexPath.row) {
            case 0:
                cell.examResultInfoLabel.text = @"用时 ";
                cell.examResultInfoDetailLabel.text = _examGradeInfo.paperTime;
                break;
            case 1:
                cell.examResultInfoLabel.text = @"正确: ";
                cell.examResultInfoDetailLabel.text = @"--";
//                cell.noticeIV.image = [UIImage imageNamed:@"ic_exam_announce_answer"];
                break;
            case 2:
                cell.examResultInfoLabel.text = @"错误: ";
                cell.examResultInfoDetailLabel.text = @"--";
//                cell.noticeIV.image = [UIImage imageNamed:@"ic_exam_announce_answer"];
                break;
            case 3:
                cell.examResultInfoLabel.text = @"未做: ";
                cell.examResultInfoDetailLabel.text = @"--";
//                cell.noticeIV.image = [UIImage imageNamed:@"ic_exam_announce_answer"];
                break;
            default:
                break;
        }
        
        
    }else{
        cell.noticeIV = nil;
        switch (indexPath.row) {
            case 0:
                cell.examResultInfoLabel.text = @"用时 ";
                cell.examResultInfoDetailLabel.text = _examGradeInfo.paperTime;
                break;
            case 1:
                cell.examResultInfoLabel.text = @"正确: ";
                cell.examResultInfoDetailLabel.text = [NSString stringWithFormat:@"%d题",_examGradeInfo.paperTrueNum];
                break;
            case 2:
                cell.examResultInfoLabel.text = @"错误: ";
                cell.examResultInfoDetailLabel.text = [NSString stringWithFormat:@"%d题",_examGradeInfo.paperFalseNum];
                break;
            case 3:
                cell.examResultInfoLabel.text = @"未做: ";
                cell.examResultInfoDetailLabel.text = [NSString stringWithFormat:@"%d题",_examGradeInfo.paperUndoNum];
              
                break;
            default:
                break;
        }

    
    }
    
    
    
    
    return cell;
    
}

@end
