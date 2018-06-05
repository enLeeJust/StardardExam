//
//  AnswerTextFieldsCell.h
//  LETimberExam
//
//  Created by 桂舟 on 16/11/21.
//  Copyright © 2016年 桂舟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerTextFieldsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *answerIndex;
@property (weak, nonatomic) IBOutlet UITextField *answerContentTF;

@end
