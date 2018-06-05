//
//  MyExamsViewController.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/12.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "MyExamsViewController.h"
#import "SZLSwitchView.h"
#import "MyExamCell.h"
#import "ExamDetailViewController.h"
#import <AFHTTPSessionManager.h>
#import "WebServiceModel.h"
#import "PaperInfoModel.h"

#import "checkOpen.h"
@interface MyExamsViewController ()<UITableViewDataSource, UITableViewDelegate,SZLSwitchViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic,strong)SZLSwitchView *switchView;
@property(nonatomic,strong)PaperInfoModel *paperInfo;

@property(nonatomic,strong)NSMutableArray * totalPlansList;//获得数据的所有
@property(nonatomic,strong)NSMutableArray * courseListArr;//课程arr
@property(nonatomic,strong)NSMutableArray * courseListFinishedArr;//课程arr

@property (nonatomic,assign) NSInteger remain_time;//变更后的剩余次数

@property (nonatomic,strong) NSMutableArray *ISOpen;
@property (nonatomic,strong) NSIndexPath *myIndexPath;//

@property (nonatomic,assign) long whichTable;

@end

@implementation MyExamsViewController

#pragma mark -lazyLoading

-(UITableView*)noticeListTbV{
    if (!_noticeListTbV) {
        _noticeListTbV = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _noticeListTbV.delegate = self;
        _noticeListTbV.dataSource = self;
        _noticeListTbV.emptyDataSetSource = self;
        _noticeListTbV.emptyDataSetDelegate = self;
        _noticeListTbV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _noticeListTbV.scrollEnabled = YES;
        _noticeListTbV.backgroundColor = WhiteColor;
     
    }
    return _noticeListTbV;
}

-(SZLSwitchView *)switchView{
    if (!_switchView) {
        _switchView = [[SZLSwitchView alloc] initWithFrame:CGRectZero items:@[@"未完成",@"已完成"]];
        _switchView.delegate = self;
    }
    [self.contentView addSubview:_switchView];
    return _switchView;
    
}
#pragma mark - init baseData
-(void)initBaseData{
     _paperInfo = [[PaperInfoModel alloc] init];
    _resultData = [[NSMutableData alloc]init];
    _ISOpen = [[NSMutableArray alloc] init];
    for (int i =0; i<200; i++) {
        checkOpen *check = [[checkOpen alloc] init];
        check.isOpen = false;
        
        [_ISOpen addObject:check];
    }
    _whichTable = 0;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBaseData];
    [self createNav];
    [self createNoticeListTV];
    
    __weak MyExamsViewController *wself = self;
    self.noticeListTbV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //刷新
        if (wself.whichTable == 0) {
            [wself getUnFinishExamInfo];
        }else if (wself.whichTable == 1){
            [wself getFinishExamLogInfo];
            
        }
        
    }];
    
    [self.noticeListTbV.mj_header beginRefreshing];
}


-(void)viewWillAppear:(BOOL)animated{
//    __weak MyExamsViewController *wself = self;
//    self.noticeListTbV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        //刷新
//        if (wself.whichTable == 0) {
//            [wself getUnFinishExamInfo];
//        }else if (wself.whichTable == 1){
//            [wself getFinishExamLogInfo];
//            
//        }
//        
//    }];
//    
//    [self.noticeListTbV.mj_header beginRefreshing];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -创建导航栏
-(void)createNav{
    
    self.navigationTitle = @"我的考试";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"ic_register_back"] forState:UIControlStateNormal];
    [self.navigationLeftButton addTarget:self action:@selector(buttonBackToLastView) forControlEvents:UIControlEventTouchUpInside];
}


-(void)buttonBackToLastView{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark -创建公告信息列表（tableView）
- (void)createNoticeListTV{
    [self.contentView addSubview:_switchView];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@40);
    }];
    [self.contentView addSubview:self.noticeListTbV];
    [self.noticeListTbV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_switchView.mas_bottom).with.offset(5);
        make.leading.trailing.bottom.equalTo(@0);
        
    }];

}


