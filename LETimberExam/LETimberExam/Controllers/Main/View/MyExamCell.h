//
//  MyExamCell.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/14.
//  Copyright © 2016年 timber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyExamCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *examTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *examTotalScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *examPassScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *examTimeCostLabel;
@property (weak, nonatomic) IBOutlet UILabel *examTimesLabel;
@property (weak, nonatomic) IBOutlet UILabel *examDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *examResultIV;
@property (weak, nonatomic) IBOutlet UIImageView *examStatusIV;

@end
