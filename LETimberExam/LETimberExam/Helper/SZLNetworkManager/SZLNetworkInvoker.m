//
//  SZLNetworkInvoker.m
//  SZLTimberTrain
//
//  Created by Apple on 16/10/13.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SZLNetworkInvoker.h"
#import "ApiRequest.h"
#import "ApiResponse.h"

@interface SZLNetworkInvoker ()

@property (nonatomic, strong) AFHTTPSessionManager * httpSessionManager;

@property (nonatomic, strong) NSString * baseUrl;

@end

@implementation SZLNetworkInvoker

#pragma mark - Lazy Loading
- (NSMutableArray *)apiRequestArray {
    if (_apiRequestArray == nil) {
        self.apiRequestArray = [[NSMutableArray alloc]init];
    }
    return _apiRequestArray;
}

- (void)addRequest:(ApiRequest *)apiRequest {
    if (![self.apiRequestArray containsObject:apiRequest]) {
        apiRequest.retryCount = 0;
        [self.apiRequestArray addObject:apiRequest];
    }else {
        apiRequest.retryCount++;
    }
}

- (void)removeAllRequest {
    for (NSInteger i = 0; i < [self.apiRequestArray count]; i++) {
        ApiRequest * apiRequest = [self.apiRequestArray objectAtIndex:i];
        [self removeRequest:apiRequest normal:NO];
    }
}

- (void)removeRequest:(ApiRequest *)apiRequest normal:(BOOL)normal {
    if (![self.apiRequestArray containsObject:apiRequest]) {
        NSLog(@"not exist the request");
    }else {
        if (normal) {
            
        }else {
            API_CALLBACK callback = apiRequest.callback;
            if (callback) {
                callback(0, nil, NO);
            }
        }
        [self.apiRequestArray removeObject:apiRequest];
    }
}

-(void)request:(NSURLRequest *)request apiRequest:(ApiRequest *)apiRequest callback:(API_CALLBACK)callback {
    [self addRequest:apiRequest];
    __weak SZLNetworkInvoker *weakSelf = self;
    
    NSURLSessionTask * task = [self.httpSessionManager POST:apiRequest.api parameters:apiRequest.bizDataDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        responseObject = AFJSONObjectByRemovingKeysWithNullValues(responseObject, NSJSONReadingMutableContainers);
        
        DLog(@"OK, request %@ response is %@", request, responseObject);
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse*)task.response;
        
        if (callback) {
            ApiResponse *apiResponse = nil;
            @try {
                apiResponse = [[ApiResponse alloc] initWithDictionary:responseObject];
                if (!apiResponse.success && [weakSelf.delegate respondsToSelector:@selector(handleError:apiRequest:response:)]) {
                    [weakSelf.delegate handleError:httpResponse.statusCode apiRequest:apiRequest response:apiResponse];
                }
                if (callback) {
                    callback(apiResponse.errCode, apiResponse, apiResponse.success);
                }
            }
            
            @catch (NSException *exception) {
                DLog(@"Exception occurred: %@, %@", exception, [exception userInfo]);
                id <SZLNetworkApiInvokerDelegate> delegate = weakSelf.delegate;
                if ([delegate respondsToSelector:@selector(handleError:apiRequest:response:)]) {
                    [delegate handleError:httpResponse.statusCode apiRequest:apiRequest response:apiResponse];
                }
                if (callback) {
                    callback(0, nil, NO);
                }
                
                [weakSelf removeRequest:apiRequest normal:YES];
            }
            
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse*)task.response;
        DLog(@"ERROR! request %@ statusCode is %li, \n\r%@", request, (long)httpResponse.statusCode, error);
        id <SZLNetworkApiInvokerDelegate> delegate = weakSelf.delegate;
        if ([delegate respondsToSelector:@selector(handleError:apiRequest:response:error:)]) {
            [delegate handleError:httpResponse.statusCode apiRequest:apiRequest response:nil error:error];
        }
        
        if (callback) {
            callback(httpResponse.statusCode, nil, NO);
        }
        [weakSelf removeRequest:apiRequest normal:YES];

    }];
    [task resume];
    apiRequest.task = task;
}

+ (id)apiInvokerWithBaseUrl:(NSString *)baseUrl {
    static SZLNetworkInvoker * invoker;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        invoker = [[self alloc]init];
    });
    
    invoker.baseUrl = baseUrl;
    assert(invoker.baseUrl);
    invoker.httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:invoker.baseUrl]];
    [invoker.httpSessionManager.operationQueue setMaxConcurrentOperationCount:2];
    invoker.httpSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    invoker.httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];

    return invoker;
}

- (void)cancelAllRequest {
    for (NSInteger i = 0; i < self.httpSessionManager.dataTasks.count; i++) {
        NSURLSessionTask * task = [self.httpSessionManager.dataTasks safe_objectAtIndex:i];
        [task cancel];
    }
}

-(void)cancelAllRequestExcept:(ApiRequest *)apiRequest {
    for (NSInteger i = 0; i < self.httpSessionManager.dataTasks.count; i++) {
        NSURLSessionTask * task = [self.httpSessionManager.dataTasks safe_objectAtIndex:i];
        if (task != apiRequest.task) {
            [task cancel];
        }
    }
}

static id AFJSONObjectByRemovingKeysWithNullValues(id JSONObject, NSJSONReadingOptions readingOptions) {
    if ([JSONObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[(NSArray *)JSONObject count]];
        for (id value in (NSArray *)JSONObject) {
            [mutableArray addObject:AFJSONObjectByRemovingKeysWithNullValues(value, readingOptions)];
        }
        
        return (readingOptions & NSJSONReadingMutableContainers) ? mutableArray : [NSArray arrayWithArray:mutableArray];
    } else if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:JSONObject];
        for (id <NSCopying> key in [(NSDictionary *)JSONObject allKeys]) {
            id value = [(NSDictionary *)JSONObject objectForKey:key];
            if (!value || [value isEqual:[NSNull null]]) {
                [mutableDictionary removeObjectForKey:key];
            } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                [mutableDictionary setObject:AFJSONObjectByRemovingKeysWithNullValues(value, readingOptions) forKey:key];
            }
        }
        
        return (readingOptions & NSJSONReadingMutableContainers) ? mutableDictionary : [NSDictionary dictionaryWithDictionary:mutableDictionary];
    }
    
    return JSONObject;
}


@end
