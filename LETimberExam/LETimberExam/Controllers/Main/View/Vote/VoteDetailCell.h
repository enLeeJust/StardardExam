//
//  VoteDetailCell.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SZLVoteDetailDomain;

@interface VoteDetailCell : UITableViewCell

- (void)configCellDataWithDomain:(SZLVoteDetailDomain *)domain;

+ (CGFloat)configCellHeightWithDomain:(SZLVoteDetailDomain *)domain;

@end
