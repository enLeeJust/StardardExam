//
//  VoteOptionCell.m
//  SZLTimberTrain
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "VoteOptionCell.h"

@interface VoteOptionCell ()

@end

@implementation VoteOptionCell

#pragma mark - Setter & Getter
- (UIButton *)pickBtn {
    if (!_pickBtn) {
        _pickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pickBtn.userInteractionEnabled = NO;
        [_pickBtn setImage:[UIImage imageNamed:@"ic_vote_pick_unseleted"] forState:UIControlStateNormal];
        if (self.optionType == VoteOptionTypeSingle) {
            [_pickBtn setImage:[UIImage imageNamed:@"ic_vote_pick_single_selected"] forState:UIControlStateSelected];
        }else if (self.optionType == VoteOptionTypeMultiple) {
            [_pickBtn setImage:[UIImage imageNamed:@"ic_vote_pick_multiple_selected"] forState:UIControlStateSelected];
        }
    }
    return _pickBtn;
}

- (UILabel *)optionLabel {
    if (!_optionLabel) {
        _optionLabel = [[UILabel alloc]init];
        _optionLabel.textColor = MyTextColor;
        _optionLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return _optionLabel;
}

- (void)setOptionType:(VoteOptionType)optionType {
    _optionType = optionType;
}

#pragma mark - init & setup
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)configView {
    [self.contentView addSubview:self.pickBtn];
    [self.pickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.width.height.equalTo(@24);
        make.trailing.equalTo(-(self.contentMargin+12));
    }];
    
    [self.contentView addSubview:self.optionLabel];
    [self.optionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.centerY);
        make.leading.equalTo(self.contentMargin+12);
        make.trailing.equalTo(self.pickBtn.leading).with.offset(@8);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.pickBtn.selected = selected;
}

@end
