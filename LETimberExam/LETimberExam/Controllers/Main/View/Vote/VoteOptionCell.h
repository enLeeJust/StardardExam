//
//  VoteOptionCell.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BaseBorderCell.h"

typedef NS_ENUM(NSInteger, VoteOptionType) {
    VoteOptionTypeSingle,
    VoteOptionTypeMultiple
};

@interface VoteOptionCell : BaseBorderCell

@property (nonatomic, strong) UILabel * optionLabel;
@property (nonatomic, strong) UIButton * pickBtn;

@property (nonatomic, assign) VoteOptionType optionType;

@end
