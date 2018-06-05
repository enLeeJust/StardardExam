//
//  MyGradeViewController.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/12.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "MyGradeViewController.h"
//forTest
//#import "NewsCell.h"
#import "MyPracticeLogCell.h"

#import <AFHTTPSessionManager.h>
#import "WebServiceModel.h"
#import "myGradePlanModel.h"
#import "PaperBackLookViewController.h"
#import "SZLBaseWebViewController.h"
@interface MyGradeViewController (){

    BOOL _ISOpen[200];
}

@property(nonatomic,strong) NSMutableArray *courseList;

@end

@implementation MyGradeViewController
#pragma mark lazy Loading
-(UITableView*)myGradeTV{
    if (!_myGradeTV) {
        _myGradeTV = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myGradeTV.delegate = self;
        _myGradeTV.dataSource = self;
        _myGradeTV.emptyDataSetDelegate = self;
        _myGradeTV.emptyDataSetSource = self;
        _myGradeTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myGradeTV.scrollEnabled = YES;
        _myGradeTV.backgroundColor = MyBackColor;
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
        [_myGradeTV setTableHeaderView:view];
    }
    return _myGradeTV;
    
    
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self creatNav];
    [self createmyGradeTV];
    
    __weak MyGradeViewController *wself = self;
    
    self.myGradeTV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wself getMyGradeExamInfo];
    }];
    //第一次加载数据
    [_myGradeTV.mj_header beginRefreshing];
}

-(void)dealloc{

    DLog(@"dealloc Success");
}


#pragma mark -创建成绩列表（tableView）
- (void)createmyGradeTV{
    [self.contentView addSubview:self.myGradeTV];
    [self.myGradeTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(@0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)creatNav{
    
    self.navigationTitle = @"我的成绩";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"ic_register_back"] forState:UIControlStateNormal];
    [self.navigationLeftButton addTarget:self action:@selector(buttonBackToLastView) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - network request
/**
 *  AFNetWorking  请求数据
 *
 *  @return nil
 */

-(void)getMyGradeExamInfo{
    //加载数据
    __weak MyGradeViewController * wself = self;
    if (kNetworkNotReachability) {
        [self.view makeToast:kError_Network_NotReachable];
        return;
    }

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __block ApiRequest *request = [SZLServerHelper getMyGradeInfoRequest:1 callback:^(NSInteger errCode, ApiResponse *response, BOOL success) {
            [wself.requestArr removeObject:request];
            if (success) {
                if (!wself.courseList) {
                    wself.courseList = [[NSMutableArray alloc] init];
                }
                [wself.courseList removeAllObjects];
                
                NSDictionary *data = response.data;
                
                NSMutableArray *planList = [data objectForKey:@"courseList"];
                for (NSDictionary* examlogDetail in planList) {
                    myGradePlanModel *gradePlanModel = [[myGradePlanModel alloc] initWithDictionary:examlogDetail];
                    
                    [wself.courseList addObject:gradePlanModel];
                }
                
                [wself.myGradeTV reloadData];
                [wself.myGradeTV.mj_header endRefreshing];
            }else{
                [wself.view makeToast:response.errDesc];
            }
            
        }];
        [wself.requestArr addObject:request];
    });
    
    
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



#pragma mark - button Action
-(void)buttonBackToLastView{
    [self.navigationController popViewControllerAnimated:YES];
    
}
//单击section实图
- (void)tapView:(UIButton *)sender{
    NSInteger  sectionNum = sender.tag-100;
    _ISOpen[sectionNum] = !_ISOpen[sectionNum];
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:sectionNum];
    [_myGradeTV reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    
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

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text;
    if (self.courseList) {
        if (self.courseList.count>0) {
            text = @"";
        }else{
            text = @"暂无成绩记录";
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

#pragma mark - UITableviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.courseList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_ISOpen[section]) {
        myGradePlanModel *examLogModel = self.courseList[section];
        return examLogModel.examlog.count;
        
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static    NSString * cellString = @"MyPracticeLogCell";
    MyPracticeLogCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    myGradePlanModel *examLogModel = self.courseList[indexPath.section];
    MyGradeExamLogModel *examDetailModel = examLogModel.examlog[indexPath.row];
    if (!cell) {
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"MyPracticeLogCell" owner:self options:nil];
        cell = [nibViews objectAtIndex:0];
    }
    
    
    cell.joinTimeLabel.text = [NSString stringWithFormat:@"参加时间:%@",examDetailModel.exam_begin_time];
    NSString *time = [self dateTimeDifferenceWithStartTime:examDetailModel.exam_begin_time endTime:examDetailModel.exam_end_time];
    cell.useTimeLabel.text = time;
    
    //成绩详情
    if (examDetailModel.isun_showpoint == 0&&![self isOverShowPointDate:examDetailModel.plan_result_date]) {//不立即显示答案，并且没到公布答案时间
//        cell.showPointImageView.image = [UIImage imageNamed:@"ic_exam_announce_answer"];
        cell.practiceScoreLabel.text = @"得分:--";
        cell.practiceRightLabel.text = @"正确:--";
        cell.practiceWrongLabel.text = @"错误:--";
        cell.practiceUndoLabel.text = @"未做:--";
        
    }else{
        
        cell.practiceScoreLabel.text = [NSString stringWithFormat:@"得分:%0.1f",examDetailModel.exam_point];
        cell.practiceRightLabel.text = [NSString stringWithFormat:@"正确:%ld",examDetailModel.q_answer_correct];;
        cell.practiceWrongLabel.text = [NSString stringWithFormat:@"错误:%ld",examDetailModel.q_answer_error];
        cell.practiceUndoLabel.text = [NSString stringWithFormat:@"未做:%ld",examDetailModel.q_answer_undo];
    
    }
    
    

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
}



#pragma mark - UITableviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 70;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
//组头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    myGradePlanModel *examLogModel = self.courseList[section];
    NSString *planName = examLogModel.exam_plan_name;
    NSString *examTypeName = examLogModel.exam_type_Name;
    NSString *topPoint = [NSString stringWithFormat:@"%0.1f",examLogModel.exam_top_point];
    long paperState = examLogModel.exam_state;
    
    UIView *sectionView = [self createSectionView:planName inCourse:examTypeName withTopGrade:topPoint examState:paperState in:section];
    

    return sectionView;

}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    myGradePlanModel *examLogModel = self.courseList[indexPath.section];
    MyGradeExamLogModel *examDetailModel = examLogModel.examlog[indexPath.row];
    
    
    BOOL isUnshowPaper = examDetailModel.paper_unshow;
    NSString * messageStr;
    if (isUnshowPaper) {
        messageStr = @"此试卷不允许回看!";
        [JCAlertView showOneButtonWithTitle:@"温馨提示" Message:messageStr ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"确定" Click:^{
            
            
        }];

    }else{
        
        //如果没有公布  也无法查看试卷
        if (examDetailModel.isun_showpoint == 0&&![self isOverShowPointDate:examDetailModel.plan_result_date]) {
            //待公布
            messageStr = @"此试卷尚未公布成绩，试卷无法回看!";
            [JCAlertView showOneButtonWithTitle:@"温馨提示" Message:messageStr ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"确定" Click:^{
                
                
            }];
        }else{
            //允许回看试卷并且已经公布成绩
            PaperBackLookViewController *detailView = [[PaperBackLookViewController alloc] init];
            
            detailView.paperUrl = examDetailModel.paper_url;
            [self.navigationController pushViewController:detailView animated:YES];
//            SZLBaseWebViewController * webView = [[SZLBaseWebViewController alloc]initWithUrl:[NSURL URLWithString:examDetailModel.paper_url]];
//            
//            [self.navigationController pushViewController:webView animated:YES];

            
        }
        
        
    
    }
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(UIView *)createSectionView:(NSString *)knowledgeName inCourse:(NSString *)courseName withTopGrade:(NSString*)grade examState:(long)paperState in:(NSInteger)section{
    
    myGradePlanModel *examLogModel = self.courseList[section];
    
    MyGradeExamLogModel *examDetailModel = examLogModel.examlog[0];
    UIView* sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 70)];
    sectionView.backgroundColor = WhiteColor;
    UIImageView *leftLine = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 2, 20)];
    leftLine.backgroundColor = MyBlue;
    [sectionView addSubview:leftLine];
    
