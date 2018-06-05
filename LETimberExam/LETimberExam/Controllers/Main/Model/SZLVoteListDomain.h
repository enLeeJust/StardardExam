//
//  SZLVoteListDomain.h
//  SZLTimberTrain
//
//  Created by Apple on 16/11/1.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BaseModel.h"

@class SZLVoteDetailDomain;

@interface SZLVoteListDomain : BaseModel

@property (nonatomic, copy) NSArray <SZLVoteDetailDomain *>* dtcourse;

@end



@interface SZLVoteDetailDomain : BaseModel

/** 投票ID */
@property (nonatomic, assign) NSInteger vote_id;
/** 投票标题 */
@property (nonatomic, copy) NSString * vote_title;
/** 投票类型 */
@property (nonatomic, copy) NSString * type_name;
/** 投票结束时间 */
@property (nonatomic, copy) NSString * vote_end_time;
/** 投票人数 */
@property (nonatomic, assign) NSInteger vote_length;
/** 是否投票了 */
@property (nonatomic, assign) NSInteger status;

@end
