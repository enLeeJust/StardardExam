//
//  MyPracticesViewController.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/12.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "MyPracticesViewController.h"
#import "SZLSwitchView.h"
#import <AFHTTPSessionManager.h>
#import "WebServiceModel.h"
//for Test
//#import "NewsCell.h"
#import "MyPracticeCell.h"
#import "MyPracticeLogCell.h"
#import "ExamDetailViewController.h"
#import "myGradePlanModel.h"

#import "PaperBackLookViewController.h"//用于回看试卷
#import "SZLBaseWebViewController.h"//用于试卷回看
@interface MyPracticesViewController ()<UITableViewDataSource, UITableViewDelegate,SZLSwitchViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>{
    BOOL _ISOpen[200];
}

@property (strong,nonatomic) SZLSwitchView *switchView;

@property (strong,nonatomic) NSMutableArray *practiceListArr;
@property (strong,nonatomic) NSMutableArray *practiceLogListArr;
@property (nonatomic,assign) long selectWhichItem;

@end

@implementation MyPracticesViewController


#pragma mark -lazyLoading
-(UITableView*)myPracticeTbV{
    if (!_myPracticeTbV) {
        _myPracticeTbV = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myPracticeTbV.delegate = self;
        _myPracticeTbV.dataSource = self;
        _myPracticeTbV.emptyDataSetSource = self;
        _myPracticeTbV.emptyDataSetDelegate = self;
        _myPracticeTbV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myPracticeTbV.scrollEnabled = YES;

    }
    return _myPracticeTbV;
}

-(SZLSwitchView *)switchView{
    if (!_switchView) {
        _switchView = [[SZLSwitchView alloc] initWithFrame:CGRectZero items:@[@"练习列表",@"练习记录"]];
        _switchView.delegate = self;
    }
    [self.contentView addSubview:_switchView];
    return _switchView;

}
#pragma mark - init baseData
-(void)initBaseData{
    _selectWhichItem = 0;
    _paperInfo = [[PaperInfoModel alloc] init];
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBaseData];
    [self createNav];
    [self createMyPracticeTbV];
    
    //请求数据
    __weak MyPracticesViewController *wself = self;
    _myPracticeTbV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (wself.selectWhichItem == 0) {
            [wself getUnFinishExamInfo];
        }else{
            [wself getFinishExamLogInfo];
            
        }
    }];
    [self.myPracticeTbV.mj_header beginRefreshing];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc{
    DLog(@"SUCCESS");

}
#pragma mark -创建导航栏
-(void)createNav{
    
    self.navigationTitle = @"我的练习";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"ic_register_back"] forState:UIControlStateNormal];
    [self.navigationLeftButton addTarget:self action:@selector(buttonBackToLastView) forControlEvents:UIControlEventTouchUpInside];
}
-(void)buttonBackToLastView{
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark -创建公告信息列表（tableView）
- (void)createMyPracticeTbV{
    
    [self.contentView addSubview:_switchView];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.height.equalTo(@40);
    }];
    [self.contentView addSubview:self.myPracticeTbV];
    [self.myPracticeTbV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_switchView.mas_bottom).with.offset(5);
        make.leading.trailing.bottom.equalTo(@0);
        
    }];
}
#pragma mark - 获取网络数据
-(void)getUnFinishExamInfo{
    NSDictionary *prama = @{
                            @"servletname":@"ExamPractice",
                            @"type":@(2),
                            };
    
    [self sendRequestForGetExanInfo:prama isFinished:NO];
}
-(void)getFinishExamLogInfo{
    
    if (kNetworkNotReachability) {
        [self.view makeToast:kError_Network_NotReachable];
        return;
    }
    
    __weak MyPracticesViewController * wself = self;
    self.switchView.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __block ApiRequest *request = [SZLServerHelper getMyGradeInfoRequest:2 callback:^(NSInteger errCode, ApiResponse *response, BOOL success) {
            [wself.requestArr removeObject:request];
            [wself.myPracticeTbV.mj_header endRefreshing];
            wself.switchView.userInteractionEnabled = YES;
            if (success) {
                if(!wself.practiceLogListArr){
                    wself.practiceLogListArr = [[NSMutableArray alloc]init];
                    
                }
                [wself.practiceLogListArr removeAllObjects];
                
                NSDictionary *data = response.data;
                
                NSMutableArray *planList = [data objectForKey:@"courseList"];
                for (NSDictionary* examlogDetail in planList) {
                    myGradePlanModel *gradePlanModel = [[myGradePlanModel alloc] initWithDictionary:examlogDetail];
                    
                    [wself.practiceLogListArr addObject:gradePlanModel];
                }
                [wself.myPracticeTbV reloadData];
            }else{
                [wself.view makeToast:response.errDesc];
            }
        }];
        [wself.requestArr addObject:request];
    });
}
/**
 *  AFNetWorking  请求数据
 *
 *  @return nil
 */
