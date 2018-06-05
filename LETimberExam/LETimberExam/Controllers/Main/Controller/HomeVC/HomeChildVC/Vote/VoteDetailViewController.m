//
//  VoteDetailViewController.m
//  SZLTimberTrain
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "VoteDetailViewController.h"
#import "VoteOptionCell.h"
#import "VoteOptionResultCell.h"
#import "SZLVoteListDomain.h"
#import "SZLVoteContentDomain.h"

typedef NS_ENUM(NSInteger, VoteType) {
    VoteTypeContent, //!< 未投票
    VoteTypeResult, //!< 已投票
    VoteTypeEnd //!< 已结束
};

@interface VoteDetailViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSInteger _kOptionNum;
}

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * contentLabel;
@property (nonatomic, strong) UITableView * contentTableView;
@property (nonatomic, strong) UIView * voteUpView;
@property (nonatomic, strong) UIButton * voteUpBtn;
@property (nonatomic, strong) UILabel * seperateLine;

@property (nonatomic, assign) VoteType voteType;
@property (nonatomic, strong) SZLVoteContentDomain * contentDomain;
@property (nonatomic, strong) NSMutableArray * options;

@end

@implementation VoteDetailViewController

#pragma mark - Lazy Loading
- (UITableView *)contentTableView {
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _contentTableView.dataSource = self;
        _contentTableView.delegate = self;
        if (self.voteType == VoteTypeContent) {
            _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
        _contentTableView.backgroundColor = [UIColor clearColor];
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 42)];
        view.backgroundColor = [UIColor clearColor];
        [_contentTableView setTableHeaderView:view];
    }
    return _contentTableView;
}

- (UILabel *)seperateLine {
    if (!_seperateLine) {
        _seperateLine = [[UILabel alloc]init];
        _seperateLine.backgroundColor = MyLineColor;
    }
    return _seperateLine;
}

- (UIButton *)voteUpBtn {
    if (!_voteUpBtn) {
        _voteUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voteUpBtn setExclusiveTouch:NO];
        if (self.voteType == VoteTypeContent) {
            [_voteUpBtn setBackgroundImage:[UIImage imageNamed:@"ic_course_btn"] forState:UIControlStateNormal];
            [_voteUpBtn setTitle:@"投票" forState:UIControlStateNormal];
        }else if (self.voteType == VoteTypeResult) {
            [_voteUpBtn setBackgroundImage:[UIImage imageNamed:@"ic_learn_evaluated"] forState:UIControlStateNormal];
            [_voteUpBtn setTitle:@"已投票" forState:UIControlStateNormal];
            [_voteUpBtn setUserInteractionEnabled:NO];
        }else if (self.voteType == VoteTypeEnd) {
            [_voteUpBtn setBackgroundImage:[UIImage imageNamed:@"ic_learn_evaluated"] forState:UIControlStateNormal];
            [_voteUpBtn setTitle:@"已结束" forState:UIControlStateNormal];
            [_voteUpBtn setUserInteractionEnabled:NO];
        }
        
        [_voteUpBtn addTarget:self action:@selector(voteUpAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voteUpBtn;
}

- (UIView *)voteUpView {
    if (!_voteUpView) {
        _voteUpView = [[UIView alloc]init];
        _voteUpView.backgroundColor = WhiteColor;
    }
    return _voteUpView;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _titleLabel.textColor = MyTextColor;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:13.0f];
        _contentLabel.textColor = [UIColor lightGrayColor];
    }
    return _contentLabel;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc]init];
        _headerView.backgroundColor = [UIColor clearColor];
    }
    return _headerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialData];
    [self createNav];
    [self configView];
    
    [self getVoteDetailDataWithState:NO];
    
}

- (void)dealloc {
    DLog(@"投票详情页面已释放");
}

- (void)initialData {
    _kOptionNum = -1;
    
    if ([NSDate isBeyondNowWithDateString:self.detailDomain.vote_end_time]) {
        self.voteType = VoteTypeEnd;
    }else{
        self.voteType = self.detailDomain.status;
    }
}
- (void)createNav{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"ic_register_back"] forState:UIControlStateNormal];
    
    [self.navigationLeftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)getVoteDetailDataWithState:(BOOL)isRefresh {
    __weak VoteDetailViewController * wself = self;
    
    if (kNetworkNotReachability) {
        [self.view makeToast:kError_Network_NotReachable];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __block ApiRequest * request = [SZLServerHelper getVoteDetailWithVotedId:self.detailDomain.vote_id callback:^(NSInteger errCode, ApiResponse *response, BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [wself.requestArr removeObject:request];
                [MBProgressHUD hideHUDForView:wself.contentView animated:YES];
            });
            
            if (success) {
                if (!wself.options) {
                    wself.options = [NSMutableArray array];
                }
                [wself.options removeAllObjects];
                
                wself.contentDomain = [[SZLVoteContentDomain alloc]initWithDictionary:response.data];
                
                if (wself.contentDomain.dtcourse.count>0) {
                    [wself.options addObjectsFromArray:wself.contentDomain.dtcourse];
                }
                
                [wself.contentTableView reloadData];
                
                [wself configData];
                
                if (!isRefresh) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [wself.voteUpView mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.bottom.equalTo(0);
                        }];
                        
                        [UIView animateWithDuration:.5f animations:^{
                            [wself.view layoutIfNeeded];
                        }];
                    });
                }
            }else{
                [wself.view makeToast:response.errDesc];
            }
        }];
        [wself.requestArr addObject:request];
    });
}

