//
//  NSArray+Util.h
//  SZLTimberTrain
//
//  Created by Apple on 16/10/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Util)

/*!
 @method    objectAtIndexCheck:
 @abstract  检查是否越界和NSNull如果是返回nil
 @result    返回对象
 */
- (id)safe_objectAtIndex:(NSUInteger)index;

@end
