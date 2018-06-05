//
//  TabBarBtn.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BadgeLabel;

@interface TabBarBtn : UIButton

@property (nonatomic,strong) BadgeLabel * badgeLabel;
@property (nonatomic,assign) NSInteger  unreadCount;

@end
