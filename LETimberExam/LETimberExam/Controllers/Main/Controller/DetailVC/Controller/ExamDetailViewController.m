//
//  ExamDetailViewController.m
//  BigShark
//
//  Created by Mac on 16/2/26.
//  Copyright © 2016年 com.timber. All rights reserved.
//
#import "ExamDetailViewController.h"
#import "QuesTypeViewController.h"
#import "FillBlankViewController.h"
#import "GuGuSegmentBarView.h"
#import "GuGuLandscapeTableView.h"
#import "MZTimerLabel.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "questionListViewController.h"
#import "ExamQuestionModel.h"//试卷模型
#import "WebServiceModel.h"

#import "examGradeModel.h"//考试成绩情况的模型
#define ID        @"id"//数据库主键，自增长
@interface ExamDetailViewController ()<GuGuIndexDelegate,MZTimerLabelDelegate,UIAlertViewDelegate>{
    

    NSMutableArray *controllerArray;//记录试题总数
    UILabel * currentExamLabel;//显示当前位置
    UILabel * totalTopicNumLabel;//所有题目总数
    UILabel *examOverTimeLabel;//倒计时
    
    UILabel *questionTypeLabel;//题目类型
    
    UIView * questionTypeAndNumView;
    
    GuGuLandscapeTableView * contentTable ;
    GuGuSegmentBarView * barView;

    NSData *paperData;//试卷信息
    NSMutableArray * paperArr;//试题组
    
    NSMutableArray *examResult;
    int trueNumber;//答对计数
    int erorNumber;//答错计数
    int nodo;       //未做
    float examnum;   //得分
    
    FMDatabase *db;
    NSString *database_path;//数据库路径
    int _page;

    //加一个计数器
    NSTimer *timer;
    int userDoQuesTime;
    BOOL _wasKeyboardManagerEnabled;
}
@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,strong)ExamGradeModel *gradeInfoModel;
@property(nonatomic,strong)MBProgressHUD *hud;;
@property(nonatomic,strong)MZTimerLabel *timerExample;
@property (nonatomic,strong)UILabel *msgLabel;
@end

@implementation ExamDetailViewController


#pragma mark - lazyLoading
-(NSMutableArray *)titleArray{
    
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] init];
    }
    return _titleArray;
}

//-(UILabel *)msgLabel{
//    if (!_msgLabel) {
//        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
//        
//    }
//    return _msgLabel;
//}
#pragma mark ViewLoad
-(void)viewDidLoad{
    [super viewDidLoad];
    _gradeInfoModel = [[ExamGradeModel alloc] init];
    paperData = [[NSMutableData alloc]init];
    paperArr =[[NSMutableArray alloc]init];

    
    //    数据库路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    db = [FMDatabase databaseWithPath:database_path];
    [self createTable:TABLEERROR];
    
    if(_examOrPractice == 1 ||_examOrPractice == 2){
        [self getPaperDetailInfo];
    }else if(_examOrPractice == 3){//错题
        [self makeErrorAndCollectQuesList:self.questionListsArr];
    }else if (_examOrPractice == 4){//收藏
        [self makeErrorAndCollectQuesList:self.questionListsArr];
    }
    [self creatExamNav];
}

-(void)dealloc{
    [timer invalidate];
    [self.timerExample pause];    
    DLog(@"success dealloc");

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
}

#pragma mark 自定义导航栏
-(void)creatExamNav{//导航栏上控件
    
//    self.navigationController.interactivePopGestureRecognizerType = InteractivePopGestureRecognizerNone;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"ic_register_back"] forState:UIControlStateNormal];
    [self.navigationLeftButton addTarget:nil action:@selector(BackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *timeStrIV = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/2-25-30, self.navigationView.frame.size.height / 2 -10 ,30,30 )];
    timeStrIV.image = [UIImage imageNamed:@"ic_exam_clock"];
    timeStrIV.contentMode = UIViewContentModeScaleAspectFit;
    [self.navigationView addSubview:timeStrIV];
    
    //中间的倒计时
    examOverTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-25, self.navigationView.frame.size.height / 2 - 4 ,60,21 )];
    examOverTimeLabel.textColor = [UIColor whiteColor];
    examOverTimeLabel.textAlignment = NSTextAlignmentCenter;
    examOverTimeLabel.font = [UIFont fontWithName:@"Arial" size:14];
    if(_examOrPractice==1){//考试
        _timerExample = [[MZTimerLabel alloc] initWithLabel:examOverTimeLabel andTimerType:MZTimerLabelTypeTimer];
        [_timerExample setCountDownTime:[self.examTime intValue]];//考试时间
        _timerExample.delegate = self;
        [self.timerExample start];
    }else{//收藏或错题
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        examOverTimeLabel.text = @"00:00:00";
        
    }
    
    [self.navigationView addSubview:examOverTimeLabel];

}
//返回按钮操作
-(void)BackBtnClick{
    
    if (_examOrPractice==1) {
        [JCAlertView showTwoButtonsWithTitle:@"温馨提示" Message:@"是否放弃本次考试？" ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"继续答题" Click:^{
        } ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:@"放弃答题" Click:^{
            [self.timerExample pause];
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
    }else{
        [timer invalidate];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)timerFired:(NSTimer *)timer//这个函数将会执行一个循环的逻辑
{
    userDoQuesTime++;
    int second = userDoQuesTime %60;//秒
    int minute = userDoQuesTime /60%60;
    int hour = userDoQuesTime / (24 * 3600)%3600;
    NSString *secStr;
    NSString *minStr;
    NSString *hourStr;
    if (hour<10) {
        hourStr = [NSString stringWithFormat:@"0%d:",hour];
    }else{
        hourStr = [NSString stringWithFormat:@"%d:",hour];
    }
    if (minute<10) {
        minStr = [NSString stringWithFormat:@"0%d:",minute];
    }else{
        minStr = [NSString stringWithFormat:@"%d:",minute];
    }
    if (second<10) {
        secStr = [NSString stringWithFormat:@"0%d",second];
    }else{
        secStr = [NSString stringWithFormat:@"%d",second];
    }
    NSString *mtimeStr = [NSString stringWithFormat:@"%@%@%@",hourStr,minStr,secStr];
    
    examOverTimeLabel.text = [NSString stringWithFormat:@"%@",mtimeStr];
}
#pragma mark MZTimerLabelDelegate
//考试时间到，已自动提交试卷 MZTimerLabel的代理方法
-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    
    [self.timerExample pause];
    [timer invalidate];
    [JCAlertView showOneButtonWithTitle:nil Message:@"答题时间到，系统强制交卷!" ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:@"确定" Click:^{
        [self.navigationController popViewControllerAnimated:YES];
        
        [self getQuesAnswerInfo];
        [self makePaperData];
        [self submitLoadExam];//提交试卷
    }];
    
    
}

#pragma mark  创建题目类型视图
-(void)createTypeAndNumView{
    
    //滚动的试题
    
    questionTypeAndNumView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    questionTypeAndNumView.backgroundColor = WhiteColor;
    
    questionTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, WIDTH/2, 20)];
    questionTypeLabel.textColor = MyBlue;
    [questionTypeAndNumView addSubview:questionTypeLabel];
    
    currentExamLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-80, 10, 30, 21)];
    currentExamLabel.textColor = MyBlue;
    currentExamLabel.textAlignment = NSTextAlignmentRight;
    currentExamLabel.font = [UIFont fontWithName:@"Arial" size:16];
    [questionTypeAndNumView addSubview:currentExamLabel];
    
    
    totalTopicNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-50, 10, 45, 21)];
    totalTopicNumLabel.textColor = [UIColor darkGrayColor];
    totalTopicNumLabel.textAlignment = NSTextAlignmentLeft;
    totalTopicNumLabel.font = [UIFont fontWithName:@"Arial" size:16];
    [questionTypeAndNumView addSubview:totalTopicNumLabel];
    
    [self.contentView addSubview:questionTypeAndNumView];
}


