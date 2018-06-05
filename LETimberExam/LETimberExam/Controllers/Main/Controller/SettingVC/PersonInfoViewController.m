//
//  PersonInfoViewController.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/28.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "ChangeInfoViewController.h"
#import "UserBaseInfoModel.h"
#import "WebServiceModel.h"
@interface PersonInfoViewController ()

@property (nonatomic,copy) NSString *userSex;
@property (nonatomic,copy) NSString *userPhone;
@property (nonatomic,copy) NSString *userMail;
@property (nonatomic,strong) UserBaseInfoModel * domain;

@property (nonatomic,strong) NSIndexPath *indexPathOne;
@property (nonatomic,strong) NSIndexPath *indexPathTwo;
@property (nonatomic,strong) NSIndexPath *indexPathThree;
@property (nonatomic,strong) MBProgressHUD *hud;

@end

@implementation PersonInfoViewController
#pragma mark - lazy loading
-(UITableView*)personInfoTB{
    if (!_personInfoTB) {
        _personInfoTB = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _personInfoTB.delegate = self;
        _personInfoTB.dataSource = self;
        _personInfoTB.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _personInfoTB.scrollEnabled = YES;
        _personInfoTB.backgroundColor = MyBackColor;
    }
    return _personInfoTB;
}


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNav];
    [self createPersonInfoTB];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    _hud = nil;
    DLog(@"dealloc success");

}
#pragma mark - 创建个人信息列表（tableView）

-(void)createNav{
    self.navigationTitle = _infoName;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"ic_register_back"] forState:UIControlStateNormal];
    [self.navigationLeftButton addTarget:self action:@selector(buttonBackToLastView) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *userInfo = SZLInfoHelperManager.userBaseInfo;
    _domain = [[UserBaseInfoModel alloc]initWithDictionary:userInfo];
    
    _userSex = self.domain.user_sex;
    _userPhone = self.domain.user_phone;
    _userMail = self.domain.user_email;
    
}

- (void)createPersonInfoTB{
    
    [self.contentView addSubview:self.personInfoTB];
    [self.personInfoTB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(@0);
    }];
}


#pragma mark - buttonAction
-(void)buttonBackToLastView{
    [self.navigationController popViewControllerAnimated:YES];
    
}



#pragma mark - Afnetworking request
/**
 *  更改性别
 *
 *  @param sex 性别
 */
-(void)changeUserSex:(NSString *)sex{
    __weak PersonInfoViewController * wself = self;

    if (kNetworkNotReachability) {
        [self.view makeToast:kError_Network_NotReachable];
        return;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.color = [UIColor colorWithRed:0 green:0.0 blue:0.0 alpha:0.5];
    _hud.labelText = @"正在更改...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __block ApiRequest *request = [SZLServerHelper changePersonSexRequest:sex callback:^(NSInteger errCode, ApiResponse *response, BOOL success) {
            [wself.requestArr removeObject:request];
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.hud.hidden = YES;
            });
            
            if (success) {
                NSDictionary *data = response.data;
                NSDictionary *userBaseInfo = [data objectForKey:@"dtUserInfo"];
                SZLInfoHelperManager.userBaseInfo = userBaseInfo;
                wself.domain = [[UserBaseInfoModel alloc]initWithDictionary:userBaseInfo];
                [SZLInfoHelperManager JumpAlter:@"更改成功" after:1.0f To:wself.view];
            }else{
              
                [wself.view makeToast:response.errDesc];
            }
            
        }];
        [wself.requestArr addObject:request];
    });
    
}
/**
 *  修改手机号
 *
 *  @param phone 手机号
 */
-(void)changeUserPhone:(NSString *)phone{
    __weak PersonInfoViewController * wself = self;
    if (kNetworkNotReachability) {
        [self.view makeToast:kError_Network_NotReachable];
        return;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.color = [UIColor colorWithRed:0 green:0.0 blue:0.0 alpha:0.5];
    _hud.labelText = @"正在更改...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __block ApiRequest *request = [SZLServerHelper changePersonPhoneRequest:phone callback:^(NSInteger errCode, ApiResponse *response, BOOL success) {
            [wself.requestArr removeObject:request];
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.hud.hidden = YES;
            });
            
            if (success) {
                NSDictionary *data = response.data;
                NSDictionary *userBaseInfo = [data objectForKey:@"dtUserInfo"];
                SZLInfoHelperManager.userBaseInfo = userBaseInfo;
                wself.domain = [[UserBaseInfoModel alloc]initWithDictionary:userBaseInfo];
                [SZLInfoHelperManager JumpAlter:@"更改成功" after:1.5f To:wself.view];
            }else{
                [wself.view makeToast:response.errDesc];
            }
            
        }];
        [wself.requestArr addObject:request];
    });
    
}
/**
 *  修改邮箱
 *
 *  @param email 邮箱号
 */