-(void)sendRequestForGetExanInfo:(NSDictionary *)prama isFinished:(BOOL)isfinished{
    //  检测用户是否联网
    
    if (kNetworkNotReachability) {
        [self.view makeToast:kError_Network_NotReachable];
        return;
    }
    __weak MyPracticesViewController * wself = self;
    self.switchView.userInteractionEnabled = NO;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __block ApiRequest *request = [SZLServerHelper normalRequest:prama callback:^(NSInteger errCode, ApiResponse *response, BOOL success) {
            [wself.requestArr removeObject:request];
            [wself.myPracticeTbV.mj_header endRefreshing];
            wself.switchView.userInteractionEnabled = YES;
            if (success) {
                if (!wself.practiceListArr) {
                    wself.practiceListArr = [[NSMutableArray alloc]init];//我的练习
                    
                }
                [wself.practiceListArr removeAllObjects];
                NSMutableSet * typeName = [[NSMutableSet alloc]init];//课程的类别，不能重复，set集合不会有重复值
                NSDictionary *data = response.data;
                
                NSMutableArray *totalPracticesList = [data objectForKey:@"dtExamInfo"];
                
                
                for(NSMutableDictionary *member in totalPracticesList) {
                    [typeName addObject:[member objectForKey:@"TypeName"]];
                }
                
                for (NSString *string in typeName)
                {
                    NSMutableArray *dataInfoArr = [[NSMutableArray alloc]init];
                    for (NSMutableDictionary *member in totalPracticesList) {//一个section下记录有多少门课程
                        if ([[member objectForKey:@"TypeName"] isEqualToString:string]) {
                            RADataObject *child = [RADataObject dataObjectWithName
                                                   : member
                                                   : nil
                                                   children:nil];
                            
                            
                            [dataInfoArr addObject:child];
                        }
                    }
                    
                    NSMutableDictionary *dictt = [[NSMutableDictionary alloc]init];
                    [dictt setObject:string forKey:@"string"];
                    RADataObject *group = [RADataObject dataObjectWithName:dictt :nil children:dataInfoArr];
                    [wself.practiceListArr addObject:group];
                }
                [wself.myPracticeTbV reloadData];
                
            }else{
                [wself.view makeToast:response.errDesc];
            }
        }];
        [wself.requestArr addObject:request];
    });
    
    
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text=@"";
   
    if (self.selectWhichItem == 0&&self.practiceListArr) {
        if (self.practiceListArr.count == 0) {
            text = @"暂无练习试卷";
        }else{
            text = @"";
        }
    }else if (self.selectWhichItem == 1&&self.practiceLogListArr){
        if (self.practiceLogListArr.count == 0) {
            text = @"暂无练习记录试卷";
        }else{
            text = @"";
        }
    
    }else{
        text = @"";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor grayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
    
    
}


#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

