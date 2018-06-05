//
//  ChangePwdViewController.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/29.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "WebServiceModel.h"
@interface ChangePwdViewController ()<UITextFieldDelegate>

@property(nonatomic,strong) UITextField *oldPwdFiled;
@property(nonatomic,strong) UITextField *PwdFiled;
@property(nonatomic,strong) UITextField *confirmPwdFiled;
@property(nonatomic,strong) UIView *divideLine;
@property(nonatomic,strong) UIButton *sureToChangeBtn;
@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation ChangePwdViewController
static NSString* fontName = @"Avenir-Book";
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createNav];
    
    [self createChangeItemView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    DLog(@"dealloc success");

}
#pragma mark - 创建视图
-(void)createNav{
    self.navigationTitle = _changeItemName;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"ic_register_back"] forState:UIControlStateNormal];
    [self.navigationLeftButton addTarget:self action:@selector(buttonBackToLastView) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)buttonBackToLastView{
    [self.navigationController popViewControllerAnimated:YES];
    
}
/**
 *  创建 主界面
 */
-(void)createChangeItemView{
    
    UIView *changeItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, WIDTH, 135)];
    changeItemView.backgroundColor = WhiteColor;
    _oldPwdFiled = [[UITextField alloc] initWithFrame:CGRectMake(30, 7, WIDTH-60, 30)];
   
    _oldPwdFiled = [self createPwdField:CGRectMake(30, 7, WIDTH-60, 30) withPlaceholder:@"请输入原密码" rightViewTag:1001];
    [changeItemView addSubview:_oldPwdFiled];
    _oldPwdFiled.returnKeyType = UIReturnKeyNext;
    
    _divideLine = [self createDivLine:CGRectMake(5, 45, WIDTH -10, 1)];
    [changeItemView addSubview:_divideLine];
    
    _PwdFiled = [self createPwdField:CGRectMake(30, 7+45, WIDTH-60, 30) withPlaceholder:@"请输入新密码" rightViewTag:1002];
    [changeItemView addSubview:_PwdFiled];
    _PwdFiled.returnKeyType = UIReturnKeyNext;
    
    _divideLine = [self createDivLine:CGRectMake(5, 45+45, WIDTH -10, 1)];
    [changeItemView addSubview:_divideLine];
    
    _confirmPwdFiled = [self createPwdField:CGRectMake(30, 7+45+45, WIDTH-60, 30) withPlaceholder:@"请确认新密码" rightViewTag:1003];
    [changeItemView addSubview:_confirmPwdFiled];
    _confirmPwdFiled.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:changeItemView];
    
    _sureToChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureToChangeBtn.frame = CGRectMake(10,180, WIDTH-20, 40);
    [_sureToChangeBtn setBackgroundImage:[UIImage imageNamed:@"ic_login_btn"] forState:UIControlStateNormal];
    _sureToChangeBtn.titleLabel.font = [UIFont fontWithName:fontName size:19.0f];
    [_sureToChangeBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [_sureToChangeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sureToChangeBtn setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [_sureToChangeBtn addTarget:self action:@selector(sendRequestForChangePwd) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_sureToChangeBtn];
    
}
/**
 *  创建密码输入TextField
 *
 *  @param tfFrame        textfield的大小
 *  @param placeholderStr 预留字
 *  @param tag            textField的tag，用于区分点击事件
 *
 *  @return 返回密码输入TextField
 */
-(UITextField *)createPwdField:(CGRect)tfFrame withPlaceholder:(NSString *)placeholderStr rightViewTag:(long)tag{
    UITextField *pwdTF = [[UITextField alloc] initWithFrame:tfFrame];
    pwdTF.placeholder = placeholderStr;
    pwdTF.font = [UIFont fontWithName:fontName size:16.0f];
//    pwdTF.returnKeyType = UIReturnKeyDone;
    pwdTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    pwdTF.delegate = self;
    pwdTF.secureTextEntry = YES;
    
    UIImageView* rightView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH-55, 25, 20, 20)];
    [rightView setContentMode:UIViewContentModeScaleAspectFit];
    rightView.image = [UIImage imageNamed:@"ic_password_hide"];
    [rightView setUserInteractionEnabled:YES];
    [rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCategory:)]];
    
    pwdTF.rightViewMode = UITextFieldViewModeAlways;
    pwdTF.rightView = rightView;
    rightView.tag = tag;
    
    return pwdTF;
}
/**
 *  显示隐藏密码字符
 *
 *  @param gestureRecognizer 触摸事件
 */
