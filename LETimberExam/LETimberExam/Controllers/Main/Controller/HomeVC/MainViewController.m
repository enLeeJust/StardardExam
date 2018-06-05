//
//  MainViewController.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/8.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "MainViewController.h"

#import "MainFuncCell.h"
#import "CourseDetailCell.h"
#import "CourseDisplayCell.h"
#import "SZLNaviBarBtnItem.h"

#import "MySettingVC.h"
#import <AFHTTPSessionManager.h>
#import "WebServiceModel.h"
#import "UseFMDBTool.h"
#import "LoginInfoDomain.h"
#import "NewsViewController.h"
//#import "SignInViewController.h"
#import "VoteListViewController.h"
#import "UserBaseInfoModel.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define biliHeight self.view.frame.size.height/736

@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, SDCycleScrollViewDelegate>

@property (strong, nonatomic) UITableView * contentTableView;
@property (strong, nonatomic) SDCycleScrollView * picScrollView;
@property (strong, nonatomic) UICollectionView * mainFuncView;
@property (strong, nonatomic) NSMutableArray * imagesUrlList;

@property (nonatomic,assign) NSInteger newsNum;
@property (nonatomic,assign) NSInteger notictNum;

@property (strong, nonatomic) NSArray* IsReadNewsArr;
@property (strong, nonatomic) NSArray* IsReadNoticesArr;
@property (strong, nonatomic) UIImage* myHeadImg;
@property (strong, nonatomic) UserBaseInfoModel *userInfo;

@property (assign, nonatomic) AutoLoginState autoLoginState;
@property (nonatomic,strong) MBProgressHUD *hud;
@end

@implementation MainViewController

#pragma mark - Lazy loading
- (UICollectionView *)mainFuncView {
    if (!_mainFuncView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake((WIDTH-30)/3, 85);
        flowLayout.minimumInteritemSpacing = 5;
        
        _mainFuncView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 100) collectionViewLayout:flowLayout];
        _mainFuncView.delegate = self;
        _mainFuncView.dataSource = self;
        _mainFuncView.bounces = NO;
        _mainFuncView.scrollEnabled = NO;
        _mainFuncView.showsVerticalScrollIndicator = NO;
        _mainFuncView.showsHorizontalScrollIndicator = NO;
        _mainFuncView.backgroundColor = WhiteColor;
        
        [_mainFuncView registerClass:[MainFuncCell class] forCellWithReuseIdentifier:MainFuncCellIdentifier];
    }
    return _mainFuncView;
}

- (SDCycleScrollView *)picScrollView {
    if (!_picScrollView) {
        _picScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 180*biliHeight)];
        _picScrollView.infiniteLoop = YES;
        _picScrollView.autoScroll = YES;
        _picScrollView.showPageControl = YES;
        _picScrollView.pageControlStyle =SDCycleScrollViewPageContolStyleAnimated;
        _picScrollView.autoScrollTimeInterval = 4;
        _picScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    }
    return _picScrollView;
}

- (UITableView *)contentTableView {
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 100+WIDTH/2.25)];
        _contentTableView.backgroundColor = MyBackColor;
        [_contentTableView setTableHeaderView:view];
    }
    return _contentTableView;
}

