//
//  NewsViewController.m
//  SZLTimber
//
//  Created by Mac on 15/11/26.
//  Copyright © 2015年 timber. All rights reserved.
//

#import "NewsViewController.h"
#import "RADataObject.h"
#import "NewsCell.h"
#import "UseFMDBTool.h"//用于判断是不阅读过
//#import "NewsDetailViewController.h"
#import "SZLBaseWebViewController.h"

#import "NewsOrNoticeModel.h"
#import <AFHTTPSessionManager.h>
#import "WebServiceModel.h"


@interface NewsViewController ()<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (strong, nonatomic) NSMutableArray *newsOrNoticesList;

@property (strong, nonatomic) NSMutableArray *newsOrNoticesModelsArr;
@property (assign, nonatomic) id expanded;

@property (nonatomic, strong) UITableView * contentTableView;

@property(nonatomic,assign) int pageSize;//每页几条数据
@property(nonatomic,assign) int pageNum;//第几页
@end

@implementation NewsViewController

- (UITableView *)contentTableView {
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _contentTableView.dataSource = self;
        _contentTableView.delegate = self;
        _contentTableView.emptyDataSetSource = self;
        _contentTableView.emptyDataSetDelegate = self;
        
        _contentTableView.backgroundColor = [UIColor clearColor];
    }
    return _contentTableView;
}


#pragma mark - life scycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak NewsViewController *wself = self;

    self.newsOrNoticesList = [[NSMutableArray alloc] init];
    self.pageNum = 1;
    [self creatNav];
    [self configView];
    
    
    self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [wself.contentTableView reloadData];
        [wself.contentTableView.mj_header endRefreshing];
    }];
    
    self.contentTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:wself refreshingAction:@selector(loadMoreData)];
    //在刷新数据覆盖不显示数据的 cell 的分割线,如果不设置,则会显示 cell 的分割线
    self.contentTableView.mj_footer.automaticallyHidden = YES;
    [self.contentTableView.mj_header beginRefreshing];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
    }
    [self.contentTableView reloadData];
}

-(void)dealloc{

    DLog(@"dealloc");

}
#pragma mark - 创建列表
- (void)configView {
    
    [self.contentView addSubview:self.contentTableView];
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

-(void)creatNav{
    if ([self.newsOrNoticeType isEqualToString:@"0"] ) {
        self.navigationTitle = @"新闻信息";
        [self sendRequestForData:1];//请求新闻数据
        
    }else if ([self.newsOrNoticeType isEqualToString:@"1"]){
        self.navigationTitle = @"公告信息";
        [self sendRequestForData:2];//请求公告数据
    }
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"ic_register_back"] forState:UIControlStateNormal];
    
    [self.navigationLeftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - personal Func
-(void)loadMoreData{
    if(_pageNum*_pageSize >_newsOrNoticesNum||_pageNum*_pageSize == _newsOrNoticesNum){
        [self.contentTableView.mj_footer endRefreshing];
        
        
        [self.contentTableView.mj_footer endRefreshingWithNoMoreData];
        [self.contentTableView reloadData];
        self.contentTableView.mj_footer.hidden = NO;

    }else{
        _pageNum += 1;
        if ([self.newsOrNoticeType isEqualToString:@"0"] ) {
            [self sendRequestForData:1];//请求新闻数据
            
        }else if ([self.newsOrNoticeType isEqualToString:@"1"]){
            [self sendRequestForData:2];//请求公告数据
        }
    
    }
}


#pragma mark - getData
-(void)sendRequestForData:(NSInteger)type{
    if (HEIGHT > WIDTH) {
        if (HEIGHT == 568) {
            _pageSize = 6;
            NSLog(@"当前为iPhone 5/5c/5s iPod Touch5 设备");
            
        }else if (HEIGHT == 667) {
            _pageSize = 8;
            NSLog(@"当前为iPhone6/6s设备");
            
        }else if (HEIGHT == 736) {
            _pageSize = 9;
            NSLog(@"当前为iPhone6 Plus/iPhone6s Plus 设备");
        }else {
            _pageSize = 4;
            NSLog(@"当前为iPhone4/4s 等其他设备");
        }
        
    }
    NSDictionary *prama = @{
                            @"servletname":@"NewNotice",
                            @"pageSize":@(_pageSize),
                            @"pageNum":@(_pageNum),
                            @"type":@(type),
                            };
    [self getInfomationsNum:prama];
    
}


#pragma mark - backAction
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - 网络请求数据

/**
 *  获取通知和新闻的详情
 */
-(void)getInfomationsNum:(NSDictionary *)prama
{
    __weak NewsViewController * wself = self;
    if (kNetworkNotReachability) {
        [wself.view makeToast:kError_Network_NotReachable];
        return;
    }

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __block ApiRequest* request = [SZLServerHelper getNewsNumRequest:prama callback:^(NSInteger errCode, ApiResponse *response, BOOL success) {
            @try {
                [wself.requestArr removeObject:request];
                
                if (success) {
                    NSMutableDictionary *data = response.data;
                    
                    NSMutableArray *getList = [data objectForKey:@"dtcourse"];
                    
                    for (NSDictionary *newsOrNotice in getList) {
                        [wself.newsOrNoticesList addObject:newsOrNotice];
                    }
                    wself.newsOrNoticesModelsArr = [wself createModelData:wself.newsOrNoticesList];
                    
                    
                }else{
                    [wself.view makeToast:response.errDesc];
                }
            } @catch (NSException *exception) {
                wself.pageNum -= 1;
            } @finally {
                [wself.contentTableView reloadData];
                [wself.contentTableView.mj_footer endRefreshing];
                wself.contentTableView.mj_footer.hidden = NO;
            }
            
        }];
        [wself.requestArr addObject:request];
    });
    
    
    
}


