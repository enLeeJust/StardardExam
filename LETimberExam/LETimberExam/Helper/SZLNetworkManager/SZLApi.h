//
//  SZLApi.h
//  SZLTimber
//
//  Created by 桂舟 on 16/11/2.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "ApiInvoker.h"
#define SZLApiHelper [SZLApi sharedInstance]
@interface SZLApi : ApiInvoker


+ (instancetype)sharedInstance;

- (void)invokerApiRequest:(ApiRequest *)apiRequest callback:(API_CALLBACK)callback;
@end
