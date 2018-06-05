//
//  LoginViewController.m
//  SZLTimberTrain
//
//  Created by Apple on 16/9/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "LoginViewController.h"
#import "SZLLineView.h"
#import "RegisterViewController.h"
#import "LoginInfoDomain.h"

#import <AFHTTPSessionManager.h>
#import "WebServiceModel.h"
#import "MainViewController.h"

@interface LoginViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,signDelegate>{
    __block NSMutableDictionary *rootDict;//试题信息转化成字典
    
}

@property (nonatomic, strong) UITextField * nameTextfield;
@property (nonatomic, strong) UITextField * passwordTextfield;
@property (nonatomic, strong) UILabel * topLine;
@property (nonatomic, strong) UILabel * midLine;
@property (nonatomic, strong) UIButton * dropDownBtn;
@property (nonatomic, strong) UIButton * pwSaveBtn;
@property (nonatomic, strong) UIButton * autoLoginBtn;
@property (nonatomic, strong) UIButton * loginBtn;
@property (nonatomic, strong) UIButton * registBtn;
@property (nonatomic, strong) UITableView * recordTableView;
@property (nonatomic, strong) MASConstraint * midLineMasTopHeight;


@end

@implementation LoginViewController

#pragma mark - Lazy Loading

- (UITableView *)recordTableView {
    if (!_recordTableView) {
        _recordTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _recordTableView.delegate = self;
        _recordTableView.dataSource = self;
        _recordTableView.backgroundColor = WhiteColor;
        _recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _recordTableView;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * backImage = [UIImage imageNamed:@"ic_login_btn"];
        [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8) resizingMode:UIImageResizingModeStretch];
        [_loginBtn setBackgroundImage:backImage forState:UIControlStateNormal];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn setTitleColor:MyBackColor forState:UIControlStateHighlighted];
        [_loginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
        [_loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIButton *)registBtn {
    if (!_registBtn) {
        _registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registBtn setBackgroundImage:[UIImage imageNamed:@"ic_regist_btn_bg"] forState:UIControlStateNormal];
        [_registBtn setTitleColor:MyNavColor forState:UIControlStateNormal];
        [_registBtn setTitleColor:MyTextColor forState:UIControlStateHighlighted];
        [_registBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [_registBtn addTarget:self action:@selector(registBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registBtn;
}

- (UIButton *)autoLoginBtn {
    if (!_autoLoginBtn) {
        _autoLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_autoLoginBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_autoLoginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_autoLoginBtn setTitle:@"自动登录" forState:UIControlStateNormal];
        [_autoLoginBtn setImage:[UIImage imageNamed:@"ic_login_unselected"] forState:UIControlStateNormal];
        [_autoLoginBtn setImage:[UIImage imageNamed:@"ic_login_unselected"] forState:UIControlStateHighlighted];
        [_autoLoginBtn setImage:[UIImage imageNamed:@"ic_login_selected"] forState:UIControlStateSelected];
        [_autoLoginBtn setImage:[UIImage imageNamed:@"ic_login_selected"] forState:UIControlStateSelected | UIControlStateHighlighted];
        [_autoLoginBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
        [_autoLoginBtn addTarget:self action:@selector(autoLoginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _autoLoginBtn;
}

- (UIButton *)pwSaveBtn {
    if (!_pwSaveBtn) {
        _pwSaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pwSaveBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_pwSaveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_pwSaveBtn setTitle:@"记住密码" forState:UIControlStateNormal];
        [_pwSaveBtn setImage:[UIImage imageNamed:@"ic_login_unselected"] forState:UIControlStateNormal];
        [_pwSaveBtn setImage:[UIImage imageNamed:@"ic_login_unselected"] forState:UIControlStateHighlighted];
        [_pwSaveBtn setImage:[UIImage imageNamed:@"ic_login_selected"] forState:UIControlStateSelected];
        [_pwSaveBtn setImage:[UIImage imageNamed:@"ic_login_selected"] forState:UIControlStateSelected | UIControlStateHighlighted];
        [_pwSaveBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
        [_pwSaveBtn addTarget:self action:@selector(pwSaveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pwSaveBtn;
}

- (UILabel *)midLine {
    if (!_midLine) {
        _midLine = [[UILabel alloc]init];
        _midLine.backgroundColor = MyLineColor;
    }
    return _midLine;
}

- (UILabel *)topLine {
    if (!_topLine) {
        _topLine = [[UILabel alloc]init];
        _topLine.backgroundColor = MyLineColor;
    }
    return _topLine;
}

- (UIButton *)dropDownBtn {
    if (!_dropDownBtn) {
        _dropDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dropDownBtn setImage:[UIImage imageNamed:@"ic_login_open_userlist"] forState:UIControlStateNormal];
        [_dropDownBtn addTarget:self action:@selector(dropDownAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dropDownBtn;
}

- (UITextField *)nameTextfield {
    if (!_nameTextfield) {
        _nameTextfield = [[UITextField alloc]init];
        _nameTextfield.delegate = self;
        _nameTextfield.returnKeyType = UIReturnKeyNext;
        _nameTextfield.clearButtonMode = UITextFieldViewModeAlways;
        _nameTextfield.font = [UIFont boldSystemFontOfSize:14.0f];
        _nameTextfield.textColor = MyTextColor;
        _nameTextfield.placeholder = @"请输入用户名";
    }
    return _nameTextfield;
}

- (UITextField *)passwordTextfield {
    if (!_passwordTextfield) {
        _passwordTextfield = [[UITextField alloc]init];
        _passwordTextfield.delegate = self;
        _passwordTextfield.returnKeyType = UIReturnKeyDone;
        _passwordTextfield.secureTextEntry = YES;
        _passwordTextfield.clearButtonMode = UITextFieldViewModeAlways;
        _passwordTextfield.font = [UIFont boldSystemFontOfSize:14.0f];
        _passwordTextfield.textColor = MyTextColor;
        _passwordTextfield.placeholder = @"请输入登录密码";
    }
    return _passwordTextfield;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];

    [self configData];
    
    if (self.hasAppear) {
        [self.recordTableView reloadData];
        if (self.dropDownBtn.selected) {
            [self dropDownAction:self.dropDownBtn];
        }
        if (!self.pwSaveBtn.selected) {
            self.passwordTextfield.text = @"";
        }
    }
    self.hasAppear = YES;
    
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}



-(void)dealloc{
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kTBStartPageShowCompletionNotification object:nil];
    DLog(@"登录界面销毁!");

}
#pragma mark - Notification Actions
- (void)startAutoLoginAction:(NSNotification *)noti {
    if (self.autoLoginBtn.selected == YES) {
        [self loginBtnAction:self.loginBtn];
    }
}
#pragma mark - create Content View
- (void)configView {
    [self.navigationView removeFromSuperview];
    [self.contentView removeFromSuperview];
    self.view.backgroundColor = WhiteColor;
    UIImageView * appImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_login_Logo"]];
    [self.view addSubview:appImageView];
    [appImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.top.equalTo((50.0/480.0)*HEIGHT);
        make.centerX.equalTo(self.view.centerX);
    }];
    
//    UILabel * titleNameLabel = [[UILabel alloc] init];
//    titleNameLabel.textAlignment = NSTextAlignmentCenter;
//    titleNameLabel.text = @"呼和浩特市公安局";
//    titleNameLabel.font = [UIFont systemFontOfSize:22.0f];
//    [self.view addSubview:titleNameLabel];
//    [titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(@15);
//        make.trailing.equalTo(@-15);
//        make.height.equalTo(@24);
//        make.top.equalTo(appImageView.mas_bottom).with.offset(@8);
//    }];
    
    UILabel * nameWordLabel = [[UILabel alloc] init];
    nameWordLabel.textAlignment = NSTextAlignmentCenter;
    nameWordLabel.text = @"福建中职学业水平测试模考系统";
    nameWordLabel.font = [UIFont systemFontOfSize:22.0f];
    [self.view addSubview:nameWordLabel];
    [nameWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.trailing.equalTo(@-15);
        make.height.equalTo(@24);
        make.top.equalTo(appImageView.mas_bottom).with.offset(@11);
    }];
//    UIImageView * appTitleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_app_title"]];
//    [self.view addSubview:appTitleImageView];
//    [appTitleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@133);
//        make.height.equalTo(@21);
//        make.top.equalTo(appImageView.mas_bottom).with.offset(@8);
//        make.centerX.equalTo(appImageView.centerX);
//    }];
    
    UILabel * nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = MyTextColor;
    nameLabel.font = [UIFont systemFontOfSize:15.0f];
    nameLabel.text = @"用户名";
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameWordLabel.mas_bottom).with.offset((50.0/480.0)*HEIGHT);
        make.leading.equalTo(@24);
        make.width.equalTo(@60);
    }];

    [self.view addSubview:self.dropDownBtn];
    [self.dropDownBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(nameLabel.centerY);
        make.trailing.equalTo(@-20);
    }];
    
    [self.view addSubview:self.nameTextfield];
    [self.nameTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(nameLabel.trailing).with.offset(@8);
        make.trailing.equalTo(self.dropDownBtn.leading).with.offset(@-8);
        make.centerY.equalTo(nameLabel.centerY);
    }];
    
    [self.view addSubview:self.topLine];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.leading.equalTo(@18);
        make.trailing.equalTo(@-18);
        make.top.equalTo(nameLabel.mas_bottom).with.offset(@8);
    }];
    
    [self.view addSubview:self.recordTableView];
    [self.recordTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLine.mas_bottom);
        make.leading.equalTo(nameLabel.trailing).with.offset(@-8);
        make.trailing.equalTo(@-18);
    }];
    
    [self.view addSubview:self.midLine];
    [self.midLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.leading.equalTo(@18);
        make.trailing.equalTo(@-18);
        self.midLineMasTopHeight = make.top.equalTo(self.topLine.mas_top);
    }];
    
    UILabel * passwordLabel = [[UILabel alloc]init];
    passwordLabel.textColor = MyTextColor;
    passwordLabel.font = [UIFont systemFontOfSize:15.0f];
    passwordLabel.text = @"密码";
    [self.view addSubview:passwordLabel];
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.midLine.mas_bottom).with.offset(@12);
        make.leading.equalTo(@24);
        make.width.equalTo(@60);
    }];
    //ic_login_see_pwd
    UIButton * showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [showBtn setImage:[UIImage imageNamed:@"ic_password_hide"] forState:UIControlStateNormal];
    [showBtn setImage:[UIImage imageNamed:@"ic_password_hide"] forState:UIControlStateHighlighted];
    [showBtn setImage:[UIImage imageNamed:@"ic_password_show"] forState:UIControlStateSelected];
    [showBtn setImage:[UIImage imageNamed:@"ic_password_show"] forState:UIControlStateSelected | UIControlStateHighlighted];
    [showBtn addTarget:self action:@selector(showAndHideAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showBtn];
    [showBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(passwordLabel.centerY);
        make.trailing.equalTo(@-20);
    }];
    
    [self.view addSubview:self.passwordTextfield];
    [self.passwordTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(passwordLabel.trailing).with.offset(@8);
        make.trailing.equalTo(showBtn.leading).with.offset(@-8);
        make.centerY.equalTo(passwordLabel.centerY);
    }];
    
    UILabel * bottomLine = [[UILabel alloc]init];
    bottomLine.backgroundColor = MyLineColor;
    [self.view addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.leading.equalTo(@18);
        make.trailing.equalTo(@-18);
        make.top.equalTo(passwordLabel.mas_bottom).with.offset(@8);
    }];
    
    [self.view addSubview:self.pwSaveBtn];
    [self.pwSaveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomLine.mas_bottom).with.offset(@12);
        make.leading.equalTo(@12);
        make.width.equalTo(@80);
    }];
    
    [self.view addSubview:self.autoLoginBtn];
    [self.autoLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pwSaveBtn.centerY);
        make.leading.equalTo(self.pwSaveBtn.trailing).with.offset(@12);
        make.width.equalTo(@80);
    }];
    
    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwSaveBtn.mas_bottom).with.offset(@12);
        make.leading.equalTo(@18);
        make.trailing.equalTo(@-18);
        make.height.equalTo(@40);
    }];
    
    [self.view addSubview:self.registBtn];
    [self.registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@134);
        make.height.equalTo(@34);
        make.centerX.equalTo(self.loginBtn.centerX);
        make.top.equalTo(self.loginBtn.mas_bottom).with.offset(@12);
    }];
}

