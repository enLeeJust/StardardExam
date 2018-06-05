//
//  UserInfoTableViewCell.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/22.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "UserInfoTableViewCell.h"

@implementation UserInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _divideLineView = [[UIView alloc] initWithFrame:CGRectMake(5, self.v_size.height-1, WIDTH-10, 1)];
    _divideLineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    [self addSubview:_divideLineView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UIView *)drawDivideLineView{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH-10, 0.5)];
    line.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    return line;
}

@end
