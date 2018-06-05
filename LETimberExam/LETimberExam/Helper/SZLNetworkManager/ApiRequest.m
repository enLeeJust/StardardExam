//
//  ApiRequest.m
//  SZLTimber
//
//  Created by 桂舟 on 16/11/2.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "ApiRequest.h"

@implementation ApiRequest{
    NSDictionary * _bizDataDict;
}
@synthesize userId = _userId;
@synthesize bizDataDict = _bizDataDict;

- (id)init {
    self = [super init];
    if (self) {
        self.userId = [SZLInfoHelper shareInstance].userId;
        self.api = PATHAPI;
    }
    return self;
}

- (id)initWithBizData:(NSDictionary *)dictionary {
    self = [self init];
    if(self){
        if (self.userId) {
            NSMutableDictionary * tmpDict = [NSMutableDictionary dictionary];
            tmpDict = dictionary.mutableCopy;
            [tmpDict setObject:self.userId forKey:@"userId"];
            dictionary = [NSDictionary dictionaryWithDictionary:tmpDict];
        }
        self.bizDataDict = dictionary;
    }
    return self;
}

+ (id)requestWithBizData:(NSDictionary *)dictionary {
    return [[ApiRequest alloc] initWithBizData:dictionary];
}


@end
