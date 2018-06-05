//
//  MyErrorsViewController.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/12.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "MyErrorsViewController.h"
#import "MyErrorCell.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

#import "ExamDetailViewController.h"
//#define DBNAME    @"personinfo.sqlite"

#define ID        @"id"

@interface MyErrorsViewController ()<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>{
    FMDatabase *db;
    BOOL _ISOpen[200];
    
    NSArray * errorDataList;
    NSArray * collectDataList;
    
    NSMutableArray * examQArr;//总错题数
    NSMutableArray * collectQArr;//总收藏数
    NSMutableArray * planNameList;
}

@end

@implementation MyErrorsViewController
#pragma mark lazy Loading
-(UITableView*)myErrorTV{
    if (!_myErrorTV) {
        _myErrorTV = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myErrorTV.delegate = self;
        _myErrorTV.dataSource = self;
        _myErrorTV.emptyDataSetSource = self;
        _myErrorTV.emptyDataSetDelegate = self;
        _myErrorTV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _myErrorTV.scrollEnabled = YES;
        _myErrorTV.backgroundColor = MyBackColor;
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 15)];
        [_myErrorTV setTableHeaderView:view];
    }
    return _myErrorTV;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatNav];
    [self createMyGradeTVTV];
    [self createDataArr];
    __weak MyErrorsViewController *wself = self;
    self.myErrorTV.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //        [self loadData];
        [wself.myErrorTV reloadData];
        [wself.myErrorTV.mj_header endRefreshing];
    }];
}


-(void)dealloc{
    DLog(@"success");

}
#pragma mark -创建成绩列表（tableView）
- (void)createMyGradeTVTV{
    [self.contentView addSubview:self.myErrorTV];
    [self.myErrorTV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(@0);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)creatNav{
    
    self.navigationTitle = @"我的错题";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"ic_register_back"] forState:UIControlStateNormal];
    [self.navigationLeftButton addTarget:self action:@selector(buttonBackToLastView) forControlEvents:UIControlEventTouchUpInside];
}



#pragma mark 创建DataArr
-(void)createDataArr{
    examQArr = [[NSMutableArray alloc]init];
    collectQArr = [[NSMutableArray alloc]init];
    planNameList = [[NSMutableArray alloc] init];
    //    从数据库获取data
    //    数据库路径，创建数据库
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    db = [FMDatabase databaseWithPath:database_path];
    
    examQArr = [self selectDatatableName:TABLEERROR];
    [self getListByQuesPlanName:examQArr];

}
/**
 *  通过数据库查询，获得数据
 *
 *  @param tableName 数据库名字
 */
-(NSMutableArray *) selectDatatableName:(NSString *)tableName{
    NSString * sql;
    NSMutableArray *dataFromDB =[[NSMutableArray alloc] init];
    sql = [NSString stringWithFormat:@"SELECT * FROM %@ where %@ = %@ Order By rowid  DESC",tableName,userID,USERID];
    
    if ([db open]) {
        FMResultSet * resultSet = [db executeQuery:sql];
        
        while ([resultSet next]) {
            NSMutableDictionary * errorInfoDic = [[NSMutableDictionary alloc]init];
            
            
            NSString * errorID = [resultSet stringForColumn:ID];
            NSString * errorQId = [resultSet stringForColumn:qId];
            NSString * errortype =[resultSet stringForColumn:qType];
            NSString * errorTitle = [resultSet stringForColumn:qTitle];
            NSString * errorBody = [resultSet stringForColumn:qBody];
            NSString * errorAnswer = [resultSet stringForColumn:qAnswer];
            NSString * errorMark = [resultSet stringForColumn:qMark];
            NSString * errorMode = [resultSet stringForColumn:qMode];
            NSString * errorPlanName = [resultSet stringForColumn:qPlanName];
            NSString * ModuleUrl = [resultSet stringForColumn:qModuleUrl];
            
            [errorInfoDic setObject:errorID forKey:@"ID"];
            [errorInfoDic setObject:errorPlanName forKey:@"PlanName"];
            [errorInfoDic setObject:errorQId forKey:@"QID"];
            [errorInfoDic setObject:errortype forKey:@"QTYPE"];
            [errorInfoDic setObject:errorTitle forKey:@"QTITLE"];
            [errorInfoDic setObject:errorBody forKey:@"QBODY"];
            [errorInfoDic setObject:errorAnswer forKey:@"QANSWER"];
            [errorInfoDic setObject:errorMark forKey:@"QMARK"];
            [errorInfoDic setObject:errorMode forKey:@"QMODE"];
            [errorInfoDic setObject:ModuleUrl forKey:@"ModuleUrl"];
            if([tableName isEqualToString:TABLEERROR]){
                NSString * errorUserQAnswer = [resultSet stringForColumn:userQAnswer];
                [errorInfoDic setObject:errorUserQAnswer forKey:@"UserAnswer"];
            }else{
                
            }
   
            [dataFromDB addObject:errorInfoDic];
            
        }
        [db close];
    }else {
        NSLog(@"数据库取值失败！");
        return nil;
    }
//     NSLog(@"个数：%ld\n收集的错题:%@",dataFromDB.count,dataFromDB);
    return dataFromDB;

    
}

