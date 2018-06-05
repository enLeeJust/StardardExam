//
//  MySettingVC.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/22.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "SZLBaseVC.h"
#import "VPImageCropperViewController.h"
@interface MySettingVC : SZLBaseVC<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate>
@property (nonatomic, strong) UIImage *userheadImg;//头像
@end
