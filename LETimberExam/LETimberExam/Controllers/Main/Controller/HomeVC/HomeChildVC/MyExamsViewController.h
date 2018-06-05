//
//  MyExamsViewController.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/12.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "SZLBaseVC.h"
#import "RADataObject.h"

//@protocol ChangePaperRemainTimesDelegate <NSObject>
//- (void)ChangePaperRemainTimes:(NSInteger )remianTimes;
//@end

@interface MyExamsViewController : SZLBaseVC
@property(nonatomic,retain)NSMutableData *resultData;
@property (strong, nonatomic) UITableView * noticeListTbV;

@end
