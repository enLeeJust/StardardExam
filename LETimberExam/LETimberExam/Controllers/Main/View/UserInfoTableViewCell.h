//
//  UserInfoTableViewCell.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/22.
//  Copyright © 2016年 timber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userInfoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userCachLabel;
@property (weak, nonatomic) IBOutlet UILabel *logoutLabel;
@property (strong, nonatomic)  UIView *divideLineView;

@end