- (void)configData {
    
    
    if (SZLInfoHelperManager.userInfoArr.count > 0 && SZLInfoHelperManager.isLogin) {

        LoginInfoDomain * domain = [[LoginInfoDomain alloc]initWithDictionary:SZLInfoHelperManager.userInfoArr.firstObject];
        [self configControllersWithDomain:domain];
        
//        if (self.autoLoginBtn.selected == YES) {
//            [self loginBtnAction:self.loginBtn];
//        }
    }
}

#pragma mark - Private Action
- (void)dropDownAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    [UIView animateWithDuration:.3f animations:^{
        sender.imageView.transform = CGAffineTransformRotate(sender.imageView.transform, M_PI);
    }];
    
    [self dropDownAnimationWithState:sender.selected];
}

- (void)dropDownAnimationWithState:(BOOL)isDownDrop {
    if (isDownDrop) {
        CGFloat tableHeight = 0;
        if (SZLInfoHelperManager.userInfoArr.count < 2) {
            tableHeight = 36;
        }else{
            tableHeight = 72;
        }
        [self.midLine mas_updateConstraints:^(MASConstraintMaker *make) {
            self.midLineMasTopHeight = make.top.equalTo(self.topLine.mas_top).with.offset(tableHeight);
        }];
        [self.recordTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(tableHeight);
        }];
    }else{
        [self.midLine mas_updateConstraints:^(MASConstraintMaker *make) {
            self.midLineMasTopHeight = make.top.equalTo(self.topLine.mas_top);
        }];
        [self.recordTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
    
    [UIView animateWithDuration:.3f animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showAndHideAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.passwordTextfield.secureTextEntry = !sender.selected;
}


-(void)hideKeyBoardAction{
    [_nameTextfield resignFirstResponder];
    [_passwordTextfield resignFirstResponder];
}
#pragma mark - 网络请求
- (void)loginBtnAction:(UIButton *)sender {
    //收起键盘
    __weak LoginViewController * wself = self;
    [self hideKeyBoardAction];
    if (_nameTextfield.text.length==0) {
        [self.view makeToast:@"请输入账号"];
        return;
    }
    if (_passwordTextfield.text.length==0) {
        
        [self.view makeToast:@"请输入密码"];
        return;
    }
    if (kNetworkNotReachability) {
        [self.view makeToast:kError_Network_NotReachable];
        return;
    }
    NSDictionary *prama = @{
                            @"servletname":@"Login",
                            @"userName":self.nameTextfield.text,
                            @"userPwd":self.passwordTextfield.text,
                            };

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [SZLServerHelper userLoginRequest:prama callback:^(NSInteger errCode, ApiResponse *response, BOOL success) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:wself.view animated:YES];
            });
            
            if (success) {
                rootDict = response.data;
                NSDictionary *userBaseInfo = [rootDict objectForKey:@"dtUserInfo"];
                NSString *_userId = [userBaseInfo objectForKey:@"USER_ID"];
                SZLInfoHelperManager.userBaseInfo = userBaseInfo;
                SZLInfoHelperManager.userId = _userId;
                SZLInfoHelperManager.totalNews = [[rootDict objectForKey:@"News"] integerValue];
                SZLInfoHelperManager.totalNotices = [[rootDict objectForKey:@"Notice"] integerValue];
                
                [SZLInfoHelperManager updateUserLoginInfoWithDict:@{@"userName":wself.nameTextfield.text,
                                                                    @"password":wself.pwSaveBtn.selected?wself.passwordTextfield.text:@"",
                                                                    @"autoLogin":@(wself.autoLoginBtn.selected)}];
                
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                
                [user setObject:_userId forKey:@"userId"];
                
                [user setObject:[prama objectForKey:@"userPwd"] forKey:@"password"];
                [user setObject:[userBaseInfo objectForKey:@"USER_NAME"] forKey:@"stuCnname"];
                [user setObject:[userBaseInfo objectForKey:@"STU_CNNAME"] forKey:@"userName"];
                
                [user synchronize];//用synchronize方法把数据持久化到
                APPDELEGATE.automaticLogin = NO;
                [AppDelegate setRootViewController:APPDELEGATE.mainNavc fromController:wself isLogin:YES];
                
            }else{
                [wself.view makeToast:response.errDesc];
            }
            
        }];
        
    });
}



