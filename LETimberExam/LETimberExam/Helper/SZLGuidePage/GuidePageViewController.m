//
//  GuidePageViewController.m
//  SZLTimberTrain
//
//  Created by Apple on 16/9/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "GuidePageViewController.h"
#import "StyledPageControl.h"

@interface GuidePageViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView * guideScrollView;
@property (nonatomic, strong) UIButton * skipBtn;
@property (nonatomic, strong) StyledPageControl * pageControl;
@property (nonatomic, strong) UIButton * enterBtn;

@end

@implementation GuidePageViewController

#pragma mark - Lazy Loading
- (UIButton *)enterBtn {
    if (!_enterBtn) {
        _enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterBtn.hidden = YES;
        [_enterBtn setTitle:@"开始体验" forState:UIControlStateNormal];
        [_enterBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [_enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_enterBtn setBackgroundImage:[UIImage imageNamed:@"ic_guide_enter"] forState:UIControlStateNormal];
        [_enterBtn addTarget:self action:@selector(skipBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterBtn;
}

- (UIButton *)skipBtn {
    if (!_skipBtn) {
        _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
        [_skipBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_skipBtn.layer setCornerRadius:12.0f];
        [_skipBtn addTarget:self action:@selector(skipBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_skipBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:.1f]];
    }
    return _skipBtn;
}

- (StyledPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[StyledPageControl alloc]initWithFrame:CGRectMake(0, HEIGHT - (60/480.0)*HEIGHT, WIDTH, 50)];
        [_pageControl setUserInteractionEnabled:NO];
        [_pageControl setPageControlStyle:PageControlStyleThumb];
        [_pageControl setNumberOfPages:self.guideImages.count];
        [_pageControl setThumbImage:[UIImage imageNamed:@"ic_pagecontrol_normal"]];
        [_pageControl setSelectedThumbImage:[UIImage imageNamed:@"ic_pagecontrol_selected"]];
    }
    return _pageControl;
}

- (UIScrollView *)guideScrollView {
    if (!_guideScrollView) {
        _guideScrollView = [[UIScrollView alloc]init];
        _guideScrollView.contentSize = CGSizeMake(WIDTH * self.guideImages.count, HEIGHT);
        _guideScrollView.pagingEnabled = YES;
        _guideScrollView.showsHorizontalScrollIndicator = NO;
        _guideScrollView.showsVerticalScrollIndicator = NO;
        _guideScrollView.alwaysBounceVertical = NO;
        _guideScrollView.alwaysBounceHorizontal = NO;
        _guideScrollView.bounces = NO;
        _guideScrollView.delegate = self;
    }
    return _guideScrollView;
}

- (id)initWithGuideImages:(NSArray *)images {
    if (self = [super init]) {
        self.guideImages = images;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:MyNavColor];
    [self configView];
}

- (void)configView {
    [self.view addSubview:self.guideScrollView];
    [self.guideScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.view addSubview:self.pageControl];
    
    for (int i = 0; i < self.guideImages.count; i++) {
        UIImageView * guideImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.guideImages[i]]];
        guideImageView.contentMode = UIViewContentModeScaleAspectFill;
        guideImageView.userInteractionEnabled = YES;
        guideImageView.frame = CGRectMake(i * WIDTH, 0, WIDTH, HEIGHT);
        [self.guideScrollView addSubview:guideImageView];
        if (i == self.guideImages.count - 1) {
            [guideImageView addSubview:self.enterBtn];
            [self.enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(guideImageView.centerX);
                make.width.equalTo(@184);
                make.height.equalTo(@35);
                make.bottom.equalTo(-(30/480.0)*HEIGHT);
            }];
        }
    }

    [self.view addSubview:self.skipBtn];
    [self.skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@24);
        make.trailing.equalTo(@-18);
        make.width.equalTo(@48);
        make.height.equalTo(@24);
    }];
    
    

}

#pragma mark - Private Action
- (void)skipBtnAction:(UIButton *)sender {
    SZLInfoHelperManager.isFirstInstall = NO;
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [AppDelegate setRootViewController:APPDELEGATE.loginNavc fromController:self isLogin:NO];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int page = scrollView.contentOffset.x / WIDTH;
    [self.pageControl setCurrentPage:page];
    if (page == 3) {
        self.pageControl.hidden = YES;
        self.enterBtn.hidden = NO;
    }else{
        self.pageControl.hidden = NO;
        self.enterBtn.hidden = YES;
    }
    
    
}

@end