-(void)changeUserEmail:(NSString *)email{
    __weak PersonInfoViewController * wself = self;
    
    if (kNetworkNotReachability) {
        [self.view makeToast:kError_Network_NotReachable];
        return;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.color = [UIColor colorWithRed:0 green:0.0 blue:0.0 alpha:0.5];
    _hud.labelText = @"正在更改...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __block ApiRequest *request = [SZLServerHelper changePersonEmailRequest:email callback:^(NSInteger errCode, ApiResponse *response, BOOL success) {
            [wself.requestArr removeObject:request];
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.hud.hidden = YES;
            });
            
            if (success) {
                [SZLInfoHelperManager JumpAlter:@"更改成功" after:1.5f To:wself.view];
                NSDictionary *data = response.data;
                NSDictionary *userBaseInfo = [data objectForKey:@"dtUserInfo"];
                SZLInfoHelperManager.userBaseInfo = userBaseInfo;
                wself.domain = [[UserBaseInfoModel alloc]initWithDictionary:userBaseInfo];
            }else{
                [wself.view makeToast:response.errDesc];
            }
            
        }];
        [wself.requestArr addObject:request];
    });
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static    NSString * cellString = @"NewsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    //    如果如果没有多余单元，则需要创建新的单元
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellString];
    }

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"用户名";
            cell.detailTextLabel.text = self.domain.user_name;
            break;
        case 1:
            cell.textLabel.text = @"性别";
            cell.detailTextLabel.text = self.domain.user_sex;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 2:
            cell.textLabel.text = @"部门";
            cell.detailTextLabel.text = self.domain.user_dep_name;
            break;
        case 3:
            cell.textLabel.text = @"岗位";
            cell.detailTextLabel.text = self.domain.user_p_name;
            break;
        case 4:
            cell.textLabel.text = @"手机号";
            cell.detailTextLabel.text = self.domain.user_phone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 5:
            cell.textLabel.text = @"邮箱";
            cell.detailTextLabel.text = self.domain.user_email;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChangeInfoViewController *changeVC = [[ChangeInfoViewController alloc] init];
    
    
    if (indexPath.row == 1) {
        _indexPathOne = indexPath;
        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:@"请选择性别"
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"男", @"女", nil];
        [choiceSheet showInView:self.view];
        
        
    }else if (indexPath.row == 4){
        _indexPathTwo = indexPath;
        changeVC.delegate = self;
        changeVC.changeItemName = @"手机号";
        changeVC.itemString = self.domain.user_phone;
        [self.navigationController pushViewController:changeVC animated:YES];
        
    }else if (indexPath.row == 5){
        _indexPathThree = indexPath;
        changeVC.delegate = self;
        changeVC.changeItemName = @"邮箱";
        changeVC.itemString = self.domain.user_email;
        [self.navigationController pushViewController:changeVC animated:YES];
        
    }else{
    
    }
    
    

}

#pragma mark  --ChangePersonInfoDelegate
- (void)changePersonInfo:(NSString *)personInfo infoType:(int)type{
    if (type == 101) {
        UITableViewCell *cell = [self.personInfoTB cellForRowAtIndexPath:_indexPathTwo];
        cell.detailTextLabel.text = personInfo;
        _userPhone = personInfo;
        //更改手机
        [self changeUserPhone:_userPhone];
        
    }else if (type == 102){
        UITableViewCell *cell = [self.personInfoTB cellForRowAtIndexPath:_indexPathThree];
        cell.detailTextLabel.text = personInfo;
        _userMail = personInfo;
        //更改邮箱
        [self changeUserEmail:_userMail];
    }else{
        
        
        
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .001f;
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UITableViewCell *cell = [self.personInfoTB cellForRowAtIndexPath:_indexPathOne];
    
    if (buttonIndex == 0) {
        // 男
        _userSex = @"男";
        
    } else if (buttonIndex == 1) {
        // 女
        _userSex = @"女";
        
    }
    
    cell.detailTextLabel.text = self.userSex;
    //更改性别
//    [self userChangeInfo];
    [self changeUserSex:_userSex];
}


@end
