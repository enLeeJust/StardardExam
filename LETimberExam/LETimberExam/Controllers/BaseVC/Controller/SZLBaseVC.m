////
////  SZLBaseVC.m
////  SZLTimberTrain
////
////  Created by Apple on 16/9/5.
////  Copyright © 2016年 Apple. All rights reserved.
////
//
//#import "SZLBaseVC.h"
//#import "SZLNaviBarBtnItem.h"
//
//@implementation SZLBaseVC
//
//-(NSMutableArray *)requestArr{
//    if (!_requestArr) {
//        _requestArr = [NSMutableArray array];
//    }
//    return _requestArr;
//}
//
//- (UIView *)contentView {
//    if (!_contentView) {
//        _contentView = [[UIView alloc]initWithFrame:CGRectZero];
//        _contentView.backgroundColor = MyBackColor;
//    }
//    return _contentView;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    //边缘不留白
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//
//    [self createNavigationViewDependDevice];
//    [self createContentView];
//    [self createBackBtn];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//-(void)dealloc{
//    for (ApiRequest *request in self.requestArr) {
//        if (request.task.state == NSURLSessionTaskStateRunning) {
//            [request.task cancel];
//        }
//    }
//
//}
//
//#pragma mark - 创建导航栏视图
//- (void)createNavigationViewDependDevice{
//    //初始化navigationView并添加
//    self.navigationController.navigationBarHidden = YES;
//    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
//    self.navigationView.backgroundColor = MyNavColor;
////    self.navigationView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@""]];
//
//    [self.view addSubview:self.navigationView];
//}
//
//#pragma mark - 创建内容视图
//- (void)createContentView {
//    [self.view addSubview:self.contentView];
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@64);
//        make.leading.trailing.bottom.equalTo(@0);
//    }];
//}
//
//#pragma mark - 改变导航栏背景透明度
//- (void)setNavigationAlpha:(CGFloat)navigationAlpha{
//    self.navigationView.backgroundColor = [self.navigationView.backgroundColor colorWithAlphaComponent:navigationAlpha];
//}
//
//#pragma mark - 改变导航栏颜色
//- (void)setNavigationBackgroundColor:(UIColor *)navigationBackgroundColor{
//    self.navigationView.backgroundColor = navigationBackgroundColor;
//}
//
//#pragma mark - 设置导航栏标题
//- (void)setNavigationTitle:(NSString *)navigationTitle{
//    //    根据文本计算宽度
//    CGSize labelSize = [navigationTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
//
//    //初始化labelTitle并调整位置
//    if (labelSize.width > WIDTH) {
//        labelSize.width = WIDTH;
//    }
//    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelSize.width, 42)];
//    CGPoint center = self.navigationView.center;
//    center.y = center.y + 8;
//    labelTitle.center = center;
//
//    //文字基本设置
//    labelTitle.textColor = [UIColor whiteColor];
//    labelTitle.numberOfLines = 1;
//    labelTitle.lineBreakMode = NSLineBreakByTruncatingTail;
//    labelTitle.textAlignment = NSTextAlignmentCenter;
//    labelTitle.font = [UIFont boldSystemFontOfSize:18.0f];
//    labelTitle.text = @"";
//    labelTitle.text = navigationTitle;
//    [self.navigationView addSubview:labelTitle];
//}
//
//#pragma mark - 自定义导航栏标题位置视图
//- (void)setNavigationTitleView:(UIControl *)navigationTitleView{
//    CGPoint titleView;
//    titleView.x = WIDTH / 2;
//    titleView.y = self.navigationView.frame.size.height / 2 + 7;
//    navigationTitleView.center = titleView;
//
//    [self.navigationView addSubview:navigationTitleView];
//}
//
//#pragma mark - 添加导航栏左侧按钮
//- (void)setNavigationLeftButton:(UIButton *)navigationLeftButton{
//    _navigationLeftButton = navigationLeftButton;
//
//    //判断是文字按钮还是图片按钮，两者坐标稍有不同
//    CGFloat leftButtonWidth = navigationLeftButton.frame.size.width;
//    CGFloat leftButtonHeight = navigationLeftButton.frame.size.height;
//
//    navigationLeftButton.frame = CGRectMake(10, self.navigationView.frame.size.height / 2 - 8, leftButtonWidth, leftButtonHeight);
//
//    [self.navigationView addSubview:navigationLeftButton];
//}
//
//#pragma mark - 添加导航栏右侧按钮
//- (void)setNavigationRightButton:(UIButton *)navigationRightButton{
//    //同上
//    CGFloat rightButtonWidth = navigationRightButton.frame.size.width;
//    CGFloat rightButtonHeight = navigationRightButton.frame.size.height;
//
//    navigationRightButton.frame = CGRectMake(WIDTH - navigationRightButton.frame.size.width - 10, self.navigationView.frame.size.height / 2 - 8, rightButtonWidth, rightButtonHeight);
//
//    [self.navigationView addSubview:navigationRightButton];
//}
//
//#pragma mark - 添加导航栏左侧按钮集合
//- (void)setNavigationLeftButtons:(NSArray<UIButton *> *)navigationLeftButtons{
//    CGFloat firstLeftButtonWidth = navigationLeftButtons[0].frame.size.width;
//    CGFloat firstLeftButtonHeight = navigationLeftButtons[0].frame.size.height;
//
//    CGFloat secondLeftButtonWidth = navigationLeftButtons[1].frame.size.width;
//    CGFloat secondLeftButtonHeight = navigationLeftButtons[1].frame.size.height;
//
//    navigationLeftButtons[0].frame = CGRectMake(10, self.navigationView.frame.size.height / 2 - 8, firstLeftButtonWidth, firstLeftButtonHeight);
//    navigationLeftButtons[1].frame = CGRectMake(10 + firstLeftButtonWidth + 8, self.navigationView.frame.size.height / 2 - 8, secondLeftButtonWidth, secondLeftButtonHeight);
//    //8为两个按钮之间的间隔
//
//    [self.navigationView addSubview:navigationLeftButtons[0]];
//    [self.navigationView addSubview:navigationLeftButtons[1]];
//}
//
//#pragma mark - 添加导航栏右侧按钮集合
//- (void)setNavigationRightButtons:(NSArray<UIButton *> *)navigationRightButtons{
//    CGFloat firstRightButtonWidth = navigationRightButtons[0].frame.size.width;
//    CGFloat firstRightButtonHeight = navigationRightButtons[0].frame.size.height;
//
//    CGFloat secondRightButtonWidth = navigationRightButtons[1].frame.size.width;
//    CGFloat secondRightButtonHeight = navigationRightButtons[1].frame.size.height;
//
//    navigationRightButtons[0].frame = CGRectMake(WIDTH - 10 - firstRightButtonWidth, self.navigationView.frame.size.height / 2 - 8, firstRightButtonWidth, firstRightButtonHeight);
//    navigationRightButtons[1].frame = CGRectMake(WIDTH - 10 - firstRightButtonWidth - 8 - secondRightButtonWidth, self.navigationView.frame.size.height / 2 - 8, secondRightButtonWidth, secondRightButtonHeight);
//    //8为两个按钮之间的间隔
//
//    [self.navigationView addSubview:navigationRightButtons[0]];
//    [self.navigationView addSubview:navigationRightButtons[1]];
//}
//
//- (void)createBackBtn {
//    SZLNaviBarBtnItem *backButton = [SZLNaviBarBtnItem buttonWithImageNormal:[UIImage imageNamed:@"icon_back"]
//                                                             imageSelected:[UIImage imageNamed:@"icon_back"]];
////    [backButton addTarget:self
////                   action:@selector(buttonBackToLastView)
////         forControlEvents:UIControlEventTouchUpInside];
//
//    self.navigationLeftButton = backButton;
//}
//- (void)buttonBackToLastView{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//
//
//@end
//
//  SZLBaseVC.m
//  SZLTimberTrain
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SZLBaseVC.h"
#import "SZLNaviBarBtnItem.h"