//        push 到主程序
-(void)pushMainPageViewCtl{
    MainViewController *main = [[MainViewController alloc] init];

    [self.navigationController pushViewController:main animated:YES];
    
}







- (void)registBtnAction:(UIButton *)sender {

    RegisterViewController * viewController = [[RegisterViewController alloc]init];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pwSaveBtnAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (!sender.selected) {
        self.autoLoginBtn.selected = NO;
    }
}

- (void)autoLoginBtnAction:(UIButton *)sender {
    if (!self.pwSaveBtn.selected) {
        self.pwSaveBtn.selected = YES;
        self.autoLoginBtn.selected = YES;
        return;
    }
    sender.selected = !sender.selected;
}

- (void)removeRecordAction:(UIButton *)sender {
    [JCAlertView showTwoButtonsWithTitle:@"温馨提示" Message:@"确认删除该账户记录？" ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"取消" Click:^{
        
    } ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:@"确定" Click:^{
        
        LoginInfoDomain * domain = [[LoginInfoDomain alloc]initWithDictionary:SZLInfoHelperManager.userInfoArr[sender.tag]];
        if ([domain.userName isEqualToString:self.nameTextfield.text]) {
            self.nameTextfield.text = @"";
            self.passwordTextfield.text = @"";
            self.pwSaveBtn.selected = NO;
            self.autoLoginBtn.selected = NO;
        }
        [SZLInfoHelperManager deleteUserLoginInfoWithUserName:domain.userName];
        [self.recordTableView reloadData];
        if (SZLInfoHelperManager.userInfoArr.count < 2) {
            [self dropDownAnimationWithState:YES];
        }
     
    }];
}

