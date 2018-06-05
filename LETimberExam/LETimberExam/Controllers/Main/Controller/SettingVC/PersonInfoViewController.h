//
//  PersonInfoViewController.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/28.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "SZLBaseVC.h"
@protocol ChangePersonInfoDelegate <NSObject>

- (void)changePersonInfo:(NSString *)personInfo infoType:(int)type;

@end
@interface PersonInfoViewController : SZLBaseVC<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@property (nonatomic,copy) NSString *infoName;
@property (strong, nonatomic) UITableView *personInfoTB;
@end
