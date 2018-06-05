//
//  SZLVoteListDomain.m
//  SZLTimberTrain
//
//  Created by Apple on 16/11/1.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SZLVoteListDomain.h"

@implementation SZLVoteListDomain

- (void)setDtcourse:(NSArray<SZLVoteDetailDomain *> *)dtcourse {
    if (NOT_NULL(dtcourse)) {
        _dtcourse = [dtcourse mapWithBlock:^id(id item, NSInteger idx) {
            if (INSTANCE_OF(item, NSDictionary)) {
                return [[SZLVoteDetailDomain alloc]initWithDictionary:item];
            }else if (INSTANCE_OF(item, SZLVoteDetailDomain)){
                return item;
            }
            return nil;
        }];
    }
}

@end


@implementation SZLVoteDetailDomain

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"vote_id" : @"VOTE_ID",
             @"vote_title" : @"VOTE_TITLE",
             @"type_name" : @"TYPE_NAME",
             @"vote_end_time" : @"VOTE_END_TIME",
             @"vote_length" : @"VOTE_LENGTH",
             @"status" : @"STATUS"};
}

@end