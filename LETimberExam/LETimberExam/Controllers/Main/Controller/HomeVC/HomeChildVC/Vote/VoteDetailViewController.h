//
//  VoteDetailViewController.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/20.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SZLBaseVC.h"

@class SZLVoteDetailDomain;

typedef void (^VoteCompletionBlock)();

@interface VoteDetailViewController : SZLBaseVC

@property (nonatomic, strong) SZLVoteDetailDomain * detailDomain;

@property (nonatomic, copy) VoteCompletionBlock completion;

@end
