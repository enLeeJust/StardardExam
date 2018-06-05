//
//  VoteListViewController.m
//  SZLTimberTrain
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "VoteListViewController.h"
#import "VoteDetailCell.h"
#import "VoteDetailViewController.h"
#import "SZLVoteListDomain.h"

@interface VoteListViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, assign) NSInteger kPageSize; //!< 单次请求数量
@property (nonatomic, assign) NSInteger kPageNum; //!< 本次请求页码

@property (nonatomic, strong) UITableView * contentTableView;
@property (nonatomic, strong) SZLVoteListDomain * listDomain;
@property (nonatomic, strong) NSMutableArray * listArr;

@end

@implementation VoteListViewController

#pragma mark - Lazy Loading
- (UITableView *)contentTableView {
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.emptyDataSetSource = self;
        _contentTableView.emptyDataSetDelegate = self;
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contentTableView.backgroundColor = [UIColor clearColor];
    }
    return _contentTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialData];
    [self createNav];
    [self configView];
    
    __weak VoteListViewController * wself = self;
    self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        wself.kPageNum = 1;
        [wself getVoteListWithRefreshState:YES];
    }];
    
    self.contentTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        wself.kPageNum ++;
        [wself getVoteListWithRefreshState:NO];
    }];
    
    self.contentTableView.mj_footer.automaticallyHidden = YES;
    [self.contentTableView.mj_header beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    DLog(@"投票列表页面已释放");
}

- (void)initialData {
    _kPageSize = 8;
    _kPageNum = 1;
}
- (void)createNav{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"ic_register_back"] forState:UIControlStateNormal];
    
    [self.navigationLeftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}
- (void)configView {
    self.navigationTitle = @"在线投票";
    
    [self.contentView addSubview:self.contentTableView];
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)getVoteListWithRefreshState:(BOOL)isDownPull {
    __weak VoteListViewController * wself = self;
    
    if (kNetworkNotReachability) {
        [self.view makeToast:kError_Network_NotReachable];
        if (isDownPull) {
            [self.contentTableView.mj_header endRefreshing];
        }else{
            [self.contentTableView.mj_footer endRefreshing];
        }
        return;
    }
    __block ApiRequest * request = [SZLServerHelper getVoteListWithPageSize:_kPageSize pageNum:_kPageNum callback:^(NSInteger errCode, ApiResponse *response, BOOL success) {
        [wself.requestArr removeObject:request];
        if (isDownPull) {
            [wself.contentTableView.mj_header endRefreshing];
        }else{
            [wself.contentTableView.mj_footer endRefreshing];
        }
        
        if (success) {
            if (!wself.listArr) {
                wself.listArr = [NSMutableArray array];
            }
            
            if (isDownPull) {
                [wself.listArr removeAllObjects];
            }
            
            if (0 == response.total) {
                ((MJRefreshAutoStateFooter*)wself.contentTableView.mj_footer).stateLabel.hidden = YES;
                [wself.contentTableView.mj_footer endRefreshingWithNoMoreData];
                [wself.listArr removeAllObjects];
                [wself.contentTableView reloadData];
            }else{
                if (0 != response.subtotal) {
                    if (response.subtotal == wself.kPageSize) {
                        ((MJRefreshAutoStateFooter*)wself.contentTableView.mj_footer).stateLabel.hidden = NO;
                        [wself.contentTableView.mj_footer resetNoMoreData];
                    }else{
                        [wself.contentTableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    
                    wself.listDomain = [[SZLVoteListDomain alloc]initWithDictionary:response.data];
                    [wself.listArr addObjectsFromArray:wself.listDomain.dtcourse];
                    
                    [wself.contentTableView reloadData];
                }else{
                    ((MJRefreshAutoStateFooter*)wself.contentTableView.mj_footer).stateLabel.hidden = YES;
                    [wself.contentTableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }else{
            [wself.view makeToast:response.errDesc];
        }
    }];
    [self.requestArr addObject:request];
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text;
    
    if (self.listArr) {
        text = @"暂无投票";
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"VoteCell";
    VoteDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VoteDetailCell" owner:self options:nil]lastObject];
    }
    [cell configCellDataWithDomain:[self.listArr safe_objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [VoteDetailCell configCellHeightWithDomain:[self.listArr safe_objectAtIndex:indexPath.row]];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VoteDetailViewController * viewController = [[VoteDetailViewController alloc]init];
    viewController.detailDomain = [self.listArr safe_objectAtIndex:indexPath.row];
    
    __block SZLVoteDetailDomain * domain = [self.listArr safe_objectAtIndex:indexPath.row];
    viewController.completion = ^(){
        domain.status = 1;
        [self.listArr replaceObjectAtIndex:indexPath.row withObject:domain];
    };
    
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