#pragma mark  创建空视图
-(void)createEmptyView{
    self.contentView.backgroundColor = WhiteColor;
    _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2-100, 180, 200, 40)];
    _msgLabel.textColor = [UIColor grayColor];
    _msgLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    _msgLabel.text = @"该试卷没有题目";
    _msgLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_msgLabel];
}

#pragma mark - model

/**
 *  用于给试题model 赋值
 *
 *  @param responseData NSMutableArray
 *
 *  @return 试题模型的数组
 */
-(NSMutableArray *)createModelData:(NSMutableArray *)responseData{
    NSMutableArray *quesModelsArr = [[NSMutableArray alloc] init];
    for (NSDictionary *quesDict in responseData) {
        ExamQuestionModel *quesModel = [[ExamQuestionModel alloc] initWithDictionary:quesDict];
        
        [quesModelsArr addObject:quesModel];
        
    }
    
    //    NSLog(@"生成的数据模型:%@",quesModelsArr);
    
    return quesModelsArr;
}

/**
 *  用于给 错题或收藏 model 赋值
 *
 *  @param responseData NSMutableArray
 *
 *  @return 错题或收藏试题模型的数组
 */
-(NSMutableArray *)createErrorModelData:(NSMutableArray *)responseData{
    NSMutableArray *quesModelsArr = [[NSMutableArray alloc] init];
    for (NSDictionary *quesDict in responseData) {
        ErrorQuestionModel *quesModel = [[ErrorQuestionModel alloc] initWithDictionary:quesDict];
        
        [quesModelsArr addObject:quesModel];
        
    }
    
    //    NSLog(@"生成的数据模型:%@",quesModelsArr);
    
    return quesModelsArr;
}

#pragma mark - get PaperDetailInfo
/**
 *  获取试卷详细内容
 */
-(void)getPaperDetailInfo{
    __weak ExamDetailViewController * wself = self;
    if (kNetworkNotReachability) {
        [self.view makeToast:kError_Network_NotReachable];
        return;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.color = [UIColor colorWithRed:0 green:0.0 blue:0.0 alpha:0.5];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __block ApiRequest *request = [SZLServerHelper getPaperDetailsInfoRequest:_paperInfo.paperPlanId PaperID:_paperInfo.paperPId callback:^(NSInteger errCode, ApiResponse *response, BOOL success){
            [wself.requestArr removeObject:request];
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.hud.hidden = YES;
            });
            
            @try {
                if (success) {
                    NSDictionary *data = response.data;
                    NSInteger remainTimes = response.remianTimes;
                    if([wself.delegate respondsToSelector:@selector(ChangePaperRemainTimes:)])
                    {
                        //send the delegate function with the amount entered by the user
                        [wself.delegate ChangePaperRemainTimes:remainTimes];
                    }
                    
                    wself.questionListsArr = [data objectForKey:@"dtInfo"];
                    
                    if (!wself.questionListsArr||wself.questionListsArr.count == 0) {
                        //没有错题的提示
                        [wself createEmptyView];
                        
                        
                    }else{
                        //创建头视图
                        [wself createTypeAndNumView];
                        [wself makeQuestionList:[wself createModelData:wself.questionListsArr]];
                    }
                    
                    
                    
                }else{
                    [wself.view makeToast:response.errDesc];
                }
            } @catch (NSException *exception) {
                NSLog(@"exception:%@",exception);
            } @finally {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                wself.hud.hidden = YES;
                
            }
            
            
        }];
        [wself.requestArr addObject:request];
        
    });
    
}

/**
 *  提交试卷
 *  ReceiveKeep
 *  @param urlnew 接口url
 *  @param prama  参数
 */


-(void)uploadPaperDetail:(NSString *)paperInfo inPaper:(NSString *)tmInfo{
    __weak ExamDetailViewController * wself = self;
    if (kNetworkNotReachability) {
        [self.view makeToast:kError_Network_NotReachable];
        return;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.color = [UIColor colorWithRed:0 green:0.0 blue:0.0 alpha:0.5];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __block ApiRequest *request = [SZLServerHelper uploadPaperDetailsInfoRequest:paperInfo TMinfo:tmInfo callback:^(NSInteger errCode, ApiResponse *response, BOOL success){
            [wself.requestArr removeObject:request];
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.hud.hidden = YES;
            });
            
            @try {
                if (success) {
                    [timer invalidate];
                    [self.timerExample pause];
                    
                    ExamResultsViewController *next = [[ExamResultsViewController alloc] init];
                    next.examOrPractice = self.examOrPractice;
                    next.examGradeInfo = wself.gradeInfoModel;
                    next.grade = response.getPoint;
                    [wself.navigationController pushViewController:next animated:YES];
                    
                }else{
                    [wself.timerExample start];
                    [wself.view makeToast:response.errDesc];
                }
            } @catch (NSException *exception) {
                NSLog(@"exception:%@",exception);
            } @finally {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                wself.hud.hidden = YES;
                
            }
        }];
        [wself.requestArr addObject:request];
        
    });

}



