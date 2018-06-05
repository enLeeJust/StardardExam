//
//  VoteOptionResultCell.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SZLVoteContentDetailDomain;

@interface VoteOptionResultCell : UITableViewCell

- (void)configCellDataWithDomain:(SZLVoteContentDetailDomain *)domain totalCount:(NSInteger)totalCount;

@end
