//
//  registerViewController.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/6.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "registerViewController.h"
#import "LoginViewController.h"
#import "WebServiceModel.h"
@interface RegisterViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIButton *registerBtn;
@property (strong, nonatomic) UITableView *registerInfoTableView;

@property (strong, nonatomic)UITextField * usernameTV;
@property (strong, nonatomic)UITextField * passwordTV;
@property (strong, nonatomic)UITextField * conformTV;//确认密码
@property (strong, nonatomic)UITextField * phoneNumTV;
@property (strong, nonatomic)UITextField * mailTV;

@property (strong, nonatomic) UILabel * usernameLabel;
@property (strong, nonatomic) UILabel * passwordLabel;
@property (strong, nonatomic) UILabel * conformLabel;
@property (strong, nonatomic) UILabel * phoneNumLabel;
@property (strong, nonatomic) UILabel * mailLabel;

@property (strong, nonatomic)NSString * username;
@property (strong, nonatomic)NSString * password;
@property (strong, nonatomic)NSString * conform;
@property (strong, nonatomic)NSString * phoneNum;
@property (strong, nonatomic)NSString * mail;
@end

@implementation RegisterViewController

#pragma mark lazyLoading  

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNav];
    [self createTableView];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    DLog(@"dealloc");

}


#pragma mark - createView
-(void)createNav{
    
    self.navigationTitle = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"ic_register_back"] forState:UIControlStateNormal];
    [self.navigationLeftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

}

-(void)createTableView{
    _registerInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    
    _registerInfoTableView.delegate = self;
    _registerInfoTableView.dataSource = self;
    _registerInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _registerInfoTableView.scrollEnabled = NO;
    [self.contentView addSubview:_registerInfoTableView];
}

#pragma mark - buttonAction

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  注册点击事件
 */

-(void)allTextFieldResign{
    [_usernameTV resignFirstResponder];
    [_passwordTV resignFirstResponder];
    [_conformTV resignFirstResponder];
    [_phoneNumTV resignFirstResponder];
    [_mailTV resignFirstResponder];


}

-(void)registerNewUser{
    _username = _usernameTV.text;
    _password = _passwordTV.text;
    _conform = _conformTV.text;
    _phoneNum = _phoneNumTV.text;
    _mail = _mailTV.text;
    __weak RegisterViewController * wself = self;
    [self allTextFieldResign];

    if (kNetworkNotReachability) {
        [self.view makeToast:kError_Network_NotReachable];
        return;
    }

    if (_username.length==0) {
        [self.contentView makeToast:@"请输入账户名"];
        return;
    }
    if (_username.length<4) {
        [self.contentView makeToast:@"用户名长度必须大于4位"];
        return;
    }
    if (_username.length>20) {
        [self.contentView makeToast:@"用户名长度必须小于20位"];
        return;
    }
    if (_phoneNum.length==0) {
        
    }else if (_phoneNum.length !=11){
        [self.contentView makeToast:@"手机号格式不正确"];
        return;
    }else{
        BOOL b= [self isValidateMobile:_phoneNum];
        if (!b) {
            [self.contentView makeToast:@"手机号格式不正确！"];
            return;
        }
    }
    if (_mail.length == 0) {
        
    }else{
        BOOL b= [self isValidateEmail:_mail];
        if (!b) {
            [self.contentView makeToast:@"邮箱格式不正确"];
            return;
        }
    }
    if (_password.length==0) {
        [self.contentView makeToast:@"请输入密码"];
        return;
    }
    if (_password.length<6){
        [self.contentView makeToast:@"密码长度必须大于6位"];
        return;
    }
    if (_password.length>12){
        [self.contentView makeToast:@"密码长度必须小于12位"];
        return;
    }
    
    if (_conform.length==0) {
        [self.contentView makeToast:@"请输入确认密码"];
        return;
    }
    if (![_password isEqualToString:_conform]){
        
        [self.contentView makeToast:@"输入的两次密码不一致"];
        return;
    }
    

  
    NSDictionary *prama = @{
                            @"servletname":@"register",
                            @"Username":_username,
                            @"userPwd":_password,
                            @"phone":_phoneNum,
                            @"email":_mail
                            };
    [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __block ApiRequest *request = [SZLServerHelper normalRequest:prama callback:^(NSInteger errCode, ApiResponse *response, BOOL success) {
            [self.requestArr removeObject:request];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:wself.contentView animated:YES];
            });
            
            if (success) {
                [wself.delegate signDelegteName:wself.username passWord:wself.password];
                [wself.contentView makeToast:@"注册成功"];
                [wself performSelector:@selector(back) withObject:nil afterDelay:1];
                
            }else{
                [wself.view makeToast:response.errDesc];
            }
            
        }];
        [self.requestArr addObject:request];
    });
    
    
}
#pragma mark - check
-(void)checkRegisterInfo{
    //    检测是否为空
    if (_username.length==0) {
        
        [self.contentView makeToast:@"请输入账户名"];
        
        return;
    }
    if (_username.length<4) {
        
        [self.contentView makeToast:@"用户名长度必须大于4位"];
        return;
    }
    if (_username.length>20) {
        
        [self.contentView makeToast:@"用户名长度必须小于20位"];
        return;
    }
    if (_phoneNum.length==0) {
        
        
    }else if (_phoneNum.length !=11){
        
        [self.contentView makeToast:@"手机号格式不正确"];
        return;
    }else{
        BOOL b= [self isValidateMobile:_phoneNum];
        if (!b) {
            
            [self.contentView makeToast:@"手机号格式不正确！"];
            return;
        }
    }
    if (_mail.length == 0) {
        
    }else{
        BOOL b= [self isValidateEmail:_mail];
        if (!b) {
            [self.contentView makeToast:@"邮箱格式不正确"];
            return;
            
        }
        
    }
    if (_password.length==0) {
        [self.contentView makeToast:@"请输入密码"];
        return;
    }
    if (_password.length<6){
        [SZLInfoHelperManager JumpAlter:@"密码长度必须大于6位" after:1.0f To:self.view];
        return;
    }
    if (_password.length>12){
        [SZLInfoHelperManager JumpAlter:@"密码长度必须小于12位" after:1.0f To:self.view];
        return;
    }
    
    if (_conform.length==0) {
        [self.contentView makeToast:@"请输入确认密码"];
        return;
    }
    if (_conform.length<6){
        [SZLInfoHelperManager JumpAlter:@"密码长度必须大于6位" after:1.0f To:self.view];
        return;
    }
    if (_conform.length>12){
        [SZLInfoHelperManager JumpAlter:@"密码长度必须小于12位" after:1.0f To:self.view];
        return;
    }
    if (![_password isEqualToString:_conform]){
        
        [self.contentView makeToast:@"输入的两次密码不一致"];
        return;
    }

}


