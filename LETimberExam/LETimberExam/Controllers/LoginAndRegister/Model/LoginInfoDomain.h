//
//  LoginInfoDomain.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "BaseModel.h"

@interface LoginInfoDomain : BaseModel

@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * password;
@property (nonatomic, assign) NSInteger autoLogin;

@end