@implementation SZLBaseVC

- (NSMutableArray *)requestArr {
    if (!_requestArr) {
        _requestArr = [NSMutableArray array];
    }
    return _requestArr;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectZero];
        _contentView.backgroundColor = MyBackColor;
    }
    return _contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //边缘不留白
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self createNavigationViewDependDevice];
    [self createContentView];
    [self createBackBtn];
}

- (void)dealloc {
    for (ApiRequest * request in self.requestArr) {
        if (request.task.state == NSURLSessionTaskStateRunning) {
            [request.task cancel];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建导航栏视图
- (void)createNavigationViewDependDevice{
    //初始化navigationView并添加
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, NavHeight)];
    self.navigationView.backgroundColor = MyNavColor;
    
    [self.view addSubview:self.navigationView];
}

#pragma mark - 创建内容视图
- (void)createContentView {
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NavHeight);
        make.leading.trailing.bottom.equalTo(0);
    }];
}

#pragma mark - 改变导航栏背景透明度
- (void)setNavigationAlpha:(CGFloat)navigationAlpha{
    self.navigationView.backgroundColor = [self.navigationView.backgroundColor colorWithAlphaComponent:navigationAlpha];
}

#pragma mark - 改变导航栏颜色
- (void)setNavigationBackgroundColor:(UIColor *)navigationBackgroundColor{
    self.navigationView.backgroundColor = navigationBackgroundColor;
}

#pragma mark - 设置导航栏标题
- (void)setNavigationTitle:(NSString *)navigationTitle{
    [self.navigationTitleLabel removeFromSuperview];
    self.navigationTitleLabel = nil;
    
    //    根据文本计算宽度
    CGSize labelSize = [navigationTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]}];
    
    //初始化labelTitle并调整位置
    if (labelSize.width > WIDTH) {
        labelSize.width = WIDTH;
    }
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(80, StatusHeight, WIDTH-80*2, NavBarHeight)];
    self.navigationTitleLabel = label;
    
    
    //文字基本设置
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 1;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:18.0f];
    label.text = navigationTitle;
    [self.navigationView addSubview:label];
}

