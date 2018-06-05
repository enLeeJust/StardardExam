//
//  MyPracticeLogCell.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/14.
//  Copyright © 2016年 timber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPracticeLogCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *joinTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *useTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *practiceScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *practiceRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *practiceWrongLabel;
@property (weak, nonatomic) IBOutlet UILabel *practiceUndoLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *showPointImageView;

@end
