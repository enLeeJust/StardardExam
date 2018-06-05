//
//  SignInViewController.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/9.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "SignInViewController.h"
#import "STCalendar.h"

@interface SignInViewController ()

@property (nonatomic, strong) UIImageView * backgroundImageView;
@property (nonatomic, strong) UIView * backColorView;
@property (nonatomic, strong) UILabel * currentDateLabel;
@property (nonatomic, strong) UIButton * lastBtn;
@property (nonatomic, strong) UIButton * nextBtn;
@property (nonatomic, strong) UIButton * checkBtn;
@property (nonatomic, strong) UILabel * tipLabel;

@property (nonatomic, strong) STCalendar * calendarView;

@property (nonatomic, strong) NSMutableArray * daysArr;

@end

@implementation SignInViewController

- (NSMutableArray *)daysArr {
    if (!_daysArr) {
        _daysArr = @[@"1", @"3", @"4", @"11"].mutableCopy;
    }
    return _daysArr;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.textColor = [UIColor lightGrayColor];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:14.0f];
        _tipLabel.text = @"已经连续登陆--天";
    }
    return _tipLabel;
}

- (UIButton *)checkBtn {
    if (!_checkBtn) {
        _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBtn setExclusiveTouch:NO];
        [_checkBtn setBackgroundImage:[UIImage imageNamed:@"ic_check_btn"] forState:UIControlStateNormal];
        [_checkBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [_checkBtn setTitle:@"点击签到" forState:UIControlStateNormal];
        [_checkBtn addTarget:self action:@selector(checkConfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBtn;
}

- (STCalendar *)calendarView {
    if (!_calendarView) {
        _calendarView = [[STCalendar alloc]initWithFrame:CGRectMake(24, 70/*30+(WIDTH-2*12)*(448.0/456.0)*(101.0/456.0)*/, WIDTH-48, self.backgroundImageView.v_height-self.backColorView.v_bottom)];
        _calendarView.backgroundColor = [UIColor clearColor];
        __weak SignInViewController * wself = self;
        [_calendarView returnDate:^(NSString * _Nullable stringDate) {
            wself.currentDateLabel.text = stringDate;
        }];
        [_calendarView setTextSelectedColor:MyOrangeColor];
    }
    return _calendarView;
}

- (UILabel *)currentDateLabel {
    if (!_currentDateLabel) {
        _currentDateLabel = [[UILabel alloc]init];
        _currentDateLabel.textAlignment = NSTextAlignmentCenter;
        _currentDateLabel.textColor = WhiteColor;
        _currentDateLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        _currentDateLabel.text = @"2016年9月";
    }
    return _currentDateLabel;
}

- (UIButton *)lastBtn {
    if (!_lastBtn) {
        _lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lastBtn.tag = 101;
        [_lastBtn setExclusiveTouch:NO];
        [_lastBtn setImage:[UIImage imageNamed:@"ic_check_left"] forState:UIControlStateNormal];
        [_lastBtn addTarget:self action:@selector(changeCurrentMonthAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lastBtn;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.tag = 102;
        [_nextBtn setExclusiveTouch:NO];
        [_nextBtn setImage:[UIImage imageNamed:@"ic_check_right"] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(changeCurrentMonthAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (UIView *)backColorView {
    if (!_backColorView) {
        _backColorView = [[UIView alloc] init];
        _backColorView.backgroundColor = MyNavColor;
    }
    return _backColorView;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        UIImage * backgroundImage = [UIImage imageNamed:@"ic_check_calendar"];
        backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake((WIDTH-2*12)*(448.0/456.0)*(120.0/456.0), 0, (WIDTH-2*12)*(448.0/456.0)*(50.0/456.0), 0) resizingMode:UIImageResizingModeStretch];
        _backgroundImageView = [[UIImageView alloc]initWithImage:backgroundImage];
        _backgroundImageView.userInteractionEnabled = YES;
        _backgroundImageView.backgroundColor = [UIColor clearColor];
        [_backgroundImageView.layer setMasksToBounds:YES];
        [_backgroundImageView.layer setCornerRadius:24.0f];
    }
    return _backgroundImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationTitle = @"签到";
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"ic_register_back"] forState:UIControlStateNormal];
    [self.navigationLeftButton addTarget:self action:@selector(buttonBackToLastView) forControlEvents:UIControlEventTouchUpInside];
    
    [self configView];
}
-(void)buttonBackToLastView{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)configView {
    [self.contentView addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(@12);
        make.trailing.equalTo(@-12);
        make.height.equalTo((WIDTH-2*12)*(448.0/456.0));
    }];
    
    [self.contentView insertSubview:self.backColorView belowSubview:self.backgroundImageView];
    [self.backColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.height.equalTo(@62/*(12+(WIDTH-2*12)*(448.0/456.0)*(101.0/456.0))*/);
    }];
    
    [self.backgroundImageView addSubview:self.currentDateLabel];
    [self.currentDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo((28.0/375)*WIDTH);
        make.top.equalTo(@16);
        make.centerX.equalTo(self.backgroundImageView.centerX);
        make.height.equalTo(@18);
        make.width.equalTo(@100);
    }];
    
    [self.backgroundImageView addSubview:self.lastBtn];
    [self.lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@26);
        make.centerY.equalTo(self.currentDateLabel.mas_centerY);
        make.trailing.equalTo(self.currentDateLabel.leading).with.offset(@-12);
    }];
    
    [self.backgroundImageView addSubview:self.nextBtn];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@26);
        make.centerY.equalTo(self.currentDateLabel.mas_centerY);
        make.leading.equalTo(self.currentDateLabel.trailing).with.offset(@12);
    }];
    
    [self.contentView addSubview:self.calendarView];
    
    [self.contentView addSubview:self.checkBtn];
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundImageView.mas_bottom).with.offset(@24);
        make.width.equalTo(@140);
        make.height.equalTo(@35);
        make.centerX.equalTo(self.backgroundImageView.mas_centerX);
    }];
    
    [self.contentView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.checkBtn.mas_bottom).with.offset(@12);
        make.centerX.equalTo(self.self.checkBtn.mas_centerX);
    }];
}

#pragma mark - private action
- (void)changeCurrentMonthAction:(UIButton *)sender {
    if (sender.tag == 101) {
        --self.calendarView.month;
    }else if (sender.tag == 102) {
        ++self.calendarView.month;
    }
}

- (void)checkConfirmAction:(UIButton *)sender {
    //1.先签到当天
    //2.(签到成功后)获取当钱年月所有已签到日期（self.calendarView.year / month）
    //3.根据days重新给calendarView做签到标记
    [self.calendarView addCheckSignalsWithDays:self.daysArr];
    self.tipLabel.text = [NSString stringWithFormat:@"已经连续登陆%@天", @(self.daysArr.count)];
    self.checkBtn.enabled = NO;
    [self.checkBtn setTitle:@"已签到" forState:UIControlStateNormal];
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