-(BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return YES;
    
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.selectWhichItem == 0){
        return self.practiceListArr.count;
    }else{
        return self.practiceLogListArr.count;
    }
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.selectWhichItem == 0) {
        if (_ISOpen[section]) {
            return [((RADataObject *)self.practiceListArr[section]).children count];
        }
        return 0;
    }else{
        if (_ISOpen[section]) {
            myGradePlanModel *examLogModel = self.practiceLogListArr[section];
            return examLogModel.examlog.count;
        }
        return 0;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static    NSString * cellString = @"MyPracticeCell";
    static    NSString * myPracticeStr = @"MyPracticeLogCell";
    if (self.selectWhichItem == 0) {
        MyPracticeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
        if (!cell) {
            NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"MyPracticeCell" owner:self options:nil];
            cell = [nibViews objectAtIndex:0];
        }
        RADataObject * radataObject =((RADataObject *)self.practiceListArr[indexPath.section]).children[indexPath.row];
        NSString* planName = [radataObject.member objectForKey:@"PlanName"];
        cell.myPrcticeCourseType.text = [NSString stringWithFormat:@"%ld、%@",indexPath.row+1,planName];
        cell.myPracticeIV.image = [UIImage imageNamed:@"ic_practice"];
        
        return cell;
    }else{
        MyPracticeLogCell *cell = [tableView dequeueReusableCellWithIdentifier:myPracticeStr];
        myGradePlanModel *examLogModel = self.practiceLogListArr[indexPath.section];
        MyGradeExamLogModel *examDetailModel = examLogModel.examlog[indexPath.row];
        if (!cell) {
            NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"MyPracticeLogCell" owner:self options:nil];
            cell = [nibViews objectAtIndex:0];
        }
        
        
        cell.joinTimeLabel.text = [NSString stringWithFormat:@"参加时间:%@",examDetailModel.exam_begin_time];
        NSString *time = [self dateTimeDifferenceWithStartTime:examDetailModel.exam_begin_time endTime:examDetailModel.exam_end_time];
        
        cell.useTimeLabel.text = time;
        cell.practiceScoreLabel.text = [NSString stringWithFormat:@"得分:%0.1f",examDetailModel.exam_point];
        cell.practiceRightLabel.text = [NSString stringWithFormat:@"正确:%ld",examDetailModel.q_answer_correct];;
        cell.practiceWrongLabel.text = [NSString stringWithFormat:@"错误:%ld",examDetailModel.q_answer_error];
        cell.practiceUndoLabel.text = [NSString stringWithFormat:@"未做:%ld",examDetailModel.q_answer_undo];
        return cell;
        
    }
    
    
    
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectWhichItem == 0) {
        return 70;
    }
    return 115;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
//组头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView;
    
    if (self.selectWhichItem == 0) {//练习列表
        NSString * sectionTitle = [((RADataObject *)self.practiceListArr[section]).member objectForKey:@"string"];
        NSString *practiceTotleNum = [NSString stringWithFormat:@"%ld",[((RADataObject *)_practiceListArr[section]).children count]];
        
        sectionView = [self createSectionView:sectionTitle withTotal:practiceTotleNum in:section];

    }else if (self.selectWhichItem == 1){
        myGradePlanModel *examLogModel = self.practiceLogListArr[section];
        NSString *planName = examLogModel.exam_plan_name;
        NSString *examTypeName = examLogModel.exam_type_Name;
        NSString *topPoint = [NSString stringWithFormat:@"%0.1f",examLogModel.exam_top_point];
        long paperState = examLogModel.exam_state;
        
        sectionView = [self createSectionView:planName inCourse:examTypeName withTopGrade:topPoint examState:paperState in:section];
        
        
    }else{
        return nil;
    }
    
    return sectionView;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
    return footerView;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RADataObject * radataObject;
    if(self.selectWhichItem == 1){
        myGradePlanModel *examLogModel = self.practiceLogListArr[indexPath.section];
        MyGradeExamLogModel *examDetailModel = examLogModel.examlog[indexPath.row];
        
        
        BOOL isUnshowPaper = examDetailModel.paper_unshow;
        
        if (!isUnshowPaper) {
            NSString * messageStr = @"此试卷不允许回看!";
            [JCAlertView showOneButtonWithTitle:@"温馨提示" Message:messageStr ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"确定" Click:^{
                
                
            }];
            
        }else{
//            SZLBaseWebViewController * webView = [[SZLBaseWebViewController alloc]initWithUrl:[NSURL URLWithString:examDetailModel.paper_url]];
//            
//            [self.navigationController pushViewController:webView animated:YES];
            PaperBackLookViewController *detailView = [[PaperBackLookViewController alloc] init];
            
            detailView.paperUrl = examDetailModel.paper_url;
            
            [self.navigationController pushViewController:detailView animated:YES];
            
        }
        

    
    }else{
        radataObject =((RADataObject *)self.practiceListArr[indexPath.section]).children[indexPath.row];//一门课程
        _paperInfo = [[PaperInfoModel alloc] initWithDictionary:radataObject.member];
        
        if ([NSDate isBeyondNowWithDateString:_paperInfo.paperPlanDateEnd]) {
            
            [JCAlertView showOneButtonWithTitle:nil Message:@"试卷已经过期，请重新选择试卷！" ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:@"确定" Click:^{
                
            }];
            
            return;
        };
        __weak MyPracticesViewController *wself = self;

        NSString * messageStr = @"是否开始练习！";
        [JCAlertView showTwoButtonsWithTitle:@"温馨提示" Message:messageStr ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"取消" Click:^{
        } ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:@"开始" Click:^{
            [wself gotoExamStart];
        }];

    }
    
}

