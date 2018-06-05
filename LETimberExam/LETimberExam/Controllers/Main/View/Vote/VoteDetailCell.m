//
//  VoteDetailCell.m
//  SZLTimberTrain
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "VoteDetailCell.h"
#import "SZLVoteListDomain.h"

@interface VoteDetailCell ()

@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *voteNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleCountLabel;

@end

@implementation VoteDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (highlighted) {
        self.detailView.backgroundColor = MySelectedColor;
    }else{
        self.detailView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)configCellDataWithDomain:(SZLVoteDetailDomain *)domain {
    self.voteNameLabel.text = domain.vote_title;
    self.voteTypeLabel.text = domain.type_name;
    self.voteDateLabel.text = [NSDate shortTimeStringWithFullTimeString:domain.vote_end_time];
    self.peopleCountLabel.text = [NSString stringWithFormat:@"已有%ld人参与", (long)domain.vote_length];
}

+ (CGFloat)configCellHeightWithDomain:(SZLVoteDetailDomain *)domain {
    CGFloat orignHeight = 100.0f;
    CGSize nameSize = [domain.vote_title calculateSize:CGSizeMake(WIDTH-12-11-8-12, 999) font:[UIFont systemFontOfSize:16.0f]];
    
    if (nameSize.height > 20) {
        return orignHeight + nameSize.height - 20;
    }
    return orignHeight;
}

@end
