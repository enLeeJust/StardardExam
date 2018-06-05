//
//  MySettingVC.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/22.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "MySettingVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UserInfoTableViewCell.h"
#import "PersonInfoViewController.h"//个人资料
#import "ChangePwdViewController.h"//修改密码
#import "AboutAppViewController.h"//关于
#import "SZLSandBoxPath.h"
#import "SZLCleanCaches.h"
#import "UserBaseInfoModel.h"
#import "GTMBase64.h"
#define ORIGINAL_MAX_WIDTH 640.0f


@interface MySettingVC ()
@property (nonatomic, strong) UITableView *userInfoTabel;
@property (nonatomic, strong) UILabel *userNamelabel;//用户名
@property (nonatomic, strong) UILabel *userDesLabel;//角色
@property (nonatomic, strong) UIImageView *userheadImgView;//头像

@property (nonatomic, assign) float cachesTotal;//缓存
@property (nonatomic, strong) UserBaseInfoModel* userInfo;//个人信息
@property (nonatomic, strong) MBProgressHUD *hud;//

@end

@implementation MySettingVC


#pragma mark lazyLoading
-(UITableView *)userInfoTabel{
    if (!_userInfoTabel) {
        _userInfoTabel = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
        
        _userInfoTabel.delegate = self;
        _userInfoTabel.dataSource = self;
        _userInfoTabel.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _userInfoTabel;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _userInfo = [[UserBaseInfoModel alloc] initWithDictionary:SZLInfoHelperManager.userBaseInfo];
    [self createNav];
    [self createUserInfoTabel];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    DLog(@"dealloc success");

}

#pragma mark - 创建Nav
-(void)createNav{
    self.navigationTitle = @"我的设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"ic_register_back"] forState:UIControlStateNormal];
    
    [self.navigationLeftButton addTarget:self action:@selector(buttonBackToLastView) forControlEvents:UIControlEventTouchUpInside];
}

-(void)createUserInfoTabel{
    _cachesTotal = [SZLCleanCaches sizeWithFilePath:[SZLSandBoxPath getCachesDirectory]];
    
    [self.contentView addSubview:self.userInfoTabel];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,WIDTH, 160)];
    headView.backgroundColor = MyBlue;
    
    //头像
    _userheadImgView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/2-50, 10,100, 100)];

    [self loadPortrait];
    _userheadImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_userheadImgView.layer setCornerRadius:(_userheadImgView.frame.size.height/2)];
    [_userheadImgView.layer setMasksToBounds:YES];
    [_userheadImgView setContentMode:UIViewContentModeScaleAspectFill];
    [_userheadImgView setClipsToBounds:YES];
    _userheadImgView.layer.shadowColor = [UIColor blackColor].CGColor;
    _userheadImgView.layer.shadowOffset = CGSizeMake(4, 4);
    _userheadImgView.layer.shadowOpacity = 0.5;
    _userheadImgView.layer.shadowRadius = 2.0;
    _userheadImgView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _userheadImgView.layer.borderWidth = 2.0f;
    _userheadImgView.userInteractionEnabled = YES;

    UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
    [_userheadImgView addGestureRecognizer:portraitTap];
    [headView addSubview:_userheadImgView];
    
//创建nameLabel
    _userNamelabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, WIDTH-20, 20)];
    _userNamelabel.textAlignment = NSTextAlignmentCenter;
    _userNamelabel.textColor = WhiteColor;
    _userNamelabel.font = [UIFont fontWithName:@"Arial" size:16];
    _userNamelabel.text = self.userInfo.user_name;
 
    
    [headView addSubview:_userNamelabel];
//创建职位Label
    _userDesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 140,WIDTH-20, 20)];
    _userDesLabel.textAlignment = NSTextAlignmentCenter;
    _userDesLabel.textColor = WhiteColor;
    _userDesLabel.font = [UIFont fontWithName:@"Arial" size:14];
    _userDesLabel.text = [NSString stringWithFormat:@"角色：%@",self.userInfo.user_role_name];
    [headView addSubview:_userDesLabel];
    
    _userInfoTabel.tableHeaderView = headView;
    
}

#pragma mark - action
-(void)buttonBackToLastView{
    [self.navigationController popViewControllerAnimated:YES];
    
}
/**
 *  点击头像
 */
- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.contentView];
}

/**
 *  加载头像
 */
- (void)loadPortrait {
    __weak MySettingVC *wself = self;
    __block NSURL *portraitUrl = [NSURL URLWithString:wself.userInfo.user_pic];
//    __block UIImage *protraitImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:portraitUrl]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [wself.userheadImgView sd_setImageWithURL:portraitUrl placeholderImage:wself.userheadImg];
        
//           wself.userheadImgView.image = protraitImg;
            
        });
    });
}

/**
 *  退出登录
 *
 *  点击退出登录按钮事件
 */
-(void)userLogoutTheAccount{

    SZLInfoHelperManager.isLogin = NO;
    [AppDelegate setRootViewController:APPDELEGATE.loginNavc fromController:self isLogin:NO];
}

#pragma mark --UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if (buttonIndex == 0) {
        // 拍照
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        picker.mediaTypes = mediaTypes;
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            
            if ([self isFrontCameraAvailable]) {
                picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            picker.delegate = self;
            [self presentViewController:picker
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }else{
            UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"相机不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [av show];
        }
        
    } else if (buttonIndex == 1) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        picker.mediaTypes = mediaTypes;
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            [self presentViewController:picker
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }else{
            UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"相册不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            [av show];
        }
        
        
    }
}




