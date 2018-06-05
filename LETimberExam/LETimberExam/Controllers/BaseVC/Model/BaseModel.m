//
//  BaseModel.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/21.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "BaseModel.h"


@implementation BaseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{ @"description_pro" : @"description",
              @"did" : @"id",
              @"switch_on" : @"switch"};
}

- (void)setValuesForKeysWith_MyDict:(NSDictionary *)dict{
    // MJExtension方法
    [self mj_setKeyValues:dict];
}

-(instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        // MJExtension方法
        [self mj_setKeyValues:dict];
    }
    
    return self;
}


@end

@implementation NSObject (TLKeyValue)

- (NSDictionary *)tl_specialJSONObject {
    NSMutableString * tmp = nil;
    
    if ([self isKindOfClass:[NSString class]]) {
        tmp = [(NSString *)self mutableCopy];
    } else if ([self isKindOfClass:[NSData class]]) {
        tmp = [[NSMutableString alloc] initWithData:(NSData *)self encoding:NSUTF8StringEncoding];
    }
    
    NSRange range = [tmp rangeOfString:@"."];
    NSInteger index = 0;
    while (range.location != NSNotFound && index <= tmp.length) {
        NSString * s = [tmp substringWithRange:NSMakeRange(index + range.location - 1, 1)];
        NSInteger a = index + range.location + range.length;
        if (a >= tmp.length) {
            a = tmp.length;
        }
        if ([s isEqualToString:@":"] || [s isEqualToString:@" "] || [s isEqualToString:@"“"]) {
            [tmp insertString:@"0" atIndex:a - 1];
            a++;
        }
        index = a;
        range = [[tmp substringFromIndex:a] rangeOfString:@"."];
    }
    
    return [tmp mj_JSONObject];
}

@end