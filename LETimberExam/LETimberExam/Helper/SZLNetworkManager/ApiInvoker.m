//
//  ApiInvoker.m
//  SZLTimber
//
//  Created by 桂舟 on 16/11/2.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "ApiInvoker.h"
#import "SZLNetworkInvoker.h"

#define API_BASE_URL(url) ([NSURL URLWithString:url])

@interface ApiInvoker () <SZLNetworkApiInvokerDelegate> {
    NSInteger _errCount;
}

@property (nonatomic, strong) SZLNetworkInvoker * networkInvoker;

@end
@implementation ApiInvoker
- (void)invokerApiRequest:(ApiRequest *)apiRequest callback:(API_CALLBACK)callback {
    [self invokerApiRequest:apiRequest withMethod:@"POST" callback:callback];
}

- (void)invokerApiRequest:(ApiRequest *)apiRequest withMethod:(NSString *)httpMethod callback:(API_CALLBACK)callback {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //通过encodeApiRequest_iOS6: 得到请求的请求体 （参数排序、拼接成请求字符串）
    NSString *body = ([self encodeApiRequest_iOS6:apiRequest]);
    NSString *completeApiUrl = nil;
    //判断是get还是post请求 拼接成完整的请求url
    if ([self isGet:httpMethod] || [self isDelete:httpMethod]) {
        //get 和 delete方法的body放在queryString
        completeApiUrl = [NSString stringWithFormat:@"%@?%@", PATHAPI, body];
    }else{
        completeApiUrl = PATHAPI;
    }
    
    NSURL *url = [NSURL URLWithString:completeApiUrl relativeToURL:API_BASE_URL(self.apiBaseUrl)];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //设置超时时间
    [request setTimeoutInterval:self.timeoutSeconds];
    
    //设置请求方式为传递的请求参数的方
    [request setHTTPMethod:httpMethod];
    NSDictionary * params = [self encodeJSONApiRequest_iOS6:apiRequest];
    
    if ([self isPost:httpMethod] || [self isPut:httpMethod]) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];//请求头
        NSData * jsonData = [params mj_JSONData];
        [request setHTTPBody:jsonData];
    }
    
    [self.networkInvoker request:request apiRequest:apiRequest callback:callback];
    DLog(@"OK, request %@ data is %@", request, params);
}

- (BOOL)isGet:(NSString *)httpMethod {
    return [[httpMethod lowercaseString] isEqualToString:@"get"];
}

- (BOOL)isPut:(NSString *)httpMethod {
    return [[httpMethod lowercaseString] isEqualToString:@"put"];
}

- (BOOL)isDelete:(NSString *)httpMethod {
    return [[httpMethod lowercaseString] isEqualToString:@"delete"];
}

- (BOOL)isPost:(NSString *)httpMethod {
    return [[httpMethod lowercaseString] isEqualToString:@"post"];
}

- (void)setApiBaseUrl:(NSString *)apiBaseUrl {
    _apiBaseUrl = apiBaseUrl;
    self.networkInvoker = [SZLNetworkInvoker apiInvokerWithBaseUrl:self.apiBaseUrl];
    self.networkInvoker.delegate = self;
}

- (NSDictionary *)encodeJSONApiRequest_iOS6:(ApiRequest *)request {
    @autoreleasepool {
        NSMutableDictionary * JSONBody = [[NSMutableDictionary alloc]init];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:request.bizDataDict];
        
        NSArray *keys = [dict allKeys];
        
        NSComparator comparator =  ^(id obj1, id obj2){
            NSString *key1 = obj1;
            NSString *key2 = obj2;
            return [key1 compare:key2];
        };
        NSArray *sortedKeys = [keys sortedArrayUsingComparator:comparator];
        
        for (NSString * key in sortedKeys) {
            NSString *value = [dict objectForKey:key];
            [JSONBody setValue:value forKey:key];
        }
        
        return JSONBody.copy;
    }
}

- (NSString *)encodeApiRequest_iOS6:(ApiRequest *)request {
    @autoreleasepool {
        //在这个方法内对参数进行排列 然后按顺序拼接成请求的URL
        //ENT CS 参数算法
        NSMutableArray *namedValuePair = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:request.bizDataDict];
        
        NSArray *keys = [dict allKeys];
        
        NSComparator comparator =  ^(id obj1, id obj2){
            NSString *key1 = obj1;
            NSString *key2 = obj2;
            return [key1 compare:key2];
        };
        NSArray *sortedKeys = [keys sortedArrayUsingComparator:comparator];
        
        NSMutableArray *values = [[NSMutableArray alloc] init];
        for(NSString *key in sortedKeys){
            NSString *value = [dict objectForKey:key];
            [values addObject:value];
            [namedValuePair addObject:[NSString stringWithFormat:@"%@=%@",key,value]];
        }
        
        NSString *returnString = [namedValuePair componentsJoinedByString:@"&"];
        return returnString;
    }
}

#pragma mark - Public
- (void)handleError:(NSInteger)statusCode apiRequest:(ApiRequest *)apiRequest response:(ApiResponse *)apiResponse {
    
}
- (void)handleError:(NSInteger)statusCode apiRequest:(ApiRequest *)apiRequest response:(ApiResponse *)apiResponse error:(NSError *)error {
    
}

-(void)addRequest:(ApiRequest *)apiRequest {
    [self.networkInvoker addRequest:apiRequest];
}

-(void)removeAllRequest {
    [self.networkInvoker removeAllRequest];
}

-(void)removeRequest:(ApiRequest *)apiRequest {
    [self.networkInvoker removeRequest:apiRequest normal:NO];
}

-(void)cancelAllRequest {
    [self.networkInvoker cancelAllRequest];
}

-(void)cancelAllRequestExcept:(ApiRequest *)apiRequest {
    [self.networkInvoker cancelAllRequestExcept:apiRequest];
}

-(void)reRequest:(ApiRequest *)apiRequest {
    [self removeRequest:apiRequest];
}

-(void)reRequestAllRequest {
    NSMutableArray * apiRequestArray = [self.networkInvoker apiRequestArray];
    for (NSInteger i = 0; i < [apiRequestArray count]; i++) {
        ApiRequest * apiRequest = [apiRequestArray objectAtIndex:i];
        [self reRequest:apiRequest];
    }
}
@end