#pragma mark - 获取网络数据
-(void)getUnFinishExamInfo{
    if (kNetworkNotReachability) {
        [self.view makeToast:kError_Network_NotReachable];
        return;
    }
    self.switchView.userInteractionEnabled = NO;
    __weak MyExamsViewController * wself = self;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __block ApiRequest* request = [SZLServerHelper getUnFinishedExamsWithCallback:^(NSInteger errCode, ApiResponse *response, BOOL success) {
            [wself.requestArr removeObject:request];
            [wself.noticeListTbV.mj_header endRefreshing];
            wself.switchView.userInteractionEnabled = YES;
            if (success) {
                
                if (!wself.courseListArr) {
                    wself.courseListArr = [[NSMutableArray alloc]init];//未完成数据
                }
                [wself.courseListArr removeAllObjects];
                NSMutableSet * typeName = [[NSMutableSet alloc]init];//课程的类别，不能重复，set集合不会有重复值
                NSDictionary *data = response.data;
                
                if (!wself.totalPlansList) {
                    wself.totalPlansList = [[NSMutableArray alloc]init];//所有的数据
                }
                [wself.totalPlansList removeAllObjects];
                
                wself.totalPlansList = [data objectForKey:@"dtExamInfo"];
                
                for(NSMutableDictionary *member in wself.totalPlansList) {
                    [typeName addObject:[member objectForKey:@"TypeName"]];
                }
                
                for (NSString *string in typeName)
                {
                    NSMutableArray *dataInfoArr = [[NSMutableArray alloc]init];
                    for (NSMutableDictionary *member in wself.totalPlansList) {//一个section下记录有多少门课程
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
                    
                    [wself.courseListArr addObject:group];
                }
                [wself.noticeListTbV reloadData];
            }else{
                [wself.view makeToast:response.errDesc];
            }
            
        }];
        [wself.requestArr addObject:request];
    });
}
-(void)getFinishExamLogInfo{
    if (kNetworkNotReachability) {
        [self.view makeToast:kError_Network_NotReachable];
        return;
    }
    self.switchView.userInteractionEnabled = NO;
    __weak MyExamsViewController * wself = self;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __block ApiRequest* request = [SZLServerHelper getFinishedExamsWithCallback:^(NSInteger errCode, ApiResponse *response, BOOL success) {
            [wself.requestArr removeObject:request];
            [wself.noticeListTbV.mj_header endRefreshing];
            wself.switchView.userInteractionEnabled = YES;
            if (success) {
                if (!wself.courseListFinishedArr) {
                    wself.courseListFinishedArr = [[NSMutableArray alloc]init];//已完成数据
                }
                [wself.courseListFinishedArr removeAllObjects];
                NSMutableSet * typeName = [[NSMutableSet alloc]init];//课程的类别，不能重复，set集合不会有重复值
                NSDictionary *data = response.data;
                
                if (!wself.totalPlansList) {
                    wself.totalPlansList = [[NSMutableArray alloc]init];//所有的数据
                }
                [wself.totalPlansList removeAllObjects];
                
                wself.totalPlansList = [data objectForKey:@"dtExamInfo"];
                
                for(NSMutableDictionary *member in wself.totalPlansList) {
                    [typeName addObject:[member objectForKey:@"TypeName"]];
                }
                //            [wself.tableShowListAdd removeAllObjects];
                
                for (NSString *string in typeName)
                {
                    NSMutableArray *dataInfoArr = [[NSMutableArray alloc]init];
                    for (NSMutableDictionary *member in wself.totalPlansList) {//一个section下记录有多少门课程
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
                    
                    [wself.courseListFinishedArr addObject:group];
                    
                }
    
                
                [wself.noticeListTbV reloadData];
                
            }else{
                [wself.view makeToast:response.errDesc];
            }
            
        }];
        [wself.requestArr addObject:request];
    });
}
#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text;
    if (scrollView == self.noticeListTbV) {
        if ((self.whichTable == 0 && self.courseListArr&&self.courseListArr.count == 0)) {
            text = @"暂无未完成考试";
        }else if ((self.whichTable == 1 && self.courseListFinishedArr&&self.courseListFinishedArr.count == 0)) {
            text = @"暂无已完成考试";
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
    if(_whichTable == 0){
        return self.courseListArr.count;
    }else if (_whichTable == 1){
        return self.courseListFinishedArr.count;
    }else{
        return 0;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    checkOpen *check = self.ISOpen[section];
    if (check.isOpen) {
        if(_whichTable == 0){
            return [((RADataObject *)_courseListArr[section]).children count];
        }else if (_whichTable == 1){
            return [((RADataObject *)_courseListFinishedArr[section]).children count];
        }else{
            return 0;
        }
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static    NSString * cellString = @"NewsCell";
    MyExamCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"MyExamCell" owner:self options:nil];
        cell = [nibViews objectAtIndex:0];
    }
    RADataObject * radataObject;
    if(_whichTable == 0){
     radataObject =((RADataObject *)_courseListArr[indexPath.section]).children[indexPath.row];
    }else if(_whichTable == 1){
        radataObject =((RADataObject *)_courseListFinishedArr[indexPath.section]).children[indexPath.row];
    }
    
    PaperInfoModel *cellPaperInfo = [[PaperInfoModel alloc] initWithDictionary:radataObject.member];
    
    NSString* planName = cellPaperInfo.paperPlanName;
    NSString* planPoint = [NSString stringWithFormat:@"%0.1f",cellPaperInfo.paperPlanPoint];
    NSString* planPassPoint = [NSString stringWithFormat:@"%0.1f",cellPaperInfo.paperPlanPassPoint];
    NSString* planTime = [NSString stringWithFormat:@"%ld",cellPaperInfo.paperPlanTime];
    
    NSString* planDateBegin = cellPaperInfo.paperPlanDateBegin;
    NSString* planDateEnd = cellPaperInfo.paperPlanDateEnd;
    
    cell.examTypeLabel.text = [NSString stringWithFormat:@"%ld、%@",indexPath.row+1,planName];
    cell.examTotalScoreLabel.text =  [NSString stringWithFormat:@"考试总分: %@",planPoint];
    cell.examPassScoreLabel.text = [NSString stringWithFormat:@"通过分数: %@",planPassPoint];
    cell.examTimeCostLabel.text = [NSString stringWithFormat:@"考试时间: %@分钟", planTime];
    
    cell.examTimesLabel.text = [NSString stringWithFormat:@"剩余次数: %lu",cellPaperInfo.paperPlanJoinnum];
    cell.examDateLabel.text = [NSString stringWithFormat:@"有效期: %@ 至 %@",planDateBegin,planDateEnd];
    
    if (self.whichTable == 0) {
        
        cell.examResultIV.image = nil;
    }else{
        
        cell.examStatusIV.image = [UIImage imageNamed:@"ic_exam_finish"];
        if ([cellPaperInfo.paperPlanResultDate isEqualToString:@""]||cellPaperInfo.paperPlanResultDate == NULL)
        {//即时显示成绩
            NSString *paperState = cellPaperInfo.paperState;
            if ([paperState isEqualToString:@"0"]) {
                cell.examResultIV.image = [UIImage imageNamed:@"ic_exam_not_pass"];
            }else  if ([paperState isEqualToString:@"1"]) {
                cell.examResultIV.image = [UIImage imageNamed:@"ic_exam_pass"];
            }else{
            
            }
        }else{
            //    比较时间
            if ([NSDate isBeyondNowWithDateString:_paperInfo.paperPlanDateEnd]) {
                NSString *paperState = cellPaperInfo.paperState;
                if ([paperState isEqualToString:@"0"]) {
                    cell.examResultIV.image = [UIImage imageNamed:@"ic_exam_not_pass"];
                }else  if ([paperState isEqualToString:@"1"]) {
                    cell.examResultIV.image = [UIImage imageNamed:@"ic_exam_pass"];
                }
            }else{
                cell.examResultIV.image = [UIImage imageNamed:@"ic_exam_announce_answer"];
            }
        }
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
    
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0f;
}
//组头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView;
    NSString * courseName;
    NSInteger examNum;
    
    if (_whichTable == 0) {
        courseName = [((RADataObject *)_courseListArr[section]).member objectForKey:@"string"];
        examNum = [((RADataObject *)_courseListArr[section]).children count];
    }else if(_whichTable ==1){
        courseName = [((RADataObject *)_courseListFinishedArr[section]).member objectForKey:@"string"];
        examNum = [((RADataObject *)_courseListFinishedArr[section]).children count];
    }
    
    sectionView = [self createSectionView:courseName withTotal:[NSString stringWithFormat:@"%ld",(long)examNum] in:section];
    
    return sectionView;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
    return footerView;

}
//单击section实图
- (void)tapView:(UIButton *)sender{
    NSInteger  sectionNum = sender.tag-100;
    checkOpen *check = self.ISOpen[sectionNum];
    
    check.isOpen = !check.isOpen;
    
    _ISOpen[sectionNum] = check;
    
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:sectionNum];
    [self.noticeListTbV reloadSections:set withRowAnimation:UITableViewRowAnimationFade];

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RADataObject * radataObject;
    if (_whichTable == 0) {
        radataObject =((RADataObject *)_courseListArr[indexPath.section]).children[indexPath.row];//一门课程
    }else if(_whichTable ==1){
       radataObject =((RADataObject *)_courseListFinishedArr[indexPath.section]).children[indexPath.row];//一门课程
    }
    _paperInfo = [[PaperInfoModel alloc] initWithDictionary:radataObject.member];
    //获取当前的indexPath
    _myIndexPath = indexPath;
    
    
    if ([NSDate isBeyondNowWithDateString:_paperInfo.paperPlanDateEnd]) {
        
        [JCAlertView showOneButtonWithTitle:@"温馨提示" Message:@"该试卷已过期，无法参加考试" ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:@"确定" Click:^{
            
        }];
        return;
    };
    //    判断剩余次数
    self.remain_time = _paperInfo.paperPlanJoinnum;
    NSInteger nuInt = self.remain_time;
//    NSLog(@"剩余次数：%ld",_paperInfo.paperPlanJoinnum);
    
    if (nuInt<=0) {
        [JCAlertView showOneButtonWithTitle:@"温馨提示" Message:@"考试次数已用完，无法参加考试" ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:@"确定" Click:^{
        
        }];
        return;
    }
    NSString * messageStr = @"是否开始考试！";
    __weak MyExamsViewController *wself = self;
    [JCAlertView showTwoButtonsWithTitle:@"温馨提示" Message:messageStr ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"取消" Click:^{
    } ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:@"开始" Click:^{
        [wself gotoExamStart];
    }];
}

