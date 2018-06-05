//
//  SZLStartPageManager.h
//  SZLTimberTrain
//
//  Created by Apple on 16/11/10.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZLStartPageManager : NSObject

@property (nonatomic, strong) NSString * imgURL;

+ (instancetype)sharedInstance;



@end