#pragma mark  ChangeCurrentViewDelegate
-(void)changeToSelectedView:(int)index{
    [barView selectIndex:index];
    
}
#pragma mark - createQuestionView
-(UIViewController *)CreateQuesView:(NSString *)quesType{
    int quesTypeId;
    if ([quesType isEqualToString:@"Question_S_Choice.ascx"]) {//单选
        quesTypeId = 0;
    }else if ([quesType isEqualToString:@"Question_M_Choice.ascx"]) {//多选
        quesTypeId = 1;
    }else if ([quesType isEqualToString:@"Question_Checking.ascx"]) {//判断
        quesTypeId = 2;
    }else if ([quesType isEqualToString:@"Question_Fill.ascx"]) {//填空
        quesTypeId = 3;
    }else if ([quesType isEqualToString:@"Question_Answer.ascx"]) {//简答
        quesTypeId = 4;
    }else{
        
    }
    NSLog(@"-----quesType----:%@",quesType);
    
    NSArray * desVcs = @[@"QuesTypeViewController",//单选
                         @"QuesTypeViewController",//多选
                         @"QuesTypeViewController",//判断
                         @"FillBlankViewController",//
                         @"FillBlankViewController",
                         @"FillBlankViewController",
                         @"FillBlankViewController"];//
    Class cls = NSClassFromString(desVcs[quesTypeId]);
    UIViewController * currentQuesView = [[cls alloc]init];
    
    return currentQuesView;
    
}