//    UILabel *knowledgeNameLabel = [self createAdjustWidtLabel:knowledgeName loactionX:17 loactionY:12];
    UILabel *knowledgeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 12,WIDTH-18-80, 20)];
    knowledgeNameLabel.text = knowledgeName;
    [sectionView addSubview:knowledgeNameLabel];
    knowledgeNameLabel.font = [UIFont boldSystemFontOfSize:16];
    knowledgeNameLabel.textColor = MyTextColor;
    
    UIImageView *gradeStatusIV = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH-80, 8, 68, 23)];
    [sectionView addSubview:gradeStatusIV];
    

//    UILabel *examTypeLabel = [self createAdjustWidtLabel:[NSString stringWithFormat:@"考试分类:%@",courseName] loactionX:12 loactionY:40];
    UILabel *examTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(18,40 , WIDTH-18-82 - 110, 20)];
    examTypeLabel.text = [NSString stringWithFormat:@"考试分类:%@",courseName];
    examTypeLabel.textColor = [UIColor lightGrayColor];
    examTypeLabel.font = [UIFont boldSystemFontOfSize:14];
    
    [sectionView addSubview:examTypeLabel];
    
    
//    UILabel *topGradeLabel = [self createAdjustWidtLabel:@"最好成绩:待公布" loactionX:(12+examTypeLabel.v_size.width+10)  loactionY:40];
    UILabel *topGradeLabel = [[UILabel alloc]initWithFrame:CGRectMake(18+WIDTH-18-82 - 105,40 ,110, 20)];
    topGradeLabel.textColor = [UIColor lightGrayColor];
    topGradeLabel.font = [UIFont boldSystemFontOfSize:14];
    [sectionView addSubview:topGradeLabel];
    
    if (examDetailModel.isun_showpoint == 0&&![self isOverShowPointDate:examDetailModel.plan_result_date]) {
        //待公布
        gradeStatusIV.contentMode = UIViewContentModeScaleAspectFit;
        gradeStatusIV.image = [UIImage imageNamed:@"ic_grade_unknow"];
        topGradeLabel.text = @"最好成绩:待公布";
        
    }else{
        topGradeLabel.text = [NSString stringWithFormat:@"最好成绩:%@",grade];
        if (paperState == 0) {
            gradeStatusIV.contentMode = UIViewContentModeScaleAspectFit;
            gradeStatusIV.image = [UIImage imageNamed:@"ic_grade_not_pass"];
        }else if (paperState == 1){
            gradeStatusIV.contentMode = UIViewContentModeScaleAspectFit;
            gradeStatusIV.image = [UIImage imageNamed:@"ic_grade_pass"];
            
        }
        
    }
    
    
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
    //    label.text = title;
    UIFont *font =[UIFont boldSystemFontOfSize:16];
    CGSize size = CGSizeMake(320,2000);
    CGSize labelsize = [title sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [label setFrame:CGRectMake(x, y, labelsize.width+3, 20)];
    
    return label;
    
}
@end
