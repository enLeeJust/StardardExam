//
//  WebServiceModel.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/21.
//  Copyright © 2016年 timber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPSessionManager.h>

@interface WebServiceModel : NSObject
@property(nonatomic,copy) NSString* requestUrlStr;
@property(nonatomic,strong) NSMutableArray* requestParam;
@property(nonatomic,strong)AFHTTPSessionManager *manager;

+(AFHTTPSessionManager *)manager;

@end
