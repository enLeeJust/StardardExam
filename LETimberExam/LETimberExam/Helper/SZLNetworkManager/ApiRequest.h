//
//  ApiRequest.h
//  SZLTimber
//
//  Created by 桂舟 on 16/11/2.
//  Copyright © 2016年 timber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiResponse.h"
#import <AFHTTPSessionManager.h>
typedef void(^API_CALLBACK)(NSInteger errCode,ApiResponse *response,BOOL success);

@interface ApiRequest : NSObject

/** 用户id */
@property (nonatomic, copy) NSString * userId;
/** 重试次数 */
@property (nonatomic, assign) NSInteger retryCount;
/** 接口回调 */
@property (nonatomic, copy) API_CALLBACK callback;
/** 业务请求参数 */
@property (nonatomic, strong) NSDictionary * bizDataDict;
@property (nonatomic, strong) NSURLSessionTask * task;
//@property(nonatomic,strong)AFHTTPSessionManager * manage;
@property (nonatomic, strong) NSString * api;

/**
 *  快速创建请求实例
 *
 *  @param dictionary 请求参数
 *
 *  @return 请求实例
 */
+ (id)requestWithBizData:(NSDictionary *)dictionary;


@end
