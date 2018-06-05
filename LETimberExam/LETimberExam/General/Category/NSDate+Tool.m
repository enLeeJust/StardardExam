//
//  NSDate+Tool.m
//  SZLTimberTrain
//
//  Created by Apple on 16/11/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NSDate+Tool.h"

@implementation NSDate (Tool)

+ (BOOL)isBeyondNowWithDateString:(NSString *)date {
    NSDate * today = [NSDate date];
    
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * end = [dateFormat dateFromString:date];
    
    if ([today compare:end] == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

@end
