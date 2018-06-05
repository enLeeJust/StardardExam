//
//  UseFMDBTool.h
//  BigShark
//
//  Created by 桂舟 on 16/8/1.
//  Copyright © 2016年 com.timber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "IsRead.h"
@interface UseFMDBTool : NSObject
@property (nonatomic,strong)NSString* path;
@property (nonatomic,strong)FMDatabase* db;
+(instancetype)sharedInstance;
-(BOOL)addUserObject:(IsRead*)user;
//-(NSArray*)user:(NSString*)userId;
-(NSArray*)user:(NSString*)userId newsOrNotice:(NSString *)type;
@end