//参加考试的
- (void)gotoExamStart{
    ExamDetailViewController *control = [[ExamDetailViewController alloc] init];
    control.paperInfo = _paperInfo;
    
    control.PId = [NSString stringWithFormat:@"%ld",_paperInfo.paperPId];
    control.PlanId = [NSString stringWithFormat:@"%ld",_paperInfo.paperPlanId];
    long time = 60 * _paperInfo.paperPlanTime;
    control.examTime = [NSString stringWithFormat:@"%ld",time];
    control.PlanName = _paperInfo.paperPlanName;
    control.PlanPoint = [NSString stringWithFormat:@"%f",_paperInfo.paperPlanPoint] ;
    control.PlanPassPoint = [NSString stringWithFormat:@"%f",_paperInfo.paperPlanPassPoint] ;
    control.PaperWay = _paperInfo.paperWKey;
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLocale* local =[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dateformatter setLocale: local];
    
    NSDate *  nowDate=[NSDate date];
    control.examBeginTime = [dateformatter stringFromDate:nowDate];
    control.delegate = self;
    
    if ([_paperInfo.paperIsunAnswer isEqualToString:@"不显示"]) {
        control.isShowAnswer = @"false";
    }else if ([_paperInfo.paperIsunAnswer isEqualToString:@"显示"]){
        control.isShowAnswer = @"true";
    
    }
    
    
    control.examOrPractice = 2;
//    control.isShowTime = @"false";
    
    [self.navigationController pushViewController:control animated:YES];
    
}


#pragma mark - SZLSwitchViewDelegate
- (void)switchView:(SZLSwitchView *)switchView hasChangedIndex:(NSInteger)index{
    _selectWhichItem = index;
    
    for (int i = 0;i<200;i++) {
        _ISOpen[i] = false;
//        if (i == 0) {
//            _ISOpen[i] = true;
//        }
    }
    __weak MyPracticesViewController *wself = self;
    if(self.selectWhichItem == 0){
        if(self.practiceListArr){
//            [self.myPracticeTbV reloadData];
            [UIView transitionWithView: self.myPracticeTbV
                              duration: 0.3f
                               options: UIViewAnimationOptionTransitionCrossDissolve
                            animations: ^(void) {
                                [wself.myPracticeTbV reloadData];
                            }completion: ^(BOOL isFinished){
                                
                            }];
            return;
        }
        
        
    }else{
        if (self.practiceLogListArr) {
//            [self.myPracticeTbV reloadData];
            
            [UIView transitionWithView: self.myPracticeTbV
                              duration: 0.3f
                               options: UIViewAnimationOptionTransitionCrossDissolve
                            animations: ^(void) {
                                [wself.myPracticeTbV reloadData];
                            }completion: ^(BOOL isFinished){
                                
                            }];
            
            
            return;
        }
        
        
    }
    
    [self.myPracticeTbV reloadData];
    [self.myPracticeTbV.mj_header beginRefreshing];
    
}

