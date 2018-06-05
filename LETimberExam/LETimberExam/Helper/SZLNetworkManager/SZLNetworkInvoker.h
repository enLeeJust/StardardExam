//
//  SZLNetworkInvoker.h
//  SZLTimberTrain
//
//  Created by Apple on 16/10/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ApiResponse;
@class ApiRequest;

typedef void (^API_CALLBACK)(NSInteger errCode, ApiResponse * response, BOOL success);

@protocol SZLNetworkApiInvokerDelegate;

@interface SZLNetworkInvoker : NSObject

- (void)request:(NSURLRequest *)request apiRequest:(ApiRequest *)apiRequest callback:(API_CALLBACK)callback;

+ (id)apiInvokerWithBaseUrl:(NSString *)baseUrl;

- (void)addRequest:(ApiRequest *)apiRequest;

- (void)removeAllRequest;
- (void)removeRequest:(ApiRequest *)apiRequest normal:(BOOL)normal;

- (void)cancelAllRequest;
- (void)cancelAllRequestExcept:(ApiRequest *)apiRequest;

@property (nonatomic, strong) NSMutableArray * apiRequestArray;
@property (nonatomic, weak) id<SZLNetworkApiInvokerDelegate> delegate;

@end

@protocol SZLNetworkApiInvokerDelegate<NSObject>

@optional
- (void)handleError:(NSInteger)statusCode apiRequest:(ApiRequest *)apiRequest response:(ApiResponse *)apiResponse;
- (void)handleError:(NSInteger)statusCode apiRequest:(ApiRequest *)apiRequest response:(ApiResponse *)apiResponse error:(NSError *)error;

@end