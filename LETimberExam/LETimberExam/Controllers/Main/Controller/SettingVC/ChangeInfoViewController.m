//
//  ChangeInfoViewController.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/29.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "ChangeInfoViewController.h"
#import "SZLNaviBarBtnItem.h"
@interface ChangeInfoViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)UITextField *itemFiled;
@end

@implementation ChangeInfoViewController
@synthesize delegate;
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
    DLog(@"succsss");

}
#pragma mark - 创建View

-(void)createNav{
    self.navigationTitle = _changeItemName;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"ic_register_back"] forState:UIControlStateNormal];
    [self.navigationLeftButton addTarget:self action:@selector(buttonBackToLastView) forControlEvents:UIControlEventTouchUpInside];
    
    SZLNaviBarBtnItem *mySettingBtn = [SZLNaviBarBtnItem buttonWithTitle:@"保存"];
    [mySettingBtn addTarget:self
                     action:@selector(rightButtonTouch)
           forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationRightButton = mySettingBtn;
}

-(void)buttonBackToLastView{
    [self.navigationController popViewControllerAnimated:YES];
    
}


/**
 *  保存修改数据
 */
-(void)rightButtonTouch{
    int infoType = 0;
    
    if ([_changeItemName isEqualToString:@"手机号"]) {
        infoType = 101;
        if (![self isValidateMobile:self.itemFiled.text]&&self.itemFiled.text.length>0) {
            [SZLInfoHelperManager JumpAlter:@"请输入正确的手机号" after:1.0f To:self.view];
            return;
        }
        
    }else if ([_changeItemName isEqualToString:@"邮箱"]) {
        infoType = 102;
        if (![self isValidateEmail:self.itemFiled.text]&&self.itemFiled.text.length>0) {
            [SZLInfoHelperManager JumpAlter:@"请输入有效的邮箱" after:1.0f To:self.view];
            return;
        }
    }else{
    
    }
    
    if([delegate respondsToSelector:@selector(changePersonInfo:infoType:)])
    {
        //send the delegate function with the amount entered by the user
        [delegate changePersonInfo:self.itemFiled.text infoType:infoType];
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)createChangeItemView{
    
    UIView *changeItemView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, WIDTH, 45)];
    changeItemView.backgroundColor = WhiteColor;
    _itemFiled = [[UITextField alloc] initWithFrame:CGRectMake(30, 7, WIDTH-60, 30)];
    _itemFiled.placeholder = [NSString stringWithFormat:@"请输入修改的%@",_changeItemName];
    _itemFiled.font = [UIFont fontWithName:fontName size:16.0f];
    if ([_changeItemName isEqualToString:@"手机号"]) {
        _itemFiled.keyboardType = UIKeyboardTypeNamePhonePad;
    }else if ([_changeItemName isEqualToString:@"邮箱"]) {
        _itemFiled.keyboardType = UIKeyboardTypeEmailAddress;
    }
    _itemFiled.returnKeyType = UIReturnKeyDone;
    _itemFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _itemFiled.delegate = self;
    _itemFiled.text = self.itemString;
    [changeItemView addSubview:_itemFiled];
    [self.contentView addSubview:changeItemView];
    
    
}


//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_itemFiled resignFirstResponder];
    
    
    return YES;
}



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


@end
