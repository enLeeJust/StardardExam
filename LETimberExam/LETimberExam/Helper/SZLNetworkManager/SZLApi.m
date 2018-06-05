//
//  SZLApi.m
//  SZLTimber
//
//  Created by 桂舟 on 16/11/2.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "SZLApi.h"
#define kMaxErrorCount 4

@interface SZLApi () {
    NSInteger _errCount;
}

@end
@implementation SZLApi

- (id)init {
    self = [super init];
    if (self) {
        self.apiBaseUrl = HOSTURL;
        self.timeoutSeconds = 30.0f;
        _errCount = 0;
    }
    return self;
}

+ (instancetype)sharedInstance {
    static SZLApi * instance;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)invokerApiRequest:(ApiRequest *)apiRequest callback:(API_CALLBACK)callback {
    apiRequest.callback = callback;
    [self invokerApiRequest:apiRequest withMethod:@"POST" callback:callback];
}


- (void)handleError:(NSInteger)statusCode apiRequest:(ApiRequest *)apiRequest response:(ApiResponse *)apiResponse {
    if (_errCount > kMaxErrorCount) {
        _errCount = 0;
        [self cancelAllRequest];
    }
}

- (void)handleError:(NSInteger)statusCode apiRequest:(ApiRequest *)apiRequest response:(ApiResponse *)apiResponse error:(NSError *)error {
    if (error != nil) {
        NSString *errorHint = nil;
        if (error.code == -1) {
            DLog(@"请求Unknown");
            errorHint = nil;
            _errCount++;
        }else if (error.code == -999) {
            DLog(@"请求Cancel");
            errorHint = nil;
        }else if (error.code == -1000) {
            errorHint = [NSString stringWithFormat:@"Error %@:(%@)", @(statusCode), @(error.code)];
            _errCount++;
        }else if (error.code == -1001) {
            errorHint = @"网络连接超时，请稍后重试";
            _errCount++;
        }else if (error.code == -1002) {
            errorHint = [NSString stringWithFormat:@"Error %@:(%@)", @(statusCode), @(error.code)];
            _errCount++;
        }else if (error.code == -1003) {
            errorHint = [NSString stringWithFormat:@"Error %@:(%@)", @(statusCode), @(error.code)];
            _errCount++;
        }else if (error.code == -1004) {
            errorHint = @"未能连接到服务器";
            _errCount++;
        }else if (error.code == -1005) {
            errorHint = @"网络连接已中断";
            _errCount++;
        }else if (error.code == -1006) {
            errorHint = [NSString stringWithFormat:@"Error %@:(%@)", @(statusCode), @(error.code)];
            _errCount++;
        }else if (error.code == -1017) {
            errorHint = [NSString stringWithFormat:@"Error %@:(%@)", @(statusCode), @(error.code)];
            _errCount++;
        }else if (statusCode == 404) {
            errorHint = @"请求错误";
            _errCount++;
        }else if (statusCode == 408) {
            errorHint = @"网络连接超时，请稍后重试";
            _errCount++;
        }else if (statusCode == 502) {
            errorHint = [NSString stringWithFormat:@"Error %@:(%@)", @(statusCode), @(error.code)];
            _errCount++;
        }else if (statusCode == 503) {
            errorHint = nil;
            _errCount++;
        }else if (statusCode >= 500) {
            errorHint = @"数据加载失败，请稍后重试";
            _errCount++;
        }else {
            _errCount++;
        }
        
        if (errorHint) {
            [CURRENTVIEWCONTROLLER.view makeToast:errorHint];
        }else {
            ;
        }
    }
    
    [self handleError:statusCode apiRequest:apiRequest response:apiResponse];
}


@end