#pragma mark - life cycle
/**
 *  视图加载数据
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StartPageAnimationFinished:) name:kTBStartPageShowCompletionNotification object:nil];
    
    [self checkLogin];
    [self configView];
    _imagesUrlList = [[NSMutableArray alloc] init];
    
    [self getInitData];
    [self getImagesUrl:@"CarouselIndex"];
    __weak MainViewController *wself = self;
    self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        wself.picScrollView.imageURLStringsGroup = wself.imagesUrlList;
        [wself.contentTableView.mj_header endRefreshing];
    }];

}

-(void)viewWillAppear:(BOOL)animated{
    [self createNav];
    [self loadMyHeadImg];
    _IsReadNewsArr = [[UseFMDBTool sharedInstance]user:USERID newsOrNotice:@"0"];
    _IsReadNoticesArr = [[UseFMDBTool sharedInstance]user:USERID newsOrNotice:@"1"];
    [_mainFuncView reloadData];
//    [[IQKeyboardManager sharedManager] setEnable:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTBStartPageShowCompletionNotification object:nil];
    DLog(@"主页页面已销毁");
}
#pragma mark - Notification Action
- (void)StartPageAnimationFinished:(NSNotification *)notification {
    if (APPDELEGATE.automaticLogin) {
        if (self.autoLoginState == AutoLoginStateFailed) {
            [AppDelegate setRootViewController:APPDELEGATE.loginNavc fromController:self isLogin:NO];
        }
    }
}
#pragma mark - getBaseInfo
-(void)getInitData{
    _newsNum = SZLInfoHelperManager.totalNews;
    _notictNum = SZLInfoHelperManager.totalNotices;
    
}
#pragma mark - create ConfigView
/**
 *  创建navBar
 */
-(void)loadMyHeadImg{
    _userInfo = [[UserBaseInfoModel alloc] initWithDictionary:SZLInfoHelperManager.userBaseInfo];
    NSURL* headImgUrl =  [NSURL URLWithString:_userInfo.user_pic];
    __weak MainViewController *wself = self;
//    [[SDWebImageManager sharedManager] downloadImageWithURL:headImgUrl options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        if (image) {
//            wself.myHeadImg = image;
//        }else{
//            wself.myHeadImg = [UIImage imageNamed:@"ic_avatar_default"];
//        }
//        
//        SZLNaviBarBtnItem *mySettingBtn = [SZLNaviBarBtnItem buttonWithImageNormal:self.myHeadImg imageSelected:self.myHeadImg];
//        [mySettingBtn addTarget:self
//                         action:@selector(rightButtonTouch)
//               forControlEvents:UIControlEventTouchUpInside];
//        
//        mySettingBtn.layer.cornerRadius = mySettingBtn.bounds.size.height * 0.5;
//        mySettingBtn.layer.masksToBounds = YES;
//        
//        wself.navigationRightButton = mySettingBtn;
//        
//    }];
    
    
    [[SDWebImageManager sharedManager] loadImageWithURL:headImgUrl options:SDWebImageHighPriority progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (image) {
            wself.myHeadImg = image;
        }else{
            wself.myHeadImg = [UIImage imageNamed:@"ic_avatar_default"];
        }
        
        SZLNaviBarBtnItem *mySettingBtn = [SZLNaviBarBtnItem buttonWithImageNormal:self.myHeadImg imageSelected:self.myHeadImg];
        [mySettingBtn addTarget:self
                         action:@selector(rightButtonTouch)
               forControlEvents:UIControlEventTouchUpInside];
        
        mySettingBtn.layer.cornerRadius = mySettingBtn.bounds.size.height * 0.5;
        mySettingBtn.layer.masksToBounds = YES;
        
        wself.navigationRightButton = mySettingBtn;
    }];
    

}


-(void)createNav{
    self.navigationTitle = @"在线考试系统";
    
}
- (void)configView {
    self.navigationLeftButton.hidden = YES;
    
    [self.contentView addSubview:self.contentTableView];
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(@0);
    }];
    
    [self.contentTableView.tableHeaderView addSubview:self.picScrollView];
    [self.picScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.height.equalTo(WIDTH/2.25);
    }];
    
    [self.contentTableView.tableHeaderView addSubview:self.mainFuncView];
    [self.mainFuncView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_offset(UIEdgeInsetsMake(WIDTH/2.25 +15, 10, 0, 10));
        
    }];
}





#pragma mark - button Action
- (void)rightButtonTouch
{
    MySettingVC *mysettingView = [[MySettingVC alloc] init];
    mysettingView.userheadImg = self.myHeadImg;
    [self.navigationController pushViewController:mysettingView animated:YES];
}

