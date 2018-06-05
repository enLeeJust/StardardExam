//
//  UserBaseInfoModel.h
//  SZLTimber
//
//  Created by 桂舟 on 16/10/21.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "BaseModel.h"

@interface UserBaseInfoModel : BaseModel

@property(nonatomic,copy)NSString *user_cnname;
@property(nonatomic,copy)NSString *user_email;
@property(nonatomic,copy)NSString *user_enname;
@property(nonatomic,copy)NSString *user_phone;
@property(nonatomic,copy)NSString *user_pic;
@property(nonatomic,copy)NSString *user_sex;
@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,copy)NSString *user_name;

@property(nonatomic,copy)NSString *user_dep_name;
@property(nonatomic,copy)NSString *user_p_name;
@property(nonatomic,copy)NSString *user_role_name;

@end
