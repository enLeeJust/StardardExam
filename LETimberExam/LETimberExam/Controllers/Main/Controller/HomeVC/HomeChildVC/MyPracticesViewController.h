//
//  MyPracticesViewController.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/12.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "SZLBaseVC.h"
#import "RADataObject.h"
//#import "AZNotification.h"
#import "PaperInfoModel.h"
@interface MyPracticesViewController : SZLBaseVC

@property(nonatomic,retain)NSMutableData *resultData;
@property (strong, nonatomic) UITableView * myPracticeTbV;

@property(nonatomic,strong)PaperInfoModel *paperInfo;
@end
