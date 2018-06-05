//
//  NSArray+Util.m
//  SZLTimberTrain
//
//  Created by Apple on 16/10/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NSArray+Util.h"

@implementation NSArray (Util)

- (id)safe_objectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

@end
