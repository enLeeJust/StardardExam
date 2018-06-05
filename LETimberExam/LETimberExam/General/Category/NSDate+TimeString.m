//
//  NSDate+TimeString.m
//  SZLTimberTrain
//
//  Created by Apple on 16/10/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NSDate+TimeString.h"

@implementation NSDate (TimeString)

+ (NSString *)currentStandardTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * dateTime = [dateFormatter stringFromDate:[NSDate date]];
    return dateTime;
}

+ (NSString *)shortTimeStringWithFullTimeString:(NSString *)timeString {
    NSArray * times = [timeString componentsSeparatedByString:@" "];
    NSString * replacedStr = [[times firstObject] stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    return replacedStr;
}

+ (NSString *)getCompleteTimeStringWithTotalSecond:(NSInteger)sec {
    NSInteger seconds = sec % 60;
    NSInteger minutes = (sec / 60) % 60;
    NSInteger hours = sec / 3600;
    NSString * time;
    if (seconds == 0) {
        time = @"未学习";
    }else{
        if (minutes == 0) {
            time = [NSString stringWithFormat:@"已学%@秒", @(seconds)];
        }else{
            if (hours == 0) {
                time = [NSString stringWithFormat:@"已学%@分%@秒", @(minutes), @(seconds)];
            }else{
                time = [NSString stringWithFormat:@"已学%@小时%@分%@秒", @(hours), @(minutes), @(seconds)];
            }
        }
    }
    return time;
}

@end
