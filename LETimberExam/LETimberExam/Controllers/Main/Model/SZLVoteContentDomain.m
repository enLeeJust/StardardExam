//
//  SZLVoteContentDomain.m
//  SZLTimberTrain
//
//  Created by Apple on 16/11/2.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SZLVoteContentDomain.h"

@implementation SZLVoteContentDomain

- (void)setDtcourse:(NSArray<SZLVoteContentDetailDomain *> *)dtcourse {
    if (NOT_NULL(dtcourse)) {
        _dtcourse = [dtcourse mapWithBlock:^id(id item, NSInteger idx) {
            if (INSTANCE_OF(item, NSDictionary)) {
                return [[SZLVoteContentDetailDomain alloc]initWithDictionary:item];
            }else if (INSTANCE_OF(item, SZLVoteContentDetailDomain)){
                return item;
            }
            return nil;
        }];
    }
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"vote_title" : @"VOTE_TITLE",
             @"type_name" : @"TYPE_NAME",
             @"vote_remark" : @"VOTE_REMARK",
             @"count" : @"COUNT"};
}

@end


@implementation SZLVoteContentDetailDomain

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"sub_id" : @"SUB_ID",
             @"sub_body" : @"SUB_BODY",
             @"length" : @"LENGTH",
             @"status" : @"STATUS"};
}

@end
