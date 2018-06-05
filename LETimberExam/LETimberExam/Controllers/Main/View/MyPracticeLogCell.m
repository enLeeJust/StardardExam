//
//  MyPracticeLogCell.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/14.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "MyPracticeLogCell.h"

@implementation MyPracticeLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.backgroundColor = MyBackColor;
    [self.bgView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.bgView.layer setBorderWidth:1];
    [self.bgView.layer setMasksToBounds:YES];
    self.bgView.layer.cornerRadius = 15.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
