//
//  MyGradeViewController.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/12.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "SZLBaseVC.h"

@interface MyGradeViewController : SZLBaseVC<UITableViewDataSource, UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property(nonatomic,retain)NSMutableData *resultData;
@property (strong, nonatomic) UITableView * myGradeTV;
@end
