//
//  SZLStartPageView.m
//  SZLTimberTrain
//
//  Created by Apple on 16/11/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SZLStartPageView.h"

@interface SZLStartPageView () {
    NSTimer * _cutdownTimer;
    NSInteger _totalTime;
}

@property (nonatomic, strong) UIImageView * launchImageView;
@property (nonatomic, strong) UIButton * skipBtn;

@end

@implementation SZLStartPageView

#pragma mark - setter & getter
- (UIImageView *)launchImageView {
    if (!_launchImageView) {
        _launchImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"launch_img"]];
        _launchImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _launchImageView;
}

- (UIButton *)skipBtn {
    if (!_skipBtn) {
        _skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_skipBtn setTitle:[NSString stringWithFormat:@"%@秒", @(_totalTime)] forState:UIControlStateNormal];
        [_skipBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_skipBtn.layer setCornerRadius:12.0f];
        [_skipBtn addTarget:self action:@selector(skipBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_skipBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:.4f]];
    }
    return _skipBtn;
}

- (id)init {
    if (self = [super init]) {
        [self initialData];
        [self configView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialData];
        [self configView];
    }
    return self;
}

- (void)initialData {
    _totalTime = 3;
}

- (void)configView {
    [self addSubview:self.launchImageView];
    [self.launchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.centerY.equalTo(self.centerY);
        make.top.equalTo(@0);
        make.leading.trailing.equalTo(@0);
    }];
    
    [self addSubview:self.skipBtn];
    [self.skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@24);
        make.trailing.equalTo(@-18);
        make.width.equalTo(@48);
        make.height.equalTo(@24);
    }];
}

#pragma mark - Public Actions
- (void)showInView:(UIView *)view animated:(BOOL)animated {
    NSString * imgURL = [SZLStartPageManager sharedInstance].imgURL;
    
    if (imgURL && imgURL.length>0) {
        UIImage * startImage = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:imgURL];
        if (startImage) {
            self.launchImageView.image = startImage;
        }
    }else{
        self.launchImageView.image = [UIImage imageNamed:@"launch_img"];
    }
    
    if (!_cutdownTimer) {
        _cutdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(cutdownTimerEvent:) userInfo:nil repeats:YES];
    }
    [self updateTimeRemainContentWithTime:_totalTime--];
    
    [view addSubview:self];
}

- (void)showInView:(UIView *)view animated:(BOOL)animated completeBlock:(void (^)(void (^callback)()))completeBlock {
    self.completeBlock = completeBlock;
    
    [self showInView:view animated:YES];
}

- (void)dismissWithAnimated:(BOOL)animated {
    if ([_cutdownTimer isValid]) {
        [_cutdownTimer invalidate];
        _cutdownTimer = nil;
    }
    
    if ([self superview]) {
        
        if (_completeBlock) {
            __weak SZLStartPageView * wself = self;
            self.completeBlock(^(){
                [wself removeFromSuperview];
            });
        }else {
            [self removeFromSuperview];
        }
    }
}

#pragma mark - Private Actions
- (void)skipBtnAction:(UIButton *)sender {
    [self dismissWithAnimated:YES];
}

- (void)cutdownTimerEvent:(NSTimer *)timer {
    
    [self updateTimeRemainContentWithTime:_totalTime--];
    
    if (_totalTime <= 0) {
        if ([_cutdownTimer isValid]) {
            [_cutdownTimer invalidate];
            _cutdownTimer = nil;
        }
        
        // 计时结束
        [self dismissWithAnimated:YES];
    }
}

- (void)updateTimeRemainContentWithTime:(NSInteger)time {
    NSMutableAttributedString * timeRemainStr;
    
    NSString * status = [NSString stringWithFormat:@"%@秒", @(time)];
    
    timeRemainStr = [[NSMutableAttributedString alloc] initWithString:status];
    
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    
    [timeRemainStr addAttributes:@{
                                   NSFontAttributeName: [UIFont systemFontOfSize:13],
                                   NSParagraphStyleAttributeName:paragraph,
                                   NSForegroundColorAttributeName:RGBColor(255, 255, 255, 1)}
                           range:NSMakeRange(0, status.length - 1)];
    
    [timeRemainStr addAttributes:@{
                                   NSFontAttributeName: [UIFont systemFontOfSize:10],
                                   NSForegroundColorAttributeName:RGBColor(255, 255, 255, 1)}
                           range:NSMakeRange(status.length - 1, 1)];
    [self.skipBtn.titleLabel setAttributedText:timeRemainStr];
}

@end