#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    __weak MySettingVC *wself = self;
    
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [wself imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, wself.view.frame.size.width, wself.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = wself;
        
        
        [wself presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
        
    }];
    
    
}

#pragma mark - VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    _userheadImgView.image = editedImage;
    __weak MySettingVC *wself = self;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        NSData *data = UIImagePNGRepresentation(editedImage);
        NSString *encodedImageStr = [GTMBase64 stringByEncodingData:data];
        
       //上传服务器
        [wself changeHeadImgRequest:encodedImageStr];
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - Afnetworking request
/**
 *  更改用户头像
 *
 *  @param picStr 头像图片转base64字符串
 */
-(void)changeHeadImgRequest:(NSString*)picStr{
    __weak MySettingVC * wself = self;
    
    if (kNetworkNotReachability) {
        [self.view makeToast:kError_Network_NotReachable];
        return;
    }
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.color = [UIColor colorWithRed:0 green:0.0 blue:0.0 alpha:0.5];
    _hud.labelText = @"正在修改...";
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        __block ApiRequest *request = [SZLServerHelper changePersonHeadViewRequest:picStr callback:^(NSInteger errCode, ApiResponse *response, BOOL success) {
            [wself.requestArr removeObject:request];
            dispatch_async(dispatch_get_main_queue(), ^{
                wself.hud.hidden = YES;
            });
            
            if (success) {

                NSDictionary *data = response.data;
                NSDictionary *userBaseInfo = [data objectForKey:@"dtUserInfo"];
                SZLInfoHelperManager.userBaseInfo = userBaseInfo;
                wself.userInfo = [[UserBaseInfoModel alloc] initWithDictionary:SZLInfoHelperManager.userBaseInfo];
                
//                if ([[[SDWebImageManager sharedManager] imageCache] diskImageExistsWithKey:wself.userInfo.user_pic]) {
//                    [[[SDWebImageManager sharedManager] imageCache] removeImageForKey:wself.userInfo.user_pic];
//                }
                
                [[SDWebImageManager sharedManager].imageCache diskImageExistsWithKey:wself.userInfo.user_pic completion:^(BOOL isInCache) {
                    
                    if (isInCache) {
                        [[SDWebImageManager sharedManager].imageCache removeImageForKey:wself.userInfo.user_pic fromDisk:YES withCompletion:^{
                            
                        }];
                    }
                    
                }];
                
                
                
                [SZLInfoHelperManager JumpAlter:@"修改成功" after:1.0f To:wself.view];
            }else{
                
//                [SZLInfoHelperManager JumpAlter:@"修改失败" after:1.0f To:wself.view];
                [wself.view makeToast:response.errDesc];
            }
            
        }];
        [wself.requestArr addObject:request];
    });
    
}


#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}
#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark TabelViewData Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //    return trainName.count;
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 3.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}
//根据是否展开返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
    
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    
    static    NSString * cellString = @"NewsCell";
    UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"UserInfoTableViewCell" owner:self options:nil];
        cell = [nibViews objectAtIndex:0];
    }
    
    if (section == 0) {
        if (indexPath.row == 0) {
            cell.userInfoNameLabel.text = @"个人资料";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 1){
            cell.userInfoNameLabel.text = @"修改密码";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.divideLineView.hidden = YES;
        }
    }else if (section == 1) {
        if (indexPath.row == 0) {
            cell.userInfoNameLabel.text = @"清空缓存";
            cell.userCachLabel.text = [NSString stringWithFormat:@"%0.2fM",self.cachesTotal];
        }else if (indexPath.row == 1){
            cell.userInfoNameLabel.text = @"关于";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.divideLineView.hidden = YES;
        }
    }else{
//        UIButton *logoutBtn = [[UIButton alloc] initWithFrame:cell.contentView.frame];
//        [cell.contentView addSubview:logoutBtn];
        cell.logoutLabel.text = @"退出登录";
        cell.divideLineView.hidden = YES;
        
    }
    
    
    
    return cell;
    
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        if (indexPath.row == 0) {//个人资料
            PersonInfoViewController *detailVC = [[PersonInfoViewController alloc] init];
            detailVC.infoName = @"个人资料";
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if (indexPath.row == 1) {//修改密码
            ChangePwdViewController *changePwdVC = [[ChangePwdViewController alloc] init];
            changePwdVC.changeItemName = @"修改密码";
            [self.navigationController pushViewController:changePwdVC animated:YES];
        }else{}
        
        
    }else if (section == 1) {
        if (indexPath.row == 0) {//清空缓存
            NSString * messageStr = @"确认清除缓存？";
            __weak MySettingVC *wself = self;
            [JCAlertView showTwoButtonsWithTitle:@"温馨提示" Message:messageStr ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"取消" Click:^{
            } ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:@"确定" Click:^{
                //清空缓存
                [SZLCleanCaches clearCacheAtPath:[SZLSandBoxPath getCachesDirectory]];
                wself.cachesTotal = [SZLCleanCaches sizeWithFilePath:[SZLSandBoxPath getCachesDirectory]];
                [self.userInfoTabel reloadData];
                
            }];
            
        }else if (indexPath.row == 1) {//关于
            AboutAppViewController  *aboutAppVC = [[AboutAppViewController alloc] init];

            [self.navigationController pushViewController:aboutAppVC animated:YES];
            
        }else{
        }
        
        
    }else{
        [JCAlertView showTwoButtonsWithTitle:@"温馨提示" Message:@"是否确定退出当前账号" ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"取消" Click:^{
        } ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:@"确定" Click:^{
            // 退出登录
            [self userLogoutTheAccount];
            
            
        }];
    }

}


@end