#pragma mark - 自定义导航栏标题位置视图
- (void)setNavigationTitleView:(UIControl *)navigationTitleView{
    //    CGPoint titleView;
    //    titleView.x = WIDTH / 2;
    //    titleView.y = self.navigationView.frame.size.height / 2 + 7;
    //    navigationTitleView.center = titleView;
    
    CGRect frame = navigationTitleView.frame;
    frame.origin.x = (WIDTH - frame.size.width)/2;
    frame.origin.y = StatusHeight + (NavBarHeight-frame.size.height)/2;
    navigationTitleView.frame = frame;
    
    [self.navigationView addSubview:navigationTitleView];
}

#pragma mark - 添加导航栏左侧按钮
- (void)setNavigationLeftButton:(UIButton *)navigationLeftButton{
    _navigationLeftButton = navigationLeftButton;
    
    //判断是文字按钮还是图片按钮，两者坐标稍有不同
    CGFloat leftButtonWidth = navigationLeftButton.frame.size.width;
    CGFloat leftButtonHeight = navigationLeftButton.frame.size.height;
    
    navigationLeftButton.frame = CGRectMake(10, StatusHeight+(NavBarHeight-leftButtonHeight)/2, leftButtonWidth, leftButtonHeight);
    
    [self.navigationView addSubview:navigationLeftButton];
}

#pragma mark - 添加导航栏右侧按钮
- (void)setNavigationRightButton:(UIButton *)navigationRightButton{
    //同上
    CGFloat rightButtonWidth = navigationRightButton.frame.size.width;
    CGFloat rightButtonHeight = navigationRightButton.frame.size.height;
    
    navigationRightButton.frame = CGRectMake(WIDTH - navigationRightButton.frame.size.width - 10, StatusHeight+(NavBarHeight-rightButtonHeight)/2, rightButtonWidth, rightButtonHeight);
    
    [self.navigationView addSubview:navigationRightButton];
}

#pragma mark - 添加导航栏左侧按钮集合
- (void)setNavigationLeftButtons:(NSArray<UIButton *> *)navigationLeftButtons{
    CGFloat firstLeftButtonWidth = navigationLeftButtons[0].frame.size.width;
    CGFloat firstLeftButtonHeight = navigationLeftButtons[0].frame.size.height;
    
    CGFloat secondLeftButtonWidth = navigationLeftButtons[1].frame.size.width;
    CGFloat secondLeftButtonHeight = navigationLeftButtons[1].frame.size.height;
    
    navigationLeftButtons[0].frame = CGRectMake(10, StatusHeight+(NavBarHeight-firstLeftButtonHeight)/2, firstLeftButtonWidth, firstLeftButtonHeight);
    navigationLeftButtons[1].frame = CGRectMake(10 + firstLeftButtonWidth + 8, StatusHeight+(NavBarHeight-secondLeftButtonHeight)/2, secondLeftButtonWidth, secondLeftButtonHeight);
    //8为两个按钮之间的间隔
    
    [self.navigationView addSubview:navigationLeftButtons[0]];
    [self.navigationView addSubview:navigationLeftButtons[1]];
}

#pragma mark - 添加导航栏右侧按钮集合
- (void)setNavigationRightButtons:(NSArray<UIButton *> *)navigationRightButtons{
    CGFloat firstRightButtonWidth = navigationRightButtons[0].frame.size.width;
    CGFloat firstRightButtonHeight = navigationRightButtons[0].frame.size.height;
    
    CGFloat secondRightButtonWidth = navigationRightButtons[1].frame.size.width;
    CGFloat secondRightButtonHeight = navigationRightButtons[1].frame.size.height;
    
    navigationRightButtons[0].frame = CGRectMake(WIDTH - 10 - firstRightButtonWidth, StatusHeight+(NavBarHeight-firstRightButtonHeight)/2, firstRightButtonWidth, firstRightButtonHeight);
    navigationRightButtons[1].frame = CGRectMake(WIDTH - 10 - firstRightButtonWidth - 8 - secondRightButtonWidth, StatusHeight+(NavBarHeight-secondRightButtonHeight)/2, secondRightButtonWidth, secondRightButtonHeight);
    //8为两个按钮之间的间隔
    
    [self.navigationView addSubview:navigationRightButtons[0]];
    [self.navigationView addSubview:navigationRightButtons[1]];
}

- (void)createBackBtn {
    SZLNaviBarBtnItem *backButton = [SZLNaviBarBtnItem buttonWithImageNormal:[UIImage imageNamed:@"icon_back"]
                                                               imageSelected:[UIImage imageNamed:@"icon_back"]];
    [backButton addTarget:self
                   action:@selector(buttonBackToLastView)
         forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationLeftButton = backButton;
}
- (void)buttonBackToLastView{
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(NSString*)title
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
