//
//  ApiInvoker.h
//  SZLTimber
//
//  Created by 桂舟 on 16/11/2.
//  Copyright © 2016年 timber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApiRequest.h"
@interface ApiInvoker : NSObject
@property (nonatomic, copy) NSString * apiBaseUrl;
/** 请求超时秒数 */
@property (nonatomic, assign) NSInteger timeoutSeconds;

- (void)invokerApiRequest:(ApiRequest *)apiRequest callback:(API_CALLBACK)callback;

- (void)invokerApiRequest:(ApiRequest *)apiRequest withMethod:(NSString *)httpMethod callback:(API_CALLBACK)callback;


- (void)handleError:(NSInteger)statusCode apiRequest:(ApiRequest *)apiRequest response:(ApiResponse *)apiResponse;
- (void)handleError:(NSInteger)statusCode apiRequest:(ApiRequest *)apiRequest response:(ApiResponse *)apiResponse error:(NSError *)error;

- (void)addRequest:(ApiRequest *)apiRequest;

- (void)removeAllRequest;
-(void)removeRequest:(ApiRequest *)apiRequest;

- (void)cancelAllRequest;
- (void)cancelAllRequestExcept:(ApiRequest *)apiRequest;

- (void)reRequest:(ApiRequest *)apiRequest;
- (void)reRequestAllRequest;



@end
