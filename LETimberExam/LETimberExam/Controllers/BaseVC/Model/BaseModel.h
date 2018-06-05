//
//  BaseModel.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/21.
//  Copyright © 2016年 timber. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MJExtension.h"
//#import "NSArray+Fp.h"
//#import "RMMapper.h"

@interface BaseModel : NSObject
/**
 *  通过字典初始化模型
 *
 *  @param dict 字典
 *
 *  @return 模型实例
 */
- (instancetype)initWithDictionary:(NSDictionary *)dict;

/**
 *  通过字典给模型复制
 *
 *  @param dict 字典
 */
- (void)setValuesForKeysWith_MyDict:(NSDictionary *)dict;
@end

@interface NSObject (TLKeyValue)

/**
 *  处理服务器返回的特殊json字符串
 *
 *  @return 对应的字典
 */
- (NSDictionary *)tl_specialJSONObject;

@end