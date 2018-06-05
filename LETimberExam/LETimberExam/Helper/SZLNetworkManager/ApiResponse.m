//
//  ApiResponse.m
//  SZLTimber
//
//  Created by 桂舟 on 16/11/2.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "ApiResponse.h"

@implementation ApiResponse
@synthesize errCode = _errCode;
@synthesize errDesc = _errDesc;
@synthesize data = _data;

- (id)initWithDictionary:(NSDictionary*)dictionary {
    if (!self) {
        self = [[ApiResponse alloc]init];
    }
    
    if ([[dictionary allKeys]containsObject:@"errCode"]) {
        NSString * errCode = [dictionary objectForKey:@"errCode"];
        if (errCode != (id)[NSNull null]) {
            self.errCode = [errCode integerValue];
        }
        if (self.errCode == 0) {
            self.success = YES;
        }else{
            self.success = NO;
        }
    }
    
    if ([[dictionary allKeys]containsObject:@"errDesc"]) {
        self.errDesc = [dictionary objectForKey:@"errDesc"];
    }
    
    if ([[dictionary allKeys] containsObject:@"total"]) {
        self.total = [[dictionary objectForKey:@"total"] integerValue];
    }
    
    if ([[dictionary allKeys] containsObject:@"subtotal"]) {
        self.subtotal = [[dictionary objectForKey:@"subtotal"] integerValue];
    }
    
    if ([[dictionary allKeys] containsObject:@"data"]) {
        self.data = [dictionary objectForKey:@"data"];
    }
    if ([[dictionary allKeys] containsObject:@"more"]) {
        self.remianTimes = [[dictionary objectForKey:@"more"] integerValue];
    }
    if ([[dictionary allKeys] containsObject:@"Pointe"]) {
        self.getPoint = [[dictionary objectForKey:@"Pointe"] floatValue];
    }
    
    return self;
}

- (NSString *)errDesc {
    if(_errDesc == (id) [NSNull null]){
        return nil;
    }
    return _errDesc;
}


@end