- (void)configControllersWithDomain:(LoginInfoDomain *)domain {
    self.nameTextfield.text = domain.userName;
    if (domain.password.length != 0) {
        self.passwordTextfield.text = domain.password;
        self.pwSaveBtn.selected = YES;
    }else{
        self.passwordTextfield.text = @"";
        self.pwSaveBtn.selected = NO;
    }
    self.autoLoginBtn.selected = domain.autoLogin;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTextfield) {
        [self.passwordTextfield becomeFirstResponder];
        return YES;
    }else if (textField == self.passwordTextfield) {
        [self.passwordTextfield resignFirstResponder];
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.nameTextfield && self.nameTextfield.text.length == 0) {
        self.passwordTextfield.text = @"";
        self.pwSaveBtn.selected = NO;
        self.autoLoginBtn.selected = NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.nameTextfield) {
        LoginInfoDomain * domain = [SZLInfoHelperManager findUserLoginInfoWithUserName:textField.text];
        if (domain) {
            [self configControllersWithDomain:domain];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (SZLInfoHelperManager.userInfoArr.count>0) {
        return SZLInfoHelperManager.userInfoArr.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"RecordCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    cell.textLabel.textColor = MyTextColor;
    if (SZLInfoHelperManager.userInfoArr.count>0) {
        NSMutableArray * nameArr = [NSMutableArray array];
        for (NSDictionary * tmpDict in SZLInfoHelperManager.userInfoArr) {
            [nameArr addObject:[tmpDict objectForKey:@"userName"]];
        }
        cell.textLabel.text = nameArr[indexPath.row];
        
        UIButton * removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [removeBtn setFrame:CGRectMake(0, 0, 18, 18)];
        [removeBtn setTag:indexPath.row];
        [removeBtn setImage:[UIImage imageNamed:@"ic_login_remove"] forState:UIControlStateNormal];
        [removeBtn addTarget:self action:@selector(removeRecordAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = removeBtn;
        
        if (indexPath.row < SZLInfoHelperManager.userInfoArr.count - 1) {
            SZLLineView * lineView = [[SZLLineView alloc]initWithFrame:CGRectMake(0, 35, WIDTH-100, 1) lineDashPattern:@[@3, @3] endOffset:0.495];
            lineView.backgroundColor = MyLineColor;
            [cell.contentView addSubview:lineView];
        }
    }else{
        cell.textLabel.text = @"无历史记录";
        cell.textLabel.textColor = [UIColor grayColor];
        cell.accessoryView = nil;
        for (UIView * view in cell.contentView.subviews) {
            if ([view isKindOfClass:[SZLLineView class]]) {
                [view removeFromSuperview];
            }
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (SZLInfoHelperManager.userInfoArr.count>0) {
        LoginInfoDomain * domain = [[LoginInfoDomain alloc]initWithDictionary:SZLInfoHelperManager.userInfoArr[indexPath.row]];
        [self configControllersWithDomain:domain];
    }
    [self dropDownAction:self.dropDownBtn];
}

//注册的代理方法
-(void)signDelegteName:(NSString *)name passWord:(NSString *)password{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:name forKey:@"userName"];
    [defaults setObject:password forKey:@"passWord"];
    [defaults synchronize];

    
    self.nameTextfield.text = name;
    self.passwordTextfield.text = password;
    [_recordTableView reloadData];
}

@end