//
- (void)checkLogin {
    
    LoginInfoDomain * domain = [[LoginInfoDomain alloc]initWithDictionary:SZLInfoHelperManager.userInfoArr.firstObject];
    NSDictionary *prama = @{
                            @"servletname":@"Login",
                            @"userName":domain.userName,
                            @"userPwd":domain.password
                            };
    
    if (domain.autoLogin && APPDELEGATE.automaticLogin) {
        if (kNetworkNotReachability) {
            [self.view makeToast:kError_Network_NotReachable];
            return;
        }
        __weak MainViewController * wself = self;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [SZLServerHelper userLoginRequest:prama callback:^(NSInteger errCode, ApiResponse *response, BOOL success) {
                
                if (success) {
                    NSDictionary* rootDict = response.data;
                    
                    DLog(@"rootDict:%@",rootDict);
                    NSDictionary *userBaseInfo = [rootDict objectForKey:@"dtUserInfo"];
                    NSString *userId = [userBaseInfo objectForKey:@"USER_ID"];
                    wself.autoLoginState = AutoLoginStateSucceed;
                    SZLInfoHelperManager.userBaseInfo = userBaseInfo;
                    SZLInfoHelperManager.userId = userId;
                    SZLInfoHelperManager.totalNews = [[rootDict objectForKey:@"News"] integerValue];
                    SZLInfoHelperManager.totalNotices = [[rootDict objectForKey:@"Notice"] integerValue];
                    wself.newsNum = SZLInfoHelperManager.totalNews;
                    wself.notictNum = SZLInfoHelperManager.totalNotices;
                    APPDELEGATE.automaticLogin = YES;
                }else{
                    wself.autoLoginState = AutoLoginStateFailed;
                    [wself.view makeToast:response.errDesc];
                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        wself.hud = [[MBProgressHUD alloc] initWithView:wself.view];
//                        [wself.view addSubview:wself.hud];
//                        wself.hud.mode = MBProgressHUDModeText;
//                        wself.hud.labelText = response.errDesc;
//                        wself.hud.margin = 10.f;
//                        [wself.hud showAnimated:YES whileExecutingBlock:^{
//                            sleep(1.5f);
//                        } completionBlock:^{  
//                            [wself.hud removeFromSuperview];
//                            [AppDelegate setRootViewController:APPDELEGATE.loginNavc fromController:wself isLogin:NO];
//                        }];
//                    });
                    
                }
            }];
        });
    }
}




/**
 *  获取主页的轮播图地址
 *
 *  @param urlString 网络请求地址
 */