//制作试题列表
-(void)makeQuestionList:(NSMutableArray *)quesArr{
    
    controllerArray = [[NSMutableArray alloc]init];//记录试题总数
    _titleArray = [[NSMutableArray alloc]init];
    int quesIndex = 1;
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    Boolean isShow;//是否显示解析和答案
    if ([self.isShowAnswer isEqualToString:@"true"]) {
        isShow = YES;
    }else{
        isShow = NO;
    }
    
    
    for(ExamQuestionModel *quesModel in quesArr) {
        NSUserDefaults * userDef =[NSUserDefaults standardUserDefaults];
        [userDef setObject:quesModel.exam_key forKey:@"examKey"];
        [userDef synchronize];
        
        NSRange range;
        //        NSString *string = [member objectForKey:@"QMark"];
        NSString *quesMark = quesModel.ques_mark;
        while ((range = [quesMark rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
            quesMark=[quesMark stringByReplacingCharactersInRange:range withString:@""];
        }
        
        
        NSString *titleLabel = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%d、",quesIndex],quesModel.ques_title];
        /**
         *  定义考试题目界面,和题目类型
         */
        NSString *quesType = quesModel.ModuleUrl;
        UIViewController *quesVC = [self CreateQuesView:quesType];
        NSString *quesTypeName = @"";
        
        UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
        //单次点击的特征
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        
        if ([quesType isEqualToString:@"Question_S_Choice.ascx"]) {//单选
            quesTypeName =@"单项选择题";
            quesVC = [[QuesTypeViewController alloc] initWithFrame:bounds questitle:titleLabel examInfo:quesModel isShowAnswer:isShow examOrPractice:_examOrPractice inPaper:_PlanName];
        }else if ([quesType isEqualToString:@"Question_M_Choice.ascx"]) {//多选
            quesTypeName =@"多项选择题";
            quesVC = [[QuesTypeViewController alloc]initWithFrame:bounds questitle:titleLabel examInfo:quesModel isShowAnswer:isShow examOrPractice:_examOrPractice inPaper:_PlanName];
        }else if ([quesType isEqualToString:@"Question_Checking.ascx"]) {//判断
            quesTypeName =@"判断题";
            quesVC = [[QuesTypeViewController alloc] initWithFrame:bounds questitle:titleLabel examInfo:quesModel isShowAnswer:isShow examOrPractice:_examOrPractice inPaper:_PlanName];
        }else if ([quesType isEqualToString:@"Question_Fill.ascx"]) {//填空
            quesTypeName =@"填空题";
            quesVC = [[FillBlankViewController alloc] initWithFrame:bounds questitle:titleLabel examInfo:quesModel isShowAnswer:isShow examOrPractice:_examOrPractice inPaper:_PlanName];
            [quesVC.view addGestureRecognizer:singleTap];
        }else if ([quesType isEqualToString:@"Question_Answer.ascx"]) {//简答
            quesTypeName =@"简答题";
            
            quesVC = [[FillBlankViewController alloc] initWithFrame:bounds questitle:titleLabel examInfo:quesModel isShowAnswer:isShow examOrPractice:_examOrPractice inPaper:_PlanName];
            [quesVC.view addGestureRecognizer:singleTap];
        }else{
            
        }
        
        
//        switch (quesModel.type_id) {
//            case 1:
//                quesTypeName =@"单项选择题";
//                quesVC = [[QuesTypeViewController alloc] initWithFrame:bounds questitle:titleLabel examInfo:quesModel isShowAnswer:isShow examOrPractice:_examOrPractice inPaper:_PlanName];
//                break;
//            case 2:
//                quesTypeName =@"多项选择题";
//                quesVC = [[QuesTypeViewController alloc]initWithFrame:bounds questitle:titleLabel examInfo:quesModel isShowAnswer:isShow examOrPractice:_examOrPractice inPaper:_PlanName];
//                
//                break;
//            case 3:
//                quesTypeName =@"判断题";
//                quesVC = [[QuesTypeViewController alloc] initWithFrame:bounds questitle:titleLabel examInfo:quesModel isShowAnswer:isShow examOrPractice:_examOrPractice inPaper:_PlanName];
//                break;
//                
//            case 4:
//                quesTypeName =@"填空题";
//                
//                quesVC = [[FillBlankViewController alloc] initWithFrame:bounds questitle:titleLabel examInfo:quesModel isShowAnswer:isShow examOrPractice:_examOrPractice inPaper:_PlanName];
//                [quesVC.view addGestureRecognizer:singleTap];
//                break;
//            case 5:
//                quesTypeName =@"简答题";
//                
//                quesVC = [[FillBlankViewController alloc] initWithFrame:bounds questitle:titleLabel examInfo:quesModel isShowAnswer:isShow examOrPractice:_examOrPractice inPaper:_PlanName];
//                [quesVC.view addGestureRecognizer:singleTap];
//                
//                break;
//            case 26:
//                quesTypeName =@"问答题";
//                
//                quesVC = [[FillBlankViewController alloc] initWithFrame:bounds questitle:titleLabel examInfo:quesModel isShowAnswer:isShow examOrPractice:_examOrPractice inPaper:_PlanName];
//                [quesVC.view addGestureRecognizer:singleTap];
//                
//                break;
//            case 37:
//                quesTypeName =@"综合题";
//                
//                quesVC = [[FillBlankViewController alloc] initWithFrame:bounds questitle:titleLabel examInfo:quesModel isShowAnswer:isShow examOrPractice:_examOrPractice inPaper:_PlanName];
//                [quesVC.view addGestureRecognizer:singleTap];
//                
//                break;
//                
//            default:
//                break;
//        }
        [_titleArray addObject:quesTypeName];
        [controllerArray addObject:quesVC];
        /**
         *  题号自增
         */
        quesIndex++;
        currentExamLabel.text = @"1";
        totalTopicNumLabel.text = [NSString stringWithFormat:@" /%ld",controllerArray.count];
        questionTypeLabel.text = [NSString stringWithFormat:@"%@",_titleArray[0]];
        
    }
    
    //滚动的每道题目编号
    barView = [[GuGuSegmentBarView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 30) andItems:_titleArray];
    barView.clickDelegate = self;
    
    contentTable = [[GuGuLandscapeTableView alloc]initWithFrame:CGRectMake(0, 55, WIDTH, Height-70-110-15) Array:controllerArray];
    contentTable.swipeDelegate = self;
    
    [self.contentView addSubview:contentTable];
    
    //    制作交卷和答题卡按钮
    [self makeExamContentBtnView];
    
}

/////////////////////////////////制作错题和收藏的试题列表///////////////////////////////////
-(void)makeErrorAndCollectQuesList:(NSMutableArray *)quesArr{
    controllerArray = [[NSMutableArray alloc]init];//记录试题总数
    _titleArray = [[NSMutableArray alloc]init];
    int quesIndex = 1;
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    Boolean isShow;//是否显示解析和答案
    if ([self.isShowAnswer isEqualToString:@"true"]) {
        isShow = YES;
    }else{
        isShow = NO;
    }
    
    [self createTypeAndNumView];
    for(NSDictionary *quesDict in quesArr) {
        NSUserDefaults * userDef =[NSUserDefaults standardUserDefaults];
        [userDef setObject:quesDict[@"examKey"] forKey:@"examKey"];
        [userDef synchronize];
        
        NSRange range;
        NSString *quesMark = [quesDict objectForKey:@"QMARK"];
        while ((range = [quesMark rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
            quesMark=[quesMark stringByReplacingCharactersInRange:range withString:@""];
        }
        
        
        NSString *titleLabel = [NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%d、",quesIndex],[quesDict objectForKey:@"QTITLE"]];
        /**
         *  定义考试题目界面,和题目类型
         */
//        int quesTypeID = [[quesDict objectForKey:@"QTYPE"] intValue] ;
        NSString *quesType = [quesDict objectForKey:@"ModuleUrl"];
        
        UIViewController *quesVC = [self CreateQuesView:quesType];
        NSString *quesTypeName = @"";
        UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
        //单次点击的特征
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        int quesTypeId;
        if ([quesType isEqualToString:@"Question_S_Choice.ascx"]) {//单选
            quesTypeId = 1;
        }else if ([quesType isEqualToString:@"Question_M_Choice.ascx"]) {//多选
            quesTypeId = 2;
        }else if ([quesType isEqualToString:@"Question_Checking.ascx"]) {//判断
            quesTypeId = 3;
        }else if ([quesType isEqualToString:@"Question_Fill.ascx"]) {//填空
            quesTypeId = 4;
        }else if ([quesType isEqualToString:@"Question_Answer.ascx"]) {//简答
            quesTypeId = 5;
        }else{
            
        }
        
        
        
        
        switch (quesTypeId) {
            case 1:
                quesTypeName =@"单项选择题";
                quesVC = [[QuesTypeViewController alloc] initWithFrame:bounds questitle:titleLabel QBody:[quesDict objectForKey:@"QBODY"] Qmark:[quesDict objectForKey:@"QMARK"] QAnswer:[quesDict objectForKey:@"QANSWER"] UserAnswer:[quesDict objectForKey:@"UserAnswer"] QType:quesTypeId Qid:[[quesDict objectForKey:@"QID"] intValue] PlanName:_PlanName examOrPractice:_examOrPractice isShowAnswer:isShow];
                break;
            case 2:
                quesTypeName =@"多项选择题";
                quesVC = [[QuesTypeViewController alloc] initWithFrame:bounds questitle:titleLabel QBody:[quesDict objectForKey:@"QBODY"] Qmark:[quesDict objectForKey:@"QMARK"] QAnswer:[quesDict objectForKey:@"QANSWER"] UserAnswer:[quesDict objectForKey:@"UserAnswer"] QType:quesTypeId Qid:[[quesDict objectForKey:@"QID"] intValue] PlanName:_PlanName examOrPractice:_examOrPractice isShowAnswer:isShow];
                
                break;
            case 3:
                quesTypeName =@"判断题";
                quesVC = [[QuesTypeViewController alloc] initWithFrame:bounds questitle:titleLabel QBody:[quesDict objectForKey:@"QBODY"] Qmark:[quesDict objectForKey:@"QMARK"] QAnswer:[quesDict objectForKey:@"QANSWER"] UserAnswer:[quesDict objectForKey:@"UserAnswer"] QType:quesTypeId Qid:[[quesDict objectForKey:@"QID"] intValue] PlanName:_PlanName examOrPractice:_examOrPractice isShowAnswer:isShow];
                break;
                
            case 4:
                quesTypeName =@"填空题";
                
                quesVC = [[FillBlankViewController alloc] initWithFrame:bounds questitle:titleLabel QBody:[quesDict objectForKey:@"QBODY"] Qmark:[quesDict objectForKey:@"QMARK"] QAnswer:[quesDict objectForKey:@"QANSWER"] UserAnswer:[quesDict objectForKey:@"UserAnswer"] QType:quesTypeId Qid:[[quesDict objectForKey:@"QID"] intValue] PlanName:_PlanName examOrPractice:_examOrPractice isShowAnswer:isShow];
                [quesVC.view addGestureRecognizer:singleTap];
                break;
            case 5:
                quesTypeName =@"简答题";
                quesVC = [[FillBlankViewController alloc] initWithFrame:bounds questitle:titleLabel QBody:[quesDict objectForKey:@"QBODY"] Qmark:[quesDict objectForKey:@"QMARK"] QAnswer:[quesDict objectForKey:@"QANSWER"] UserAnswer:[quesDict objectForKey:@"UserAnswer"] QType:quesTypeId Qid:[[quesDict objectForKey:@"QID"] intValue] PlanName:_PlanName examOrPractice:_examOrPractice isShowAnswer:isShow];
                [quesVC.view addGestureRecognizer:singleTap];
            case 26:
                quesTypeName =@"简答题";
                quesVC = [[FillBlankViewController alloc] initWithFrame:bounds questitle:titleLabel QBody:[quesDict objectForKey:@"QBODY"] Qmark:[quesDict objectForKey:@"QMARK"] QAnswer:[quesDict objectForKey:@"QANSWER"] UserAnswer:[quesDict objectForKey:@"UserAnswer"] QType:quesTypeId Qid:[[quesDict objectForKey:@"QID"] intValue] PlanName:_PlanName examOrPractice:_examOrPractice isShowAnswer:isShow];
                [quesVC.view addGestureRecognizer:singleTap];
                break;
                
            case 37:
                quesTypeName =@"简答题";
                quesVC = [[FillBlankViewController alloc] initWithFrame:bounds questitle:titleLabel QBody:[quesDict objectForKey:@"QBODY"] Qmark:[quesDict objectForKey:@"QMARK"] QAnswer:[quesDict objectForKey:@"QANSWER"] UserAnswer:[quesDict objectForKey:@"UserAnswer"] QType:quesTypeId Qid:[[quesDict objectForKey:@"QID"] intValue] PlanName:_PlanName examOrPractice:_examOrPractice isShowAnswer:isShow];
                [quesVC.view addGestureRecognizer:singleTap];
                break;
            default:
                break;
        }
        [_titleArray addObject:quesTypeName];
        [controllerArray addObject:quesVC];
        /**
         *  题号自增
         */
        quesIndex++;
        currentExamLabel.text = @"1";
        totalTopicNumLabel.text = [NSString stringWithFormat:@" /%ld",controllerArray.count];
        questionTypeLabel.text = [NSString stringWithFormat:@"%@",_titleArray[0]];
        
    }

    //滚动的每道题目编号
    barView = [[GuGuSegmentBarView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30) andItems:_titleArray];
    barView.clickDelegate = self;
    
    contentTable = [[GuGuLandscapeTableView alloc]initWithFrame:CGRectMake(0, 55, WIDTH, Height-70-110-15) Array:controllerArray];
    contentTable.swipeDelegate = self;
    [self.contentView addSubview:contentTable];
    //    制作交卷和答题卡按钮
    [self makeExamContentBtnView];
    
}

-(void)singleTap
{
    [self.contentView endEditing:YES];
}
//根据bar选的题目content切换到选择的题目
-(void)barSelectedIndexChanged:(int)newIndex
{
    if (newIndex >= 0)
    {
        currentExamLabel.text = [NSString stringWithFormat:@"%d",newIndex+1];
        questionTypeLabel.text = [NSString stringWithFormat:@"%@",_titleArray[newIndex]];
        
        [contentTable selectIndex:newIndex];
    }
}



#pragma mark - GuGuIndexDelegate
//根据content选的题目bar滑动切换到选择的错误题目
-(void)contentSelectedIndexChanged:(int)newIndex
{
    currentExamLabel.text = [NSString stringWithFormat:@"%d",newIndex+1];
    questionTypeLabel.text = [NSString stringWithFormat:@"%@",_titleArray[newIndex]];
//    [contentTable selectIndex:newIndex];
}
//根据滑块的距离判断是哪一个题
-(void)scrollOffsetChanged:(CGPoint)offset
{
    _page = (int)offset.y / WIDTH;
    DLog(@"--------page:%d",_page);
//    currentExamLabel.text = [NSString stringWithFormat:@"%d",_page+1];
//    questionTypeLabel.text = [NSString stringWithFormat:@"%@",_titleArray[_page]];
//    [contentTable selectIndex:_page+1];
}
#pragma mark - create View
//    制作交卷和答题卡按钮 以及shangtiyi
-(void)makeExamContentBtnView{
    if(_examOrPractice <3){
        UIButton *answerCardBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        answerCardBtn.frame = CGRectMake(WIDTH/2-140, Height-64-50, 100, 30);
        [answerCardBtn addTarget:self action:@selector(jumpToQuestionListController) forControlEvents:UIControlEventTouchUpInside];
        //    [answerCardBtn addTarget:self action:@selector(questionListView) forControlEvents:UIControlEventTouchUpInside];
        [answerCardBtn setBackgroundImage:[UIImage imageNamed:@"ic_exam_answer_card"] forState:UIControlStateNormal];
        [answerCardBtn setTitle:@"答题卡" forState:UIControlStateNormal];
        [answerCardBtn setTitleColor:MyBlue forState:UIControlStateNormal];
        [self.contentView addSubview:answerCardBtn];
        
        UIButton *uploadExamBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        uploadExamBtn.frame = CGRectMake(WIDTH/2+50, Height-64-50, 100, 30);
        [uploadExamBtn addTarget:self action:@selector(upExamPage) forControlEvents:UIControlEventTouchUpInside];
        [uploadExamBtn setTitle:@"交  卷" forState:UIControlStateNormal];
        [uploadExamBtn setBackgroundImage:[UIImage imageNamed:@"ic_exam_upload_question"] forState:UIControlStateNormal];
        [self.contentView addSubview:uploadExamBtn];
        
    }else{
        
        UIButton *answerCardBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        answerCardBtn.frame = CGRectMake(WIDTH/2-50, Height-64-50, 100, 30);
        [answerCardBtn addTarget:self action:@selector(jumpToQuestionListController) forControlEvents:UIControlEventTouchUpInside];
        //    [answerCardBtn addTarget:self action:@selector(questionListView) forControlEvents:UIControlEventTouchUpInside];
        [answerCardBtn setBackgroundImage:[UIImage imageNamed:@"ic_exam_answer_card"] forState:UIControlStateNormal];
        [answerCardBtn setTitle:@"答题卡" forState:UIControlStateNormal];
        [answerCardBtn setTitleColor:MyBlue forState:UIControlStateNormal];
        [self.contentView addSubview:answerCardBtn];
        
    }
    
    
    
}



#pragma mark ---------------跳转到答题卡界面-------------
-(void)jumpToQuestionListController{
    QuestionListViewController * quesCard = [[QuestionListViewController alloc] init];
    quesCard.examOrPractice = _examOrPractice;
    NSLog(@"_examOrPractice:%ld",_examOrPractice);
    if (_examOrPractice<3) {
        [self getQuesAnswerInfo];
        [self makePaperData];
        quesCard.questionDone = [self getUserQuestionsDoneOrMark:0];
        quesCard.questionMark = [self getUserQuestionsDoneOrMark:1];
        quesCard.paperString = [self getPaperInfoStr];
        quesCard.tmInfo = [self getTmInfoStr];
        quesCard.gradeInfoModel = _gradeInfoModel;
        
    }else{
    
        quesCard.questionDone = [self getUserErrorsQuestionDone];
    }
    
    quesCard.delegate = self;
    
    [self.navigationController pushViewController:quesCard animated:YES];
    
}

#pragma mark 获取用户做题或者标记的列表(考试或练习)
-(NSMutableArray *)getUserQuestionsDoneOrMark:(int)doneOrMark{
    int quesNum = 0;
    NSMutableArray *isDoneArr =  [[NSMutableArray alloc] init];

    if (doneOrMark == 0) {//做题
        for(ExamQuestionModel *quesModel in [self createModelData:_questionListsArr]) {
//            long typeId = quesModel.type_id;
            NSString *quesType = quesModel.ModuleUrl;
            NSString *userAnswer;
            
            if ([quesType isEqualToString:@"Question_S_Choice.ascx"]) {//单选
                QuesTypeViewController *vc = [controllerArray objectAtIndex:quesNum];
                userAnswer = vc.answerUser;
                
            }else if ([quesType isEqualToString:@"Question_M_Choice.ascx"]){//多选
                QuesTypeViewController *vc = [controllerArray objectAtIndex:quesNum];
                userAnswer = vc.answerUser;
                
            }else if ([quesType isEqualToString:@"Question_Checking.ascx"]){//判断
                QuesTypeViewController *vc = [controllerArray objectAtIndex:quesNum];
                userAnswer = vc.answerUser;
                
            }else if ([quesType isEqualToString:@"Question_Fill.ascx"]){//填空
                FillBlankViewController *vc = [controllerArray objectAtIndex:quesNum];
                userAnswer = vc.answerUser;
                
            }else if ([quesType isEqualToString:@"Question_Answer.ascx"]){//简答
                FillBlankViewController *vc = [controllerArray objectAtIndex:quesNum];
                userAnswer = vc.answerUser;
            }else{
                NSLog(@"ERROR");
                
            }
            
            if (userAnswer==NULL||userAnswer.length==0) {//未答
                [isDoneArr addObject:@0];
            }else{
                [isDoneArr addObject:@1];
            }
            
            quesNum++;
        }
    }else if (doneOrMark == 1){//标记
        for(ExamQuestionModel *quesModel in [self createModelData:_questionListsArr]) {
//            long typeId = quesModel.type_id;;
            BOOL userMark;
            NSString *quesType = quesModel.ModuleUrl;
            if ([quesType isEqualToString:@"Question_S_Choice.ascx"]) {//单选
                QuesTypeViewController *vc = [controllerArray objectAtIndex:quesNum];
                userMark = vc.isMarkQuestion;
                
            }else if ([quesType isEqualToString:@"Question_M_Choice.ascx"]){//多选
                QuesTypeViewController *vc = [controllerArray objectAtIndex:quesNum];
                userMark = vc.isMarkQuestion;
                
            }else if ([quesType isEqualToString:@"Question_Checking.ascx"]){//判断
                QuesTypeViewController *vc = [controllerArray objectAtIndex:quesNum];
                userMark = vc.isMarkQuestion;
                
            }else if ([quesType isEqualToString:@"Question_Fill.ascx"]){//填空
                FillBlankViewController *vc = [controllerArray objectAtIndex:quesNum];
                userMark = vc.isMarkQuestion;
                
            }else if ([quesType isEqualToString:@"Question_Answer.ascx"]){//简答
                FillBlankViewController *vc = [controllerArray objectAtIndex:quesNum];
                userMark = vc.isMarkQuestion;
            }else{
                NSLog(@"ERROR");
                
            }
            
            if (!userMark) {//未答
                [isDoneArr addObject:@0];
            }else{
                [isDoneArr addObject:@1];
            }
            
            quesNum++;
        }
        
        
    }
    
    
    
    return isDoneArr;
    
}

#pragma mark 在错题收藏中获取用户做题情况列表(错题或收藏)questionListsArr
-(NSMutableArray *)getUserErrorsQuestionDone{
    int quesNum = 0;
    NSMutableArray *isDoneArr =  [[NSMutableArray alloc] init];

    for(ErrorQuestionModel *quesModel in [self createErrorModelData:_questionListsArr]) {
        long typeId = quesModel.err_type_id;
        NSLog(@"typeId:%ld",typeId);
        NSString *userAnswer;
        
        if (typeId==1) {//单选
            QuesTypeViewController *vc = [controllerArray objectAtIndex:quesNum];
            userAnswer = vc.answerUser;
            
        }else if (typeId==2){//多选
            QuesTypeViewController *vc = [controllerArray objectAtIndex:quesNum];
            userAnswer = vc.answerUser;
            
        }else if (typeId==3){//判断
            QuesTypeViewController *vc = [controllerArray objectAtIndex:quesNum];
            userAnswer = vc.answerUser;
            
        }else if (typeId==4){//填空
            FillBlankViewController *vc = [controllerArray objectAtIndex:quesNum];
            userAnswer = vc.answerUser;
            
        }else if (typeId==5||typeId==26||typeId==37){//简答
            FillBlankViewController *vc = [controllerArray objectAtIndex:quesNum];
            userAnswer = vc.answerUser;
        }else{
            NSLog(@"ERROR");
            
        }
        
        if (userAnswer==NULL||userAnswer.length==0) {//未答
            [isDoneArr addObject:@0];
        }else{
            [isDoneArr addObject:@1];
        }
        
        quesNum++;
    }

    return isDoneArr;
}


//点击交卷按钮，弹出提醒
-(void)upExamPage{
    //    [alert show];
    [JCAlertView showTwoButtonsWithTitle:@"温馨提示" Message:@"是否确定交卷？" ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"取消" Click:^{
    } ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:@"确定" Click:^{
        [self getQuesAnswerInfo];
        [self makePaperData];
        [self submitLoadExam];//把答题情况转化为字符串
        [timer invalidate];
        [self.timerExample pause];
    }];
    
}
//提交试卷
-(void)getQuesAnswerInfo{
    examResult = [[NSMutableArray alloc]init];
    
    trueNumber = 0;//答对个数
    erorNumber = 0;//答错个数
    nodo       = 0;//未答个数
    // 判断用户是否答题正确
    int i=0;
    
    for (ExamQuestionModel *quesModel in [self createModelData:_questionListsArr]) {
        long typeId =quesModel.type_id;
//        NSString *answerTrue = [quesModel.ques_answer stringByReplacingOccurrencesOfString:@"," withString:@""];
        NSString *answerTrue =quesModel.ques_answer;
        NSString *userAnswer;
        NSString *adminAnswer;
        NSString *userPoint;
        NSString *state;
        NSString *KTypeId =@"0";
//        NSString * moduleType = quesModel.ModuleUrl;
        //[moduleType isEqualToString:@"Question_S_Choice.ascx"]||[moduleType isEqualToString:@"Question_M_Choice.ascx"]||[moduleType isEqualToString:@"Question_Checking.ascx"]
        if (typeId - 1 <3) {
            QuesTypeViewController *vc = [controllerArray objectAtIndex:i];
            userAnswer = vc.answerUser;
            
            if (userAnswer==NULL||userAnswer.length==0) {//未答
                [examResult addObject:@"未答"];
                
                //    1代表收藏 ，0代表取消收藏     01代表错题  00代表删除错题
                //把用户未做的题目情况写入数据库
                
                
                userAnswer = @" ";
                adminAnswer = @"错误";
                userPoint = @"0";
                state = @"0";
                
                nodo++;
                //把用户做错的题目情况写入数据库
//                [self insertDatatableName:TABLEERROR :quesModel.ques_id :quesModel.type_id :quesModel.ques_title :quesModel.ques_body :quesModel.ques_answer :quesModel.ques_mark :@"01":_PlanName:userAnswer:quesModel.ModuleUrl];
            }else{
                if ([userAnswer isEqualToString:answerTrue]) {//正确
                    [examResult addObject:@"正确"];
                    adminAnswer = @"正确";
                    userPoint = quesModel.ques_point;
                    state = @"1";
                    examnum +=[userPoint floatValue];
                    trueNumber++;
                }else{//错误
                    [examResult addObject:@"错误"];
                    adminAnswer = @"错误";
                    userPoint = @"0";
                    state = @"2";
                    erorNumber++;
                    
                    //把用户做错的题目情况写入数据库
                    [self insertDatatableName:TABLEERROR :quesModel.ques_id :quesModel.type_id :quesModel.ques_title :quesModel.ques_body :quesModel.ques_answer :quesModel.ques_mark :@"01":_PlanName:userAnswer:quesModel.ModuleUrl];
                    
                    
                }
            }
            i++;//切换到下一个单选题
            NSString *answer = [userAnswer stringByReplacingOccurrencesOfString:@"," withString:@""];
            [self makeQuestionArrDataQID:[NSString stringWithFormat:@"%ld",quesModel.ques_id] userAnswer:answer quesType:quesModel.ModuleUrl];
            
        }else{
            FillBlankViewController *vc = [controllerArray objectAtIndex:i];
            userAnswer = vc.answerUser;
            
            if (userAnswer==NULL||userAnswer.length==0) {//未答
                [examResult addObject:@"未答"];
                
                //    1代表收藏 ，0代表取消收藏     01代表错题  00代表删除错题
                //把用户未做的题目情况写入数据库
                
                userAnswer = @" ";
                adminAnswer = @"错误";
                userPoint = @"0";
                state =@"0";
                nodo++;
                //把用户做错的题目情况写入数据库
//                [self insertDatatableName:TABLEERROR :quesModel.ques_id :quesModel.type_id :quesModel.ques_title :quesModel.ques_body :quesModel.ques_answer :quesModel.ques_mark :@"01":_PlanName:userAnswer:quesModel.ModuleUrl];
            }else{
                if ([userAnswer isEqualToString:answerTrue]) {//正确
                    [examResult addObject:@"正确"];
                    adminAnswer = @"正确";
                    userPoint = quesModel.ques_point;
                    examnum +=[userPoint floatValue];
                    state =@"1";
                    
                    trueNumber++;
                }else{//错误
                    [examResult addObject:@"错误"];
                    adminAnswer = @"错误";
                    userPoint = @"0";
                    erorNumber++;
                    state =@"2";
                    
                    //把用户做错的题目情况写入数据库
                    [self insertDatatableName:TABLEERROR :quesModel.ques_id :quesModel.type_id :quesModel.ques_title :quesModel.ques_body :quesModel.ques_answer :quesModel.ques_mark :@"01":_PlanName:userAnswer:quesModel.ModuleUrl];
                    
                }
            }
            
            i++;//切换到下一个选题
            
            
            [self makeQuestionArrDataQID:[NSString stringWithFormat:@"%ld",quesModel.ques_id] userAnswer:userAnswer quesType:quesModel.ModuleUrl];
            
        }
        
    }
    _gradeInfoModel.paperTrueNum = trueNumber;
    _gradeInfoModel.paperFalseNum = erorNumber;
    _gradeInfoModel.paperUndoNum = nodo;
    _gradeInfoModel.paperGrade = examnum;
    
    _gradeInfoModel.paperIsunAnswer = _paperInfo.paperIsunAnswer;
    _gradeInfoModel.paperIsunShowpoint =_paperInfo.paperIsunShowpoint;
    
    _gradeInfoModel.paperPlanPassPoint = _paperInfo.paperPlanPassPoint;
    _gradeInfoModel.paperPlanResultDate =_paperInfo.paperPlanResultDate;
    //获取考试所用时间
    _gradeInfoModel.paperTime = [self dateTimeDifferenceWithStartTime:_examBeginTime];
    
}

-(NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [NSDate date];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (24 * 3600)%3600;
    int day = (int)value / (24 * 3600);
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"%d天%d小时%d分%d秒",day,house,minute,second];
    }else if (day==0 && house != 0) {
        str = [NSString stringWithFormat:@"%d小时%d分%d秒",house,minute,second];
    }else if (day== 0 && house== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"%d分%d秒",minute,second];
    }else{
        str = [NSString stringWithFormat:@"%d秒",second];
    }
    return str;
}


#pragma mark - submitPaperDetail Action
//制作用来向服务器提交试卷数据
- (void)makePaperData{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:@"userName"];
    NSString *stuCnname = [defaults objectForKey:@"stuCnname"];
    NSString *examkey = [defaults objectForKey:@"examKey"];
    
    NSMutableDictionary * paperDataDic = [[NSMutableDictionary alloc]init];
    [paperDataDic setObject:@(_paperInfo.paperPlanId) forKey:@"ExamID"];
    [paperDataDic setObject:_paperInfo.paperPlanName  forKey:@"ExamName"];
    [paperDataDic setObject:@(_paperInfo.paperPlanTime) forKey:@"Time"];
    [paperDataDic setObject:_paperInfo.paperUserID forKey:@"UserID"];
    [paperDataDic setObject:userName forKey:@"UserName"];
    [paperDataDic setObject:stuCnname forKey:@"UserCNName"];
    [paperDataDic setObject:@(_paperInfo.paperPlanPoint) forKey:@"ExamPoint"];
    [paperDataDic setObject:@(_paperInfo.paperPlanPassPoint) forKey:@"ExamPassPoint"];
    [paperDataDic setObject:@(_paperInfo.paperPId) forKey:@"PaperID"];
    [paperDataDic setObject:_paperInfo.paperWKey forKey:@"PaperWay"];
    [paperDataDic setObject:examkey forKey:@"examKey"];
    [paperDataDic setObject:@(nodo) forKey:@"examNoAnswer"];
    
    [paperDataDic setObject:@(trueNumber) forKey:@"examTrue"];
    [paperDataDic setObject:@(erorNumber) forKey:@"examError"];
    [paperDataDic setObject:_examBeginTime forKey:@"canyutime"];
    
    
    paperData = [NSJSONSerialization dataWithJSONObject:paperDataDic options:NSJSONWritingPrettyPrinted error:nil];
    
}
//制作所有试题的作答的详细信息
-(void)makeQuestionArrDataQID:(NSString *)QId userAnswer:(NSString *)answer quesType:(NSString *)type{
    
    NSMutableDictionary *questionDataDic = [[NSMutableDictionary alloc]init];
    [questionDataDic setObject:QId forKey:@"Q_ID"];
//    NSString *answerNew =[answer stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [questionDataDic setObject:answer forKey:@"Answer"];
    [questionDataDic setObject:type forKey:@"Type"];
    
    [paperArr addObject:questionDataDic];
    
}
//制作向服务器提交的数据请求地址
-(NSString *)getPaperInfoStr{
    NSString * paperString = [[NSString alloc]initWithData:paperData encoding:NSUTF8StringEncoding];
    
    return paperString;
}
-(NSString *)getTmInfoStr{
//  试题的详细信息转化为DATA，传送到服务器
    NSData *questionData = [NSJSONSerialization dataWithJSONObject:paperArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *tmInfo = [[NSString alloc]initWithData:questionData encoding:NSUTF8StringEncoding];
    [paperArr removeAllObjects];
    
    return tmInfo;
}
-(void)submitLoadExam{
    NSString * paperString = [self getPaperInfoStr];
    NSString *tmInfo = [self getTmInfoStr];
    //上传试卷
    [self uploadPaperDetail:paperString inPaper:tmInfo];
}

#pragma mark - database Action
//持久化考试数据
- (void)createTable:(NSString *)tableName{
  
    if ([tableName isEqualToString:TABLEERROR]){//错题
        
        if ([db open]) {
            NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' INTEGER, '%@' INTEGER, '%@' TEXT,'%@' TEXT , '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT,'%@' TEXT,'%@' TEXT)",TABLEERROR,ID,userID,qId,qType,qTitle,qBody,qAnswer,qMark,qMode,qPlanName,userQAnswer,qModuleUrl];
            BOOL res = [db executeUpdate:sqlCreateTable];
            if (!res) {
                NSLog(@"error when creating db table");
            } else {
                NSLog(@"success to creating db table");
            }
            [db close];
            
        }else  if ([tableName isEqualToString:TABLECOLLECT]) {//收藏
            
            if ([db open]) {
                NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' INTEGER,'%@' TEXT '%@' INTEGER, '%@' TEXT , '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT,'%@' TEXT,'%@' TEXT)",TABLECOLLECT,ID,userID,qId,qType,qTitle,qBody,qAnswer,qMark,qMode,qPlanName,userQAnswer,qModuleUrl];
                
                BOOL res = [db executeUpdate:sqlCreateTable];
                if (!res) {
                    NSLog(@"error when creating db table");
                } else {
                    //                NSLog(@"success to creating db table");
                }
                [db close];
                
            }
            
        }
        
    }

}