/**
 *  生成数据模型
 *
 *  @param responseData 网络请求到的数据
 *
 *  @return newsModel的集合

 */
-(NSMutableArray *)createModelData:(NSMutableArray *)responseData{
    NSMutableArray *newsModelsArr = [[NSMutableArray alloc] init];
    for (NSDictionary *newsDict in responseData) {
        NewsOrNoticeModel *newsModel = [[NewsOrNoticeModel alloc] initWithDictionary:newsDict];
        [newsModelsArr addObject:newsModel];
        
    }
    
    return newsModelsArr;
}


#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text;
    
    if (scrollView == self.contentTableView&&self.newsOrNoticesModelsArr.count==0) {
        if ([self.newsOrNoticeType isEqualToString:@"0"]) {
            text = @"暂无新闻";
        }else{
            text = @"暂无公告";
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


#pragma mark TabelViewData Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
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
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsOrNoticesModelsArr.count;
}

#pragma mark TreeView Data Source

/**
 *  <#Description#>
 *
 @property(nonatomic,copy) NSString*commend;
 @property(nonatomic,assign) long  news_Id;
 
 @property(nonatomic,copy) NSString* news_name;
 @property(nonatomic,copy) NSString* news_send_date;
 @property(nonatomic,copy) NSString* type_name;
 @property(nonatomic,copy) NSString* news_url;
 */

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static    NSString * cellString = @"NewsCell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
        cell = [nibViews objectAtIndex:0];
    }
    NewsOrNoticeModel *newsOrNotice = self.newsOrNoticesModelsArr[indexPath.row];
    
    cell.newsBody.text = newsOrNotice.news_name;
    cell.newsType.text = newsOrNotice.type_name;
    cell.newsDate.text = newsOrNotice.news_send_date;
    
    NSArray* myArr = [[UseFMDBTool sharedInstance]user:USERID newsOrNotice:self.newsOrNoticeType];
    IsRead* user = [IsRead new];
    
    user.ItemId = [NSString stringWithFormat:@"%ld",newsOrNotice.news_id];
    user.Type = self.newsOrNoticeType;//0 表示是新闻
    user.UserID = USERID;
    
    
    if([newsOrNotice.commend isEqualToString:@"1"]){
        cell.newsStatus.image = [UIImage imageNamed:@"ic_news_introduce"];
        
        for (IsRead* read in myArr) {//如果已经加进去，就不用再加
            
            if (read.ItemId.longLongValue == newsOrNotice.news_id&&[read.Type isEqualToString:self.newsOrNoticeType]) {
                cell.newsBody.textColor = [UIColor lightGrayColor];
                
                break;
                
            }
            
            
        }
        
        
    }else{
       
//        NSLog(@"所有的id:%@\n当前id:%ld",myArr,newsOrNotice.newsId);
        if([myArr count] == 0){
            cell.newsStatus.image = [UIImage imageNamed:@"ic_news_notread"];
        
        }else{
            for (IsRead* read in myArr) {//如果已经加进去，就不用再加
                
                if (read.ItemId.longLongValue == newsOrNotice.news_id&&[read.Type isEqualToString:self.newsOrNoticeType]) {
                    cell.newsStatus.image = [UIImage imageNamed:@"ic_news_read"];
                    
                    break;
                    
                }else{
                    cell.newsStatus.image = [UIImage imageNamed:@"ic_news_notread"];
                    
                }
                
                
            }
        }
        
        
        
        
        
    }
    
    
   
    
    return cell;

}
#pragma mark tabelView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsOrNoticeModel *newsOrNotice = self.newsOrNoticesModelsArr[indexPath.row];
//    SZLBaseWebViewController *newsDetailView = [[SZLBaseWebViewController alloc] init];
    SZLBaseWebViewController * webView = [[SZLBaseWebViewController alloc]initWithUrl:[NSURL URLWithString:newsOrNotice.url]];
//    newsDetailView.newsOrNoticeDetail = newsOrNotice;
    [self.navigationController pushViewController:webView animated:YES];
    
    NSArray* myArr = [[UseFMDBTool sharedInstance]user:USERID newsOrNotice:self.newsOrNoticeType];
    IsRead* user = [IsRead new];
    
    user.ItemId = [NSString stringWithFormat:@"%ld",newsOrNotice.news_id];
    user.Type = self.newsOrNoticeType;//0 表示是新闻
    user.UserID = USERID;
//    NSLog(@"所有的id:%@\n当前id:%ld",myArr,newsOrNotice.news_id);
    
    for (IsRead* read in myArr) {//如果已经加进去，就不用再加
        if (read.ItemId.longLongValue == newsOrNotice.news_id&&[read.Type isEqualToString:self.newsOrNoticeType]) {
            return;
        }
    }
    
    [[UseFMDBTool sharedInstance]addUserObject:user];
    
}
@end