-(void)clickCategory:(UITapGestureRecognizer *)gestureRecognizer
{
    UIImageView *viewClicked=[gestureRecognizer view];
    
    if(viewClicked.tag == 1001){
        if(_oldPwdFiled.secureTextEntry){
            _oldPwdFiled.secureTextEntry = NO;
            viewClicked.image =  [UIImage imageNamed:@"ic_password_show"];
        }else{
            _oldPwdFiled.secureTextEntry = YES;
            viewClicked.image =  [UIImage imageNamed:@"ic_password_hide"];
        }
    }else if (viewClicked.tag == 1002){
        if(_PwdFiled.secureTextEntry){
            _PwdFiled.secureTextEntry = NO;
            viewClicked.image =  [UIImage imageNamed:@"ic_password_show"];
        }else{
            _PwdFiled.secureTextEntry = YES;
            viewClicked.image =  [UIImage imageNamed:@"ic_password_hide"];
        }
        
    }else if (viewClicked.tag == 1003){
        if(_confirmPwdFiled.secureTextEntry){
            _confirmPwdFiled.secureTextEntry = NO;
            viewClicked.image =  [UIImage imageNamed:@"ic_password_show"];
        }else{
            _confirmPwdFiled.secureTextEntry = YES;
            viewClicked.image =  [UIImage imageNamed:@"ic_password_hide"];
            
        }
        
    }
    
    
}

/**
 *  创建分割线
 *
 *  @param frame 分割线的大小位置
 *
 *  @return 返回分割线
 */
-(UIView *)createDivLine:(CGRect)frame{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    return  line;
}
/**
 *  收起键盘操作
 */
-(void)hideKeyBoardAction{
    [_oldPwdFiled resignFirstResponder];
    [_PwdFiled resignFirstResponder];
    [_confirmPwdFiled resignFirstResponder];
}



/**
 *  点击确定按钮，更改密码网络请求
 */

-(void)sendRequestForChangePwd{
    //先收起键盘
    [self hideKeyBoardAction];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *password = [user objectForKey:@"password"];
    if (self.oldPwdFiled.text == NULL) {
        [SZLInfoHelperManager JumpAlter:@"请输入原密码" after:1.5f To:self.view];
        return;
    }else if (![self.oldPwdFiled.text isEqualToString:password]) {
        [SZLInfoHelperManager JumpAlter:@"原密码有误" after:1.5f To:self.view];
        return;
    }else if (self.PwdFiled.text == NULL){
        [SZLInfoHelperManager JumpAlter:@"请输入新密码" after:1.5f To:self.view];
        return;
    }else if (self.confirmPwdFiled.text ==NULL){
        [SZLInfoHelperManager JumpAlter:@"请输入新密码" after:1.5f To:self.view];
        return;
    }else if (![self.confirmPwdFiled.text isEqualToString:self.PwdFiled.text]){
        [SZLInfoHelperManager JumpAlter:@"两次密码不匹配" after:1.5f To:self.view];
        return;
    }
    
    if(self.oldPwdFiled.text.length<6||self.confirmPwdFiled.text.length<6){
        [SZLInfoHelperManager JumpAlter:@"密码长度必须大于6位" after:1.5f To:self.view];
        return;
    }
    
    if(self.oldPwdFiled.text.length>12||self.confirmPwdFiled.text.length>12){
        [SZLInfoHelperManager JumpAlter:@"密码长度必须小于12位" after:1.5f To:self.view];
        return;
    }
    
    
    [self userChangePassword:self.oldPwdFiled.text withNewPwd:self.PwdFiled.text];
    
}

/**
 *  修改手机号
 *
 *  @param phone 手机号
 */
-(void)userChangePassword:(NSString*)oldPwd withNewPwd:(NSString*)newPwd{
    __weak ChangePwdViewController * wself = self;
    
    if (kNetworkNotReachability) {
        [self.view makeToast:kError_Network_NotReachable];
        return;
    }
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __block ApiRequest *request = [SZLServerHelper changePersonPasswordRequest:oldPwd withNewPwd:newPwd callback:^(NSInteger errCode, ApiResponse *response, BOOL success) {
            [wself.requestArr removeObject:request];
            if (success) {
                wself.hud = [[MBProgressHUD alloc] initWithView:wself.view];
                wself.hud.mode = MBProgressHUDModeText;
                [wself.view addSubview:wself.hud];
                [wself.hud showAnimated:YES whileExecutingBlock:^{
                    wself.hud.labelText = @"正在更改...";
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    [user setObject:newPwd forKey:@"password"];
                    sleep(1.0);
                    wself.hud.labelText = @"更改成功...";
                } completionBlock:^{
                    
                    [wself.navigationController popViewControllerAnimated:YES];
                    [wself.hud removeFromSuperview];
                    
                }];

            }else{
           
                [wself.view makeToast:response.errDesc];
            }
            
        }];
        [wself.requestArr addObject:request];
    });
    
}


#pragma mark --UITextFieldDelegate
//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_oldPwdFiled]) {
        [_PwdFiled becomeFirstResponder];
    }else if ([textField isEqual:_PwdFiled]){
        [_confirmPwdFiled becomeFirstResponder];
    }else{
        [_confirmPwdFiled resignFirstResponder];
    }
    
    return YES;
}
@end