#pragma mark private function
//单击section实图
- (void)tapView:(UIButton *)sender{
    NSInteger  sectionNum = sender.tag-100;
    _ISOpen[sectionNum] = !_ISOpen[sectionNum];
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:sectionNum];
    [_myPracticeTbV reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    
}

-(UIView *)createSectionView:(NSString *)courseName withTotal:(NSString *)examNum in:(NSInteger)section{
    UIView * sectionView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 70)];
    sectionView.backgroundColor = [UIColor whiteColor];
    UIImageView *leftLine = [[UIImageView alloc] initWithFrame:CGRectMake(12, 25, 2, 20)];
    leftLine.backgroundColor = MyBlue;
    [sectionView addSubview:leftLine];
    
    
//    NSString *titleLabelStr = [NSString stringWithFormat:@"%@ (共 %@ 门)",courseName,examNum];//分类
//    UILabel *examTypeLabel = [self createAdjustWidtLabel:titleLabelStr loactionX:20 loactionY:25];
//    examTypeLabel.text = titleLabelStr;
//    [sectionView addSubview:examTypeLabel];
//    examTypeLabel.font = [UIFont boldSystemFontOfSize:16];
//    examTypeLabel.textColor = MyTextColor;
    NSString *titleLabelStr = [NSString stringWithFormat:@"【%@】",courseName];//分类
    UILabel *examTypeLabel = [[UILabel alloc]init];/*[self createAdjustWidtLabel:titleLabelStr loactionX:26 loactionY:25]*/;
    examTypeLabel.text = titleLabelStr;
    [sectionView addSubview:examTypeLabel];
    examTypeLabel.font = [UIFont systemFontOfSize:16];
    examTypeLabel.textColor = MyTextColor;
    [examTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(leftLine.trailing).with.offset(@3);
        make.centerY.equalTo(leftLine.centerY);
        make.width.lessThanOrEqualTo(WIDTH-26-70-40);
    }];
    
    
    UIButton *openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openBtn.frame = CGRectMake(WIDTH - 40, 20, 70, 30);
    openBtn.backgroundColor = [UIColor clearColor];
    
    if (_ISOpen[section]) {
        [openBtn setTitle:@"收起" forState:UIControlStateNormal];
        [openBtn setImage:[UIImage imageNamed:@"ic_myExam_close"] forState:UIControlStateNormal];
        
        
    }else{
        [openBtn setTitle:@"展开" forState:UIControlStateNormal];//设置button的title
        [openBtn setImage:[UIImage imageNamed:@"ic_myExam_open"] forState:UIControlStateNormal];
    }
    openBtn.titleLabel.font = [UIFont systemFontOfSize:15];//title字体大小
    openBtn.titleLabel.textAlignment = NSTextAlignmentLeft;//设置title的字体居左
    [openBtn setTitleColor:MyBlue forState:UIControlStateNormal];//设置title在一般情况下为白色字体
    [openBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
    openBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -openBtn.titleLabel.bounds.size.width-100, 0, 0);//设
    
    [sectionView addSubview:openBtn];
    
    
    UILabel * numLabel = [[UILabel alloc]init];
    numLabel.textColor = [UIColor grayColor];
    numLabel.text = [NSString stringWithFormat:@"(共%@门)", examNum];
    numLabel.font = [UIFont systemFontOfSize:14.0f];
    [sectionView addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(examTypeLabel.centerY);
        make.leading.equalTo(examTypeLabel.trailing).with.offset(-6);
    }];

    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = sectionView.frame;
    [button addTarget:self action:@selector(tapView:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    button.tag = 100+section;
    
    [sectionView addSubview:button];
    
    
    return sectionView;
    
}
-(UIView *)createSectionView:(NSString *)knowledgeName inCourse:(NSString *)courseName withTopGrade:(NSString*)grade examState:(long)paperState in:(NSInteger)section{
    UIView* sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 70)];
    sectionView.backgroundColor = [UIColor whiteColor];
    UIImageView *leftLine = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 2, 20)];
    leftLine.backgroundColor = MyBlue;
    [sectionView addSubview:leftLine];
    
