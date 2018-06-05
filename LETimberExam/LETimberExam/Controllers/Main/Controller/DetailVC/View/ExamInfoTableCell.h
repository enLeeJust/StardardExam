//
//  ExamInfoTableCell.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/22.
//  Copyright © 2016年 timber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExamInfoTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *examResultInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *examResultInfoDetailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *noticeIV;
@property (strong, nonatomic) UIView *divideLineView;
@end
