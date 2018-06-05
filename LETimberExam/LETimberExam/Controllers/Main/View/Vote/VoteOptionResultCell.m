//
//  VoteOptionResultCell.m
//  SZLTimberTrain
//
//  Created by Apple on 16/9/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "VoteOptionResultCell.h"
#import "SZLVoteContentDomain.h"

typedef NS_ENUM(NSInteger, DisplayType) {
    DisplayTypeNormal,
    DisplayTypePersonal
};

@interface VoteOptionResultCell ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIProgressView * optionProgressView;
@property (nonatomic, strong) UILabel * resultLabel;

@property (nonatomic, assign) DisplayType displayType;

@end

@implementation VoteOptionResultCell

#pragma mark - setter & getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = MyTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _titleLabel.text = @"投票内容";
    }
    return _titleLabel;
}

- (UIProgressView *)optionProgressView {
    if (!_optionProgressView) {
        _optionProgressView = [[UIProgressView alloc]init];
        _optionProgressView.transform=CGAffineTransformMakeScale(1.0, 8.0);
        [_optionProgressView setRadiusTrackColor:[UIColor colorWithHexString:@"e5e5e5"] progressColor:[UIColor colorWithHexString:@"bcbcbc"]];
        [_optionProgressView setProgress:.25f];
    }
    return _optionProgressView;
}

- (UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc]init];
        _resultLabel.textColor = [UIColor colorWithHexString:@"bcbcbc"];
        _resultLabel.font = [UIFont systemFontOfSize:13.0f];
        _resultLabel.textAlignment = NSTextAlignmentRight;
        _resultLabel.text = @"5 (25%)";
    }
    return _resultLabel;
}

- (void)setDisplayType:(DisplayType)displayType {
    _displayType = displayType;
    if (displayType == DisplayTypeNormal) {
        [self.optionProgressView setRadiusTrackColor:[UIColor colorWithHexString:@"e5e5e5"] progressColor:[UIColor colorWithHexString:@"bcbcbc"]];
    }else if (displayType == DisplayTypePersonal) {
        [self.optionProgressView setRadiusTrackColor:[UIColor colorWithHexString:@"fdd7b2"] progressColor:[UIColor colorWithHexString:@"ff8309"]];
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)configView {
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.leading.equalTo(@12);
        make.trailing.equalTo(@-12);
    }];
    
    [self.contentView addSubview:self.resultLabel];
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(@12);
        make.trailing.equalTo(@-12);
    }];
    
    [self.contentView addSubview:self.optionProgressView];
    [self.optionProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.resultLabel.centerY);
        make.leading.equalTo(@12);
        make.trailing.equalTo(self.resultLabel.leading).with.offset(@-8);
    }];
}

- (void)configCellDataWithDomain:(SZLVoteContentDetailDomain *)domain totalCount:(NSInteger)totalCount {
    self.titleLabel.text = domain.sub_body;
    
    CGFloat progress = (CGFloat)domain.length / (CGFloat)totalCount;
    if (totalCount == 0) {
        progress = 0;
    }
    [self.optionProgressView setProgress:progress];
    
    NSString * percentStr = [NSString stringWithFormat:@"%.lf", progress*100];
    
    self.resultLabel.text = [NSString stringWithFormat:@"%@ (%@%%)", @(domain.length), percentStr];
    
    if (domain.status == 1) {
        self.displayType = DisplayTypePersonal;
    }else{
        self.displayType = DisplayTypeNormal;
    }
    
    //计算结果文字最大宽度 配合左侧相同宽度进度条的显示
    NSString * maxLengthStr = [NSString stringWithFormat:@"%@ (100%%)", @(totalCount)];
    CGSize resultSize = [maxLengthStr calculateSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) font:self.resultLabel.font];
    
    [self.resultLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(resultSize.width);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
