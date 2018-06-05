//
//  UseFMDBTool.m
//  BigShark
//
//  Created by 桂舟 on 16/8/1.
//  Copyright © 2016年 com.timber. All rights reserved.
//

#import "UseFMDBTool.h"
UseFMDBTool* _instance;
@implementation UseFMDBTool
+(instancetype)sharedInstance
{
    return [self new];
}
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    if (_instance == nil) {
        /*线程安全，效率高*/
        @synchronized(self) {
            _instance = [super allocWithZone:zone];
        }
    }
    return _instance;
}
+(void)initialize
{
    UseFMDBTool* tool = [UseFMDBTool sharedInstance];
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* cachesDirectory = paths[0];
    tool.path = [cachesDirectory stringByAppendingPathComponent:@"user.db"];
    NSLog(@"path:%@",tool.path);
    tool.db = [FMDatabase databaseWithPath:tool.path];
    if ([tool.db open]) {
        NSString* sql = @"create table if not exists t_user (id integer primary key autoincrement,UserID text,ItemId text,Type text);";
        BOOL res = [tool.db executeUpdate:sql];
        if (res) {
            NSLog(@"t_user建表成功");
        }else{
            NSLog(@"t_user建表失败");
        }
    }
}
-(BOOL)addUserObject:(IsRead *)user
{
    
    [self.db open];
    NSString* sql = [NSString stringWithFormat:@"insert into t_user (UserID,ItemId,Type) values ('%@','%@','%@');",user.UserID,user.ItemId,user.Type];
    BOOL rs = [self.db executeUpdate:sql];
    return rs;
}
-(NSArray*)user:(NSString*)userId newsOrNotice:(NSString *)type
{
    NSMutableArray* arr = [NSMutableArray new];
    [self.db open];
    NSString* sql = [NSString stringWithFormat:@"select * from t_user where userID = '%@' and Type = '%@';",userId,type];
    FMResultSet* rs = [self.db executeQuery:sql];
    while ([rs next]) {
        IsRead* u = [IsRead new];
        NSString* UserId = [rs stringForColumnIndex:1];
        NSString* ItemId = [rs stringForColumnIndex:2];
        NSString* Type = [rs stringForColumnIndex:3];
        u.UserID = UserId;
        u.ItemId = ItemId;
        u.Type = Type;
        [arr addObject:u];
    }
    return arr;
}
@end