//    UILabel *knowledgeNameLabel = [self createAdjustWidtLabel:knowledgeName loactionX:17 loactionY:12];
    UILabel *knowledgeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 12, WIDTH-28-12, 20)];
    knowledgeNameLabel.text = knowledgeName;
    [sectionView addSubview:knowledgeNameLabel];
    knowledgeNameLabel.font = [UIFont boldSystemFontOfSize:16];
    knowledgeNameLabel.textColor = MyTextColor;
    
//    UILabel *examTypeLabel = [self createAdjustWidtLabel:[NSString stringWithFormat:@"考试分类:%@",courseName] loactionX:12 loactionY:40];
     UILabel *examTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(18,40 , WIDTH-18-82 - 110, 20)];
    examTypeLabel.text = [NSString stringWithFormat:@"考试分类:%@",courseName];
    examTypeLabel.textColor = [UIColor lightGrayColor];
    examTypeLabel.font = [UIFont boldSystemFontOfSize:14];
    
    [sectionView addSubview:examTypeLabel];
    
//    UILabel *topGradeLabel = [self createAdjustWidtLabel:[NSString stringWithFormat:@"最好成绩:%@",grade] loactionX:(12+examTypeLabel.v_size.width+20)  loactionY:40];
    UILabel *topGradeLabel = [[UILabel alloc]initWithFrame:CGRectMake(18+WIDTH-18-82 - 105,40 ,110, 20)];
    topGradeLabel.text = [NSString stringWithFormat:@"最好成绩:%@",grade];
    topGradeLabel.textColor = [UIColor lightGrayColor];
    topGradeLabel.font = [UIFont boldSystemFontOfSize:14];
    [sectionView addSubview:topGradeLabel];
    
    
    UIButton *openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openBtn.frame = CGRectMake(WIDTH - 40, 35, 70, 30);
    openBtn.backgroundColor = [UIColor clearColor];
    
    if (_ISOpen[section]) {
        [openBtn setTitle:@"收起" forState:UIControlStateNormal];
        [openBtn setImage:[UIImage imageNamed:@"ic_open"] forState:UIControlStateNormal];
        
        
    }else{
        [openBtn setTitle:@"展开" forState:UIControlStateNormal];//设置button的title
        [openBtn setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
    }
    openBtn.titleLabel.font = [UIFont systemFontOfSize:14];//title字体大小
    openBtn.titleLabel.textAlignment = NSTextAlignmentLeft;//设置title的字体居左
    [openBtn setTitleColor:MyBlue forState:UIControlStateNormal];//设置title在一般情况下为白色字体
    [openBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];//设置title在button被选中情况下为灰色字体
    openBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -openBtn.titleLabel.bounds.size.width-100, 0, 0);//设
    
    [sectionView addSubview:openBtn];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = sectionView.frame;
    [button addTarget:self action:@selector(tapView:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    button.tag = 100+section;
    
    [sectionView addSubview:button];
    
    return sectionView;
    
}

-(UILabel *)createAdjustWidtLabel:(NSString *)title loactionX:(CGFloat)x loactionY:(CGFloat)y{
    UILabel *label = [UILabel new];
    [label setNumberOfLines:0];
    //    label.text = title;knowledgeNameLabel
    UIFont *font = [UIFont boldSystemFontOfSize:17];
    CGSize size = CGSizeMake(320,2000);
    CGSize labelsize = [title sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [label setFrame:CGRectMake(x, y, labelsize.width+1, 20)];
    
    return label;
    
}


#pragma mark - 计算时间差

-(NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (24 * 3600)%3600;
    int day = (int)value / (24 * 3600);
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"用时：%d天%d小时%d分%d秒",day,house,minute,second];
    }else if (day==0 && house != 0) {
        str = [NSString stringWithFormat:@"用时：%d小时%d分%d秒",house,minute,second];
    }else if (day== 0 && house== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"用时：%d分%d秒",minute,second];
    }else{
        str = [NSString stringWithFormat:@"用时：%d秒",second];
    }
    return str;
}

@end