#pragma mark  - ChangePaperRemainTimesDelegate
- (void)ChangePaperRemainTimes:(NSInteger)remianTimes{
//    __weak MyExamsViewController *wself = self;
//    self.remain_time = remianTimes;
    if (self.whichTable == 0) {
        [self getUnFinishExamInfo];
    }else if (self.whichTable == 1){
        [self getFinishExamLogInfo];
        
    }
//    MyExamCell *cell = [self.noticeListTbV cellForRowAtIndexPath:self.myIndexPath];
//    cell.examTimesLabel.text = [NSString stringWithFormat:@"剩余次数: %lu",remianTimes];
    
}


#pragma mark - SZLSwitchViewDelegate
- (void)switchView:(SZLSwitchView *)switchView hasChangedIndex:(NSInteger)index{
    __weak MyExamsViewController *wself = self;
    self.whichTable = index;
    for (int i = 0;i<200;i++) {
        checkOpen *check = _ISOpen[i];
        check.isOpen = false;
        
        [self.ISOpen addObject:check];    }
    
    if(self.whichTable == 0){
       
        if(self.courseListArr){
            [UIView transitionWithView: self.noticeListTbV
                              duration: 0.3f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations: ^(void) {
                
                                [wself.noticeListTbV reloadData];
                            }completion: ^(BOOL isFinished){
                                
                            }];
            
            
            return;
        }


    }else{
        if (self.courseListFinishedArr) {
            [UIView transitionWithView: self.noticeListTbV
                              duration: 0.3f
                               options: UIViewAnimationOptionTransitionCrossDissolve
                            animations: ^(void) {
                                
                                [wself.noticeListTbV reloadData];
                            }completion: ^(BOOL isFinished){
                                
                            }];
            return;
        }
        
        
    }
    [self.noticeListTbV reloadData];
    [self.noticeListTbV.mj_header beginRefreshing];
    
}
#pragma mark private function
-(UIView *)createSectionView:(NSString *)courseName withTotal:(NSString *)examNum in:(NSInteger)section{
    UIView * sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
    sectionView.backgroundColor = MyBackColor;
    UIImageView *leftLine = [[UIImageView alloc] initWithFrame:CGRectMake(12, 20, 2, 19)];
    leftLine.backgroundColor = MyBlue;
    [sectionView addSubview:leftLine];
    NSString *titleLabelStr = [NSString stringWithFormat:@"【%@】",courseName];//分类
    UILabel *examTypeLabel = [[UILabel alloc]init];
    examTypeLabel.text = titleLabelStr;
    [sectionView addSubview:examTypeLabel];
    examTypeLabel.font = [UIFont systemFontOfSize:16.0f];
    examTypeLabel.textColor = MyTextColor;
    [examTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(leftLine.trailing).with.offset(@3);
        make.centerY.equalTo(leftLine.centerY);
        make.width.lessThanOrEqualTo(WIDTH-26-70-40);
    }];
