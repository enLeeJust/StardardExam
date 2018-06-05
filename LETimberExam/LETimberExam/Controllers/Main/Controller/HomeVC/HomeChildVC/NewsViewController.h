//
//  NewsViewController.h
//  SZLTimber
//
//  Created by Mac on 15/11/26.
//  Copyright © 2015年 timber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimberExam.h"
#import "SZLBaseVC.h"
@interface NewsViewController : SZLBaseVC


@property (copy,nonatomic) NSString *newsOrNoticeType;
@property (assign, nonatomic) long newsOrNoticesNum;
@end