#pragma mark - UITextFieldDelegate
//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:self.passwordTV]||[textField isEqual:self.conformTV]){
        if (textField.text.length<6) {
            //
            
        }else if (textField.text.length>12){
            //
        }
    
    }
    
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDoneEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_usernameTV resignFirstResponder];
    [_passwordTV resignFirstResponder];
    [_conformTV resignFirstResponder];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 5) {
        return 60;
    }
    return 50;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    if (section == 0) {
        UIView *usernameView = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 50)];
        usernameView.backgroundColor=[UIColor whiteColor];
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 20, 100,21 )];
        _usernameLabel.text = @"用户名";
        _usernameLabel.textColor = [UIColor darkGrayColor];
        _usernameTV = [[UITextField alloc] initWithFrame:CGRectMake(126, 7, WIDTH-150,50)];
        _usernameTV.placeholder = @"4到20位字符";
        _usernameTV.font = [UIFont fontWithName:fontName size:16.0f];
        _usernameTV.returnKeyType = UIReturnKeyDone;
        _usernameTV.delegate = self;
        _usernameTV.clearButtonMode = UITextFieldViewModeWhileEditing;
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(12, 48, WIDTH-16, 1)];
        line.backgroundColor = MyBackColor;
        
        
        
        [usernameView addSubview:_usernameLabel];
        [usernameView addSubview:_usernameTV];
        [usernameView addSubview:line];
        return  usernameView;
    }else if (section == 1){
        
        UIView *passwordView = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 50)];
        passwordView.backgroundColor=[UIColor whiteColor];
        _passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 20, 100,21 )];
        _passwordLabel.text = @"密码";
        _passwordLabel.textColor = [UIColor darkGrayColor];
        _passwordTV = [[UITextField alloc] initWithFrame:CGRectMake(126, 7, WIDTH-150,51 )];
        _passwordTV.placeholder = @"6到16位字符";
        _passwordTV.font = [UIFont fontWithName:fontName size:16.0f];
        _passwordTV.returnKeyType = UIReturnKeyDone;
        _passwordTV.secureTextEntry = YES;
        _passwordTV.delegate = self;
        
        UIImageView* rightView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH-55, 25, 20, 20)];
        [rightView setContentMode:UIViewContentModeScaleAspectFit];
        rightView.image = [UIImage imageNamed:@"ic_password_hide"];
        [rightView setUserInteractionEnabled:YES];
        [rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)]];
        
        _passwordTV.rightViewMode = UITextFieldViewModeAlways;
        _passwordTV.rightView = rightView;
        _passwordTV.clearButtonMode = UITextFieldViewModeWhileEditing;
        rightView.tag = 1001;
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(12, 48, WIDTH-16, 1)];
        line.backgroundColor = MyBackColor;
        [passwordView addSubview:_passwordLabel];
        [passwordView addSubview:_passwordTV];
        [passwordView addSubview:line];
        return  passwordView;
        
        
    }else if (section == 2){
        UIView *confirmView = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 50)];
        confirmView.backgroundColor=[UIColor whiteColor];
        _conformLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 20, 100,21 )];
        _conformLabel.text = @"确认密码";
        _conformLabel.textColor = [UIColor darkGrayColor];
        _conformTV = [[UITextField alloc] initWithFrame:CGRectMake(126, 7, WIDTH-150,51 )];
        _conformTV.placeholder = @"请确保两次密码一致";
        _conformTV.font = [UIFont fontWithName:fontName size:16.0f];
        _conformTV.returnKeyType = UIReturnKeyDone;
        _conformTV.secureTextEntry = YES;
        _conformTV.delegate = self;
        
        UIImageView* rightView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH-55, 25, 20, 20)];
        [rightView setContentMode:UIViewContentModeScaleAspectFit];
        rightView.image = [UIImage imageNamed:@"ic_password_hide"];
        [rightView setUserInteractionEnabled:YES];
        [rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)]];
        
        _conformTV.rightViewMode = UITextFieldViewModeAlways;
        _conformTV.rightView = rightView;
        _conformTV.clearButtonMode = UITextFieldViewModeWhileEditing;
        rightView.tag = 1002;
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(12, 48, WIDTH-16, 1)];
        line.backgroundColor = MyBackColor;
        
        [confirmView addSubview:_conformLabel];
        [confirmView addSubview:_conformTV];
        [confirmView addSubview:line];
        return  confirmView;
        
    }else if(section == 3){
        UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 50)];
        phoneView.backgroundColor=[UIColor whiteColor];
        _phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 20, 100,21 )];
        _phoneNumLabel.text = @"手机(非必填)";
        _phoneNumLabel.textColor = [UIColor darkGrayColor];
        _phoneNumTV = [[UITextField alloc] initWithFrame:CGRectMake(126, 7, WIDTH-150,51)];
        _phoneNumTV.placeholder = @"请输入手机号";
        _phoneNumTV.font = [UIFont fontWithName:fontName size:16.0f];
        _phoneNumTV.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumTV.returnKeyType = UIReturnKeyDone;
        _phoneNumTV.delegate = self;
        
        _phoneNumTV.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(12, 48, WIDTH-16, 1)];
        line.backgroundColor = MyBackColor;
        [phoneView addSubview:_phoneNumLabel];
        [phoneView addSubview:_phoneNumTV];
        [phoneView addSubview: line];
        return  phoneView;
    }else if (section == 4){
        UIView *mailView = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 50)];
        mailView.backgroundColor=[UIColor whiteColor];
        _mailLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 20, 100,21 )];
        _mailLabel.text = @"邮箱(非必填)";
        _mailLabel.textColor = [UIColor darkGrayColor];
        _mailTV = [[UITextField alloc] initWithFrame:CGRectMake(126, 7, WIDTH-150,51)];
        _mailTV.placeholder = @"请输入邮箱地址";
        _mailTV.font = [UIFont fontWithName:fontName size:16.0f];
        _mailTV.returnKeyType = UIReturnKeyDone;
        
        //    _usernameField.textColor = [UIColor whiteColor];
        //        _usernameField.layer.borderWidth = 1.0f;
        //        _usernameField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _mailTV.delegate = self;
        
        _mailTV.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        [mailView addSubview:_mailLabel];
        [mailView addSubview:_mailTV];
        return  mailView;
    }else{
        UIView *signBtnView = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, 120)];
        
        signBtnView.backgroundColor = [UIColor whiteColor];
        
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerBtn.frame = CGRectMake(12, 30, WIDTH-24, 40);
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_registerBtn setTitle:@"注 册" forState:UIControlStateNormal];
        [_registerBtn setBackgroundImage:[UIImage imageNamed:@"ic_register"] forState:UIControlStateNormal];
        [_registerBtn setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
        
        [_registerBtn addTarget:self action:@selector(registerNewUser) forControlEvents:UIControlEventTouchUpInside];
        [signBtnView addSubview:_registerBtn];
        return  signBtnView;
    
    }
    
}
#pragma mark - personFuction
/*邮箱验证 MODIFIED BY HELENSONG*/
-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}
/*密码验证 
 *不能全部为数字
 *不能全部为字母
 *必须包含字母和数字
 *6-20位
 */
-(BOOL)checkPassWord
{
    //6-20位数字和字母组成
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:self]) {
        return YES ;
    }else
        return NO;
}

//转码汉字
- (NSString  *)changeCHINESEToNSUrl:(NSString *)chineseString{
    
    NSString * chineseUrl= [chineseString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return chineseUrl;
}


-(void)clickCategory:(UITapGestureRecognizer *)gestureRecognizer
{
    UIImageView *viewClicked=[gestureRecognizer view];

    if(viewClicked.tag == 1001){
        if(_passwordTV.secureTextEntry){
            _passwordTV.secureTextEntry = NO;
            viewClicked.image =  [UIImage imageNamed:@"ic_password_show"];
        }else{
            _passwordTV.secureTextEntry = YES;
            viewClicked.image =  [UIImage imageNamed:@"ic_password_hide"];
        }
    }else if (viewClicked.tag == 1002){
        if(_conformTV.secureTextEntry){
            _conformTV.secureTextEntry = NO;
            viewClicked.image =  [UIImage imageNamed:@"ic_password_show"];

        }else{
            _conformTV.secureTextEntry = YES;
            viewClicked.image =  [UIImage imageNamed:@"ic_password_hide"];

            
        }
    
    }

}

@end
