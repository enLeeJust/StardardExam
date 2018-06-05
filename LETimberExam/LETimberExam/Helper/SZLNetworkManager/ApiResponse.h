//
//  ApiResponse.h
//  SZLTimber
//
//  Created by 桂舟 on 16/11/2.
//  Copyright © 2016年 timber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiResponse : NSObject

/** 成功失败的标志 */
@property (nonatomic, assign) BOOL success;
/** 错误码 */
@property (nonatomic, assign) NSInteger errCode;
/** 返回消息文本 */
@property (nonatomic, strong) NSString * errDesc;
/** 总数目 */
@property (nonatomic, assign) NSInteger total;
/** 本次数目 */
@property (nonatomic, assign) NSInteger subtotal;
/** 业务数据 */
@property (nonatomic, strong) id data;
/** 本次数目 */
@property (nonatomic, assign) NSInteger remianTimes;

/** 本次数目 */
@property (nonatomic, assign) float getPoint;
/** dict -> model */
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
