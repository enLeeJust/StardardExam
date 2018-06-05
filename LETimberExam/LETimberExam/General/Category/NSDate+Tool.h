//
//  NSDate+Tool.h
//  SZLTimberTrain
//
//  Created by Apple on 16/11/8.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Tool)

/**
 *  判断是否超过当前时间
 *
 *  @param date 时间字符串
 *
 *  @return 是否超过
 */
+ (BOOL)isBeyondNowWithDateString:(NSString *)date;

@end