//    NSString *titleLabelStr = [NSString stringWithFormat:@"%@ (共 %@ 门)",courseName,examNum];//分类
//    UILabel *examTypeLabel = [self createAdjustWidtLabel:titleLabelStr loactionX:20 loactionY:25];
//    examTypeLabel.text = titleLabelStr;
//    [sectionView addSubview:examTypeLabel];
//    examTypeLabel.font = [UIFont boldSystemFontOfSize:16];
//    examTypeLabel.textColor = MyTextColor;
    
    UIButton *openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openBtn.frame = CGRectMake(WIDTH - 40, 15, 70, 30);
    openBtn.backgroundColor = [UIColor clearColor];
    checkOpen *check = self.ISOpen[section];
    if (check.isOpen) {
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
    
    
    UIButton * bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.frame = sectionView.frame;
    [bgBtn addTarget:self action:@selector(tapView:) forControlEvents:UIControlEventTouchUpInside];
    bgBtn.backgroundColor = [UIColor clearColor];
    bgBtn.tag = 100+section;
    
    [sectionView addSubview:bgBtn];
    
    return sectionView;

}


-(UILabel *)createAdjustWidtLabel:(NSString *)title loactionX:(CGFloat)x loactionY:(CGFloat)y{
    UILabel *label = [UILabel new];
    [label setNumberOfLines:0];
//    label.text = title;
    UIFont *font = [UIFont boldSystemFontOfSize:17];
    CGSize size = CGSizeMake(320,2000);
    CGSize labelsize = [title sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [label setFrame:CGRectMake(x, y, labelsize.width+1, 20)];

    
    return label;

}


- (void)gotoExamStart{
//    __weak MyExamsViewController *wself = self;
    
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
    control.isShowAnswer = @"false";
    control.examOrPractice = 1;//1表示考试试卷
//    control.isShowTime = @"false";
    
    [self.navigationController pushViewController:control animated:YES];

    
}


@end