/**
 *  对题目进行分类
 *
 *  @return
 */
-(void)getListByQuesPlanName:(NSMutableArray*)errorList{
    NSMutableSet * typeName = [[NSMutableSet alloc]init];
    for(NSMutableDictionary *member in errorList) {
        [typeName addObject:[member objectForKey:@"PlanName"]];
    }
    
    planNameList = [[NSMutableArray alloc]init];//数据源
    
    for (NSString *string in typeName)
    {
        NSMutableArray *dataInfoArr = [[NSMutableArray alloc]init];
        for (NSMutableDictionary *member in errorList) {//一个section下记录有多少门课程
            if ([[member objectForKey:@"PlanName"] isEqualToString:string]) {
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
        [planNameList addObject:group];
    }

}

/**
 *  删除数据库内容
 */
-(void) deleteDatatableName:(NSString *)tableName :(int)_qId {
     if([tableName isEqualToString:TABLECOLLECT]){
         if ([db open]) {
             NSString *deleteSql;
             if (_qId==0) {
                 deleteSql = [NSString stringWithFormat:
                              @"delete  from %@ ",TABLECOLLECT ];
             }else{
                 deleteSql = [NSString stringWithFormat:
                              @"delete from %@ where %@ = %d",
                              TABLECOLLECT, qId, _qId];
             }
             BOOL res = [db executeUpdate:deleteSql];
             
             if (!res) {
                 NSLog(@"error when delete db table");
             } else {
                 NSLog(@"success to delete db table");
             }
             [db close];
             
         }
     }else if ([tableName isEqualToString:TABLEERROR]){
         if ([db open]) {
             NSString *deleteSql;
             if (_qId==0) {
                 deleteSql = [NSString stringWithFormat:
                              @"delete  from %@ ",TABLEERROR ];
             }else{
                 deleteSql = [NSString stringWithFormat:
                              @"delete from %@ where %@ = %d",
                              TABLECOLLECT, qId, _qId];
             }
             BOOL res = [db executeUpdate:deleteSql];
             
             if (!res) {
                 NSLog(@"error when delete db table");
             } else {
                 NSLog(@"success to delete db table");
             }
             [db close];
         }
     }
     
     
 }
-(void)buttonBackToLastView{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text;
    if (scrollView == self.myErrorTV&&planNameList.count == 0) {
        text = @"暂无错题";
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
    
    //    return dataArr2.count;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (_ISOpen[section]) {
//        return 3;
//    }
    return  planNameList.count;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (planNameList.count>0) {
        return 5.0f;
    }
    return 0.1f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static    NSString * cellString = @"NewsCell";
    MyErrorCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"MyErrorCell" owner:self options:nil];
        cell = [nibViews objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    cell.myErrorCourseLabel.text = [((RADataObject *)planNameList[indexPath.row]).member objectForKey:@"string"];
    cell.myErrorSumLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[((RADataObject *)planNameList[indexPath.row]).children count]];
    
    return cell;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *errorList =[((RADataObject *)planNameList[indexPath.row]).children mutableCopy];
    ExamDetailViewController *detailVC = [[ExamDetailViewController alloc] init];
    detailVC.examOrPractice = 3;
    detailVC.isShowAnswer = @"true";
    detailVC.questionListsArr = [self myErrorListData:errorList];
    
    
    NSLog(@"detailVC.questionListsArr:%@",detailVC.questionListsArr);
    [self.navigationController pushViewController:detailVC animated:YES];
   
    
    
}

-(NSMutableArray *)myErrorListData:(NSMutableArray *)errorList{
    NSMutableArray* toNextData = [[NSMutableArray alloc] init];
    for (RADataObject *radataObject in errorList) {
        [toNextData addObject:radataObject.member];
    }    
    
    return toNextData;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
