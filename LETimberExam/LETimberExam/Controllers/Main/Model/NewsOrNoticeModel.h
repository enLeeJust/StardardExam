//
//  NewsOrNoticeModel.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/28.
//  Copyright © 2016年 timber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface NewsOrNoticeModel : BaseModel

@property(nonatomic,copy) NSString* commend;
@property(nonatomic,assign) long  news_id;

@property(nonatomic,copy) NSString* news_name;
@property(nonatomic,copy) NSString* news_send_date;
@property(nonatomic,copy) NSString* type_name;
@property(nonatomic,copy) NSString* url;

@end
