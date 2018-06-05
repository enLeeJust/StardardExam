//
//  SZLVoteContentDomain.h
//  SZLTimberTrain
//
//  Created by Apple on 16/11/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BaseModel.h"

@class SZLVoteContentDetailDomain;

@interface SZLVoteContentDomain : BaseModel

@property (nonatomic, copy) NSString * vote_title;

@property (nonatomic, copy) NSString * type_name;

@property (nonatomic, copy) NSString * vote_remark;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, copy) NSArray <SZLVoteContentDetailDomain *>* dtcourse;

@end



@interface SZLVoteContentDetailDomain : BaseModel

@property (nonatomic, assign) NSInteger sub_id;

@property (nonatomic, copy) NSString * sub_body;

@property (nonatomic, assign) NSInteger length;

@property (nonatomic, assign) NSInteger status;

@end