/**
 *  查询用户错题是否在数据库中已经存在
 *
 */
-(BOOL)selectDataInDB:(NSString *)tableName withID:(long)qID{
    NSString * sql;
    sql = [NSString stringWithFormat:@"SELECT * FROM %@ where %@ = %ld Order By rowid  DESC",tableName,qId, qID];
    if ([db open]) {
        FMResultSet * resultSet = [db executeQuery:sql];
        @try {
            if ([resultSet next]) {
                return NO;//存在错题
            }else{
                return YES;//数据库不存在这题，可以添加
            }
        } @catch (NSException *exception) {
            @throw exception;
        } @finally {
            //            [db close];
        }
        
        
    }else{
        NSLog(@"数据库取值失败！");
        return NO;
    }
    
}


//         插入一个错题
-(void) insertDatatableName:(NSString *)tableName :(long) _qId :(long)_qType :(NSString *)_qTitle :(NSString *)_qBody :(NSString *)_qAnswer :(NSString *)_qMark :(NSString *)_qMode :(NSString *)_qPlanName :(NSString *)_userQAnswer :(NSString *)moduleUrl{
    
    if ([db open]) {
        if ([self selectDataInDB:tableName withID:_qId]) {
            NSString *insertSql1= [NSString stringWithFormat:
                                   @"INSERT INTO '%@' ('%@', '%@','%@', '%@','%@', '%@', '%@','%@','%@','%@','%@') VALUES ('%ld','%@', '%ld', '%@','%@', '%@', '%@','%@','%@','%@','%@')",tableName, qId,userID,qType, qTitle,qBody,qAnswer,qMark,qMode,qPlanName,userQAnswer,qModuleUrl,_qId,USERID, _qType, _qTitle,_qBody, _qAnswer, _qMark,_qMode,_qPlanName,_userQAnswer,moduleUrl];
            BOOL res = [db executeUpdate:insertSql1];
            if (!res) {
                NSLog(@"error when insert db table");
            } else {
                
            }
        }else{
            NSLog(@"改错题已经收藏过了！");
            
        }
        
        
        [db close];
        
    }
    
}


@end
