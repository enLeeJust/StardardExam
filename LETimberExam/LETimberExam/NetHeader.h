//
//  NetHeader.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#ifndef NetHeader_h
#define NetHeader_h
#define kNetworkNotReachability  ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == 0)  //无网
#define kNetworkReachableViaUnknown ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == -1)
#define kNetworkReachableViaWWAN ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == 1)
#define kNetworkReachableViaWiFi ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == 2)
//#define HOSTURL @"http://exam1.timber2005.com/"
#define HOSTURL @"http://139.159.137.7:801/"
#define PATHAPI @"Interface/JsonAjax.aspx"

#endif /* NetHeader_h */
