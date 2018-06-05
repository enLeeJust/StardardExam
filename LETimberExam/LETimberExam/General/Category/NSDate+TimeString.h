//
//  NSDate+TimeString.h
//  SZLTimberTrain
//
//  Created by Apple on 16/10/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TimeString)

+ (NSString *)currentStandardTime;

+ (NSString *)shortTimeStringWithFullTimeString:(NSString *)timeString;

+ (NSString *)getCompleteTimeStringWithTotalSecond:(NSInteger)sec;

@end