- (void)configData {
    
    self.titleLabel.text = self.contentDomain.vote_title;
    self.contentLabel.text = self.contentDomain.vote_remark;
    
    CGSize titleSize = [self.contentDomain.vote_title calculateSize:CGSizeMake(WIDTH-12*2, 999) font:[UIFont boldSystemFontOfSize:15.0f]];
    CGSize contentSize = [self.contentDomain.vote_remark calculateSize:CGSizeMake(WIDTH-12*2, 999) font:[UIFont systemFontOfSize:13.0f]];
    
    CGFloat totalHeight = 50.0f;
    
    if (titleSize.height>18) {
        totalHeight = totalHeight + titleSize.height - 18;
    }
    if (contentSize.height>16) {
        totalHeight = totalHeight + contentSize.height - 16;
    }
    
    UIView * view = self.contentTableView.tableHeaderView;
    view.v_height += totalHeight; // 文字高度 需根据返回数据计算
    
    [self.contentTableView beginUpdates];
    [self.contentTableView setTableHeaderView:view];;
    [self.contentTableView endUpdates];

}

- (void)configView {
    if (self.voteType == VoteTypeContent) {
        self.navigationTitle = @"投票内容";
    }else if (self.voteType == VoteTypeResult || self.voteType == VoteTypeEnd) {
        self.navigationTitle = @"投票结果";
    }
    
    [self.contentView addSubview:self.voteUpView];
    [self.voteUpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@44);
        make.leading.trailing.equalTo(@0);
        make.height.equalTo(@44);
    }];
    
    [self.voteUpView addSubview:self.voteUpBtn];
    [self.voteUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@140);
        make.height.equalTo(@35);
        make.center.equalTo(self.voteUpView.center);
    }];
    
    [self.voteUpView addSubview:self.seperateLine];
    [self.seperateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.height.equalTo(@1);
    }];

    
    [self.contentView addSubview:self.contentTableView];
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.bottom.equalTo(self.voteUpView.mas_top);
    }];
    
    [self.contentTableView.tableHeaderView addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.width.equalTo(WIDTH);
    }];
    
    
    [self.headerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@18);
        make.leading.equalTo(@12);
        make.trailing.equalTo(@-12);
    }];
    
    [self.headerView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(@8);
        make.leading.equalTo(@12);
        make.trailing.equalTo(@-12);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * cellIdentifier = [NSString stringWithFormat:@"cell-%@", @(self.voteType)];
    if (self.voteType == VoteTypeContent) {
        VoteOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[VoteOptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell setBorderStyleWithTableView:tableView indexPath:indexPath];
        cell.contentBorderColor = MyLineColor;
        if (self.options.count>0) {
            SZLVoteContentDetailDomain * contentDomain = [self.options safe_objectAtIndex:indexPath.row];
            cell.optionLabel.text = contentDomain.sub_body;
        }
        return cell;
    }else if (self.voteType == VoteTypeResult || self.voteType == VoteTypeEnd) {
        VoteOptionResultCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[VoteOptionResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];;
        }
        
        [cell configCellDataWithDomain:[self.contentDomain.dtcourse safe_objectAtIndex:indexPath.row] totalCount:self.contentDomain.count];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.voteType == VoteTypeContent) {
        return 44.0f;
    }else if (self.voteType == VoteTypeResult || self.voteType == VoteTypeEnd) {
        return 70.0f;
    }
    return CGFLOAT_MIN;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 28)];
    
    UILabel * title = [[UILabel alloc]init];
    title.textColor = MyNavColor;
    title.font = [UIFont boldSystemFontOfSize:14.0f];
    title.text = @"投票选项";
    [view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.centerY);
        make.leading.equalTo(@12);
    }];
    
    UILabel * content = [[UILabel alloc]init];
    content.textColor = [UIColor lightGrayColor];
    content.font = [UIFont systemFontOfSize:12.0f];
    content.text = [NSString stringWithFormat:@"(已有%@人参与)", @(self.contentDomain.count)];
    [view addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(title.centerY);
        make.leading.equalTo(title.trailing).with.offset(@4);
    }];
    
    if (self.options.count>0) {
        return view;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SZLVoteContentDetailDomain * contentDomain = [self.options safe_objectAtIndex:indexPath.row];
    _kOptionNum = contentDomain.sub_id;
}

#pragma mark - private actions
- (void)voteUpAction:(UIButton *)sender {
    if (_kOptionNum == -1) {
        [self.view makeToast:@"请先选择"];
        return;
    }
    
    if (kNetworkNotReachability) {
        [self.view makeToast:kError_Network_NotReachable];
        return;
    }
//    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    
    __weak VoteDetailViewController * wself = self;
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __block ApiRequest * request = [SZLServerHelper userVoteWithVotedId:self.detailDomain.vote_id subId:_kOptionNum callback:^(NSInteger errCode, ApiResponse *response, BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [wself.requestArr removeObject:request];
//                [MBProgressHUD hideHUDForView:wself.contentView animated:YES];
            });
            if (success) {
                [wself.view makeToast:@"投票成功"];
                
                [wself.voteUpBtn setBackgroundImage:[UIImage imageNamed:@"ic_learn_evaluated"] forState:UIControlStateNormal];
                [wself.voteUpBtn setTitle:@"已投票" forState:UIControlStateNormal];
                [wself.voteUpBtn setUserInteractionEnabled:NO];
                
                wself.voteType = VoteTypeResult;
                
                [wself getVoteDetailDataWithState:YES];
                
                if (wself.completion) {
                    wself.completion();
                }
            }else{
                [wself.view makeToast:response.errDesc];
            }
        }];
        [wself.requestArr addObject:request];
    });
}

@end
