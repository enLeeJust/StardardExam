//
//  questionListViewController.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/20.
//  Copyright © 2016年 timber. All rights reserved.
//
#define kPadding 0
#define kVerticalSpacing 0
#define kSideLength (WIDTH-20)/6
#define kItemHeight (WIDTH-20)/6

#import "QuestionListViewController.h"
#import "QuesCardCell.h"

#import "ExamResultsViewController.h"

@interface QuestionListViewController ()
@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation QuestionListViewController
@synthesize delegate;

static NSString *quesCardCellIdentifier = @"QuesCardCell";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createNav];
    [self createCardWholeView];
    
    NSLog(@"做题情况：%@",_questionDone);
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
    self.navigationTitle = @"答题卡";
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"ic_register_back"] forState:UIControlStateNormal];
    [self.navigationLeftButton addTarget:self action:@selector(buttonBackToLastView) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)buttonBackToLastView{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)createCardCollection{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.sectionInset = UIEdgeInsetsMake(kVerticalSpacing, kPadding, kVerticalSpacing, kPadding);
    layout.itemSize = CGSizeMake(kSideLength, kItemHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = kPadding;
    self.cardCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.cardCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:quesCardCellIdentifier];
    
    self.cardCollectionView.dataSource = self;
    self.cardCollectionView.delegate = self;
    self.cardCollectionView.backgroundColor = [UIColor whiteColor];
    self.cardCollectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.cardCollectionView];
    [self.cardCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@10);
        make.leading.trailing.equalTo(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-100);
    }];

}

-(void)createEndExamBtn{
    _endExamBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_endExamBtn setTitle:@"交卷并查看结果" forState:UIControlStateNormal];
    [_endExamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_endExamBtn setBackgroundImage:[UIImage imageNamed:@"ic_exam_end_upload"] forState:UIControlStateNormal];
    [_endExamBtn addTarget:self action:@selector(jumpToExamGradeVC) forControlEvents: UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.endExamBtn];
    [self.endExamBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(15);
        
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-30);
        make.width.equalTo(@(WIDTH-30));
        make.height.equalTo(40);
    }];
    
}

#pragma mark 创建答题卡视图
-(void)createCardWholeView{
    [self createCardCollection];
    if (_examOrPractice == 1 || _examOrPractice == 2) {
        [self createEndExamBtn];
    }else{
        _endExamBtn = nil;
    }
    
    
}
#pragma mark 跳转到公布成绩界面
-(void)jumpToExamGradeVC{
    
    [self uploadPaperDetail:_paperString inPaper:_tmInfo];
}

#pragma mark - 提交试卷
/**
 *  提交试卷
 *  ReceiveKeep
 *  @param urlnew 接口url
 *  @param prama  参数
 */


-(void)uploadPaperDetail:(NSString *)paperInfo inPaper:(NSString *)tmInfo{
    __weak QuestionListViewController * wself = self;
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
                    ExamResultsViewController *next = [[ExamResultsViewController alloc] init];
                    next.examOrPractice = self.examOrPractice;
                    next.examGradeInfo = wself.gradeInfoModel;
                    next.grade = response.getPoint;
                    [wself.navigationController pushViewController:next animated:YES];
                    
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
#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _questionDone.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    
    UINib *nib = [UINib nibWithNibName:@"QuesCardCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:quesCardCellIdentifier];
    
    QuesCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:quesCardCellIdentifier forIndexPath:indexPath];
    
//    NSLog(@"%@",_questionDone[indexPath.row]);
    if ([_questionDone[indexPath.row] isEqual:@1]) {
        cell.quesDoneIV.image = [UIImage imageNamed:@"ic_exam_sheet_do"];
    }else{
        cell.quesDoneIV.image = [UIImage imageNamed:@"ic_exam_sheet_undo"];
        cell.quesIndexLabel.textColor = MyOrange;
    }
    cell.quesIndexLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    
    if ([_questionMark[indexPath.row] isEqual:@1]) {
        cell.quesMarkIV.image = [UIImage imageNamed:@"ic_exam_mark_question"];
    }else{
        cell.quesMarkIV.image = nil;
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
//当cell高亮时返回是否高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    //设置(Highlight)高亮下的颜色
    [cell setBackgroundColor:MyBackColor];
}

- (void)collectionView:(UICollectionView *)colView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    //设置(Nomal)正常状态下的颜色
    [cell setBackgroundColor:[UIColor whiteColor]];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    int index = indexPath.row;
    if([delegate respondsToSelector:@selector(changeToSelectedView:)])
    {
        //send the delegate function with the amount entered by the user
        [delegate changeToSelectedView:index];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