-(void)getImagesUrl:(NSString *)urlString
{
    __weak MainViewController * wself = self;
    if (kNetworkNotReachability) {
        [self.view makeToast:kError_Network_NotReachable];
        return;
    }
    NSDictionary *prama = @{
                            @"servletname":urlString,
                            };
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __block ApiRequest* request = [SZLServerHelper getImgUrlRequest:prama callback:^(NSInteger errCode, ApiResponse *response, BOOL success) {
            [wself.requestArr removeObject:request];
            if (success) {
                NSMutableDictionary *data = response.data;
                NSMutableArray *imagesUrl = [data objectForKey:@"Imgs"];
                for (NSDictionary *imgs in imagesUrl) {
                    NSString*imgurl = [[imgs objectForKey:@"url"] stringByReplacingOccurrencesOfString:@"~" withString:webserviceUrl];
                    [wself.imagesUrlList addObject:imgurl];
                    
                }
                wself.picScrollView.imageURLStringsGroup = wself.imagesUrlList;
            }else{
                [wself.view makeToast:response.errDesc];
            }
            [wself.mainFuncView reloadData];
        }];
        [wself.requestArr addObject:request];
    });

}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"CourseDisplayCell";
    CourseDisplayCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [CourseDisplayCell loadCourseDisplayCell];;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(CourseDisplayCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CourseDisplayCell loadCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .001f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
#pragma mark - UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.mainFuncView) {
        return 3;
    }
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.mainFuncView) {
       
        UINib *nib = [UINib nibWithNibName:@"MainFuncCell" bundle: [NSBundle mainBundle]];
        [collectionView registerNib:nib forCellWithReuseIdentifier:MainFuncCellIdentifier];
        
        MainFuncCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MainFuncCellIdentifier forIndexPath:indexPath];
 
        [cell configFuncDetailWithIndexPath:indexPath];
        if (indexPath.row == 0) {
             NSInteger minus = self.newsNum - _IsReadNewsArr.count;
            if (minus > 99) {
                cell.noticeNumLabel.text = [NSString stringWithFormat:@"%@",@"..."];
                
                cell.noticeNumBg.image = [UIImage imageNamed:@"ic_main_num"];
            }else if (minus > 0) {
                cell.noticeNumLabel.text = [NSString stringWithFormat:@"%lu",self.newsNum - _IsReadNewsArr.count];
                
                cell.noticeNumBg.image = [UIImage imageNamed:@"ic_main_num"];
            }else{
                cell.noticeNumBg.image = nil;
                cell.noticeNumLabel.text = nil;
                
            }
        }else if (indexPath.row == 1){
            NSInteger minus = self.notictNum - self.IsReadNoticesArr.count;
            if (minus > 99) {
                
                 DLog(@"self.notictNum - _IsReadNoticesArr.count----:%ld",self.notictNum - _IsReadNoticesArr.count);
                
                cell.noticeNumLabel.text = [NSString stringWithFormat:@"%@",@"..."];
                
                cell.noticeNumBg.image = [UIImage imageNamed:@"ic_main_num"];
            }else if (minus > 0) {
                cell.noticeNumLabel.text = [NSString stringWithFormat:@"%lu",self.notictNum - _IsReadNoticesArr.count];
                
                cell.noticeNumBg.image = [UIImage imageNamed:@"ic_main_num"];
            }else{
                cell.noticeNumBg.image = nil;
                cell.noticeNumLabel.text = nil;
                
            }
        
        }else{
            cell.noticeNumBg.image = nil;
            cell.noticeNumLabel.text = nil;
        }
        
        
        
        
        
        return cell;
    }
    UINib *nib = [UINib nibWithNibName:@"CourseDetailCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:CourseDetailCellIdentifier];
    
    CourseDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CourseDetailCellIdentifier forIndexPath:indexPath];
    [cell configFuncDetailWithIndexPath:indexPath];
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
    if (collectionView == self.mainFuncView) {
        [self mainFunctionAction:indexPath];
        
        
    }else{
        [self JumpToSelectView:indexPath];
    }
    
    
    
}


#pragma mark - private Action
- (void)mainFunctionAction:(NSIndexPath *)indexPath {

    if (indexPath.row==0) {
        NewsViewController *newsAndNoticeVC = [[NewsViewController alloc] init];
        newsAndNoticeVC.newsOrNoticeType = [NSString stringWithFormat:@"%ld",indexPath.row];
        newsAndNoticeVC.newsOrNoticesNum = _newsNum;
        
        [self.navigationController pushViewController:newsAndNoticeVC animated:YES];
    }else if (indexPath.row==1) {
        NewsViewController *newsAndNoticeVC = [[NewsViewController alloc] init];
        newsAndNoticeVC.newsOrNoticeType = [NSString stringWithFormat:@"%ld",indexPath.row];
        newsAndNoticeVC.newsOrNoticesNum = self.notictNum;
        
        [self.navigationController pushViewController:newsAndNoticeVC animated:YES];
    }else{
        VoteListViewController *next = [[VoteListViewController alloc] init];
        
        [self.navigationController pushViewController:next animated:YES];
    }
    
    
    
}


#pragma mark - private Action
- (void)JumpToSelectView:(NSIndexPath *)indexPath {
    NSArray * desVcs = @[@"MyExamsViewController",
                         @"MyPracticesViewController",
                         @"MyGradeViewController",
                         @"MyErrorsViewController",
                         @"MyCollectionViewController",
                         @"ErrorAnalysisViewController"];
    Class cls = NSClassFromString(desVcs[indexPath.row]);
    SZLBaseVC * bvc = [[cls alloc]init];
    [self.navigationController pushViewController:bvc animated:YES];
    
}


@end
