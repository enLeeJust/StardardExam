//
//  SZLExamApi.m
//  SZLTimber
//
//  Created by 桂舟 on 16/11/2.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "SZLExamApi.h"
#define SERVER_NAME @"servletname"
@implementation SZLExamApi

+(instancetype) sharedInstance {
    static SZLExamApi *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}


-(ApiRequest *)normalRequest:(NSDictionary *)prama callback:(API_CALLBACK)callback{

    ApiRequest * request = [ApiRequest requestWithBizData:prama];
    [SZLApiHelper invokerApiRequest:request callback:callback];
    return request;

}
-(ApiRequest *)getUnFinishedExamsWithCallback:(API_CALLBACK)callback{
    
    ApiRequest * request = [ApiRequest requestWithBizData:@{SERVER_NAME : @"ExamPractice",@"type":@(1)}];
    [SZLApiHelper invokerApiRequest:request callback:callback];
    return request;
    
}

-(ApiRequest *)getFinishedExamsWithCallback:(API_CALLBACK)callback{
    
    ApiRequest * request = [ApiRequest requestWithBizData:@{SERVER_NAME : @"exampracticefinish",@"type":@(1)}];
    [SZLApiHelper invokerApiRequest:request callback:callback];
    return request;
    
}


/**
 *  滚动图
 *
 */
- (ApiRequest *)getStartPageImageWithCallback:(API_CALLBACK)callback {
    ApiRequest * request = [ApiRequest requestWithBizData:@{SERVER_NAME : @"carouselstart"}
                                                 ];
    [SZLApiHelper invokerApiRequest:request callback:callback];
    return request;
}

/**
  *  登录接口
  *
  */
- (ApiRequest *)userLoginRequest:(NSDictionary *)loginInfo callback:(API_CALLBACK)callback{
    ApiRequest * request = [ApiRequest requestWithBizData:loginInfo];
    [SZLApiHelper invokerApiRequest:request callback:callback];
    return request;
}
/**
 *  获取新闻网络请求
 *
 */
-(ApiRequest *)getNewsNumRequest:(NSDictionary *)prama callback:(API_CALLBACK)callback{
    ApiRequest * request = [ApiRequest requestWithBizData:prama];
    [SZLApiHelper invokerApiRequest:request callback:callback];
    return request;
}

/**
 *  获取公告网络请求
 *
 */
-(ApiRequest *)getNoticesNumRequest:(NSDictionary *)prama callback:(API_CALLBACK)callback{
    ApiRequest * request = [ApiRequest requestWithBizData:prama];
    [SZLApiHelper invokerApiRequest:request callback:callback];
    return request;
}

/**
 *  获取轮播图URL的网络请求
 *
 */
-(ApiRequest *)getImgUrlRequest:(NSDictionary *)prama callback:(API_CALLBACK)callback{
    ApiRequest * request = [ApiRequest requestWithBizData:prama];
    [SZLApiHelper invokerApiRequest:request callback:callback];
    return request;
}

- (ApiRequest *)getExanInfoRequest:(NSString *)servletName withPrama:(NSMutableDictionary *)prama callback:(API_CALLBACK)callback{
    [prama setObject:servletName forKey:SERVER_NAME];
    ApiRequest * request = [ApiRequest requestWithBizData:prama];
    [SZLApiHelper invokerApiRequest:request callback:callback];
    return request;
}
/**
 *  MyScore
 *  获取我的成绩信息
 *
 *  @param type     区分我的成绩和练习记录
 *  @param callback  接口回调
 */
- (ApiRequest *)getMyGradeInfoRequest:(NSInteger)type callback:(API_CALLBACK)callback{
    ApiRequest * request = [ApiRequest requestWithBizData:@{SERVER_NAME : @"MyScore",
                                                            @"type":[NSNumber numberWithInteger:type]}];

    [SZLApiHelper invokerApiRequest:request callback:callback];
    return request;
}

/**
 *  Papers
 *  获取我的成绩信息
 *PId
 *  @param PlanId    安排ID
 *  @param paperId   具体试卷ID
 *  @param callback  接口回调
 */
- (ApiRequest *)getPaperDetailsInfoRequest:(NSInteger)PlanId PaperID:(NSInteger)paperId callback:(API_CALLBACK)callback{
    ApiRequest * request = [ApiRequest requestWithBizData:@{SERVER_NAME : @"Papers",
                                                            @"PlanId":[NSNumber numberWithInteger:PlanId],
                                                            @"PId":[NSNumber numberWithInteger:paperId]}];
    
    [SZLApiHelper invokerApiRequest:request callback:callback];
    return request;
}

/**
 *  用户交卷
 *
 *  @param paperInfo 答题详情
 *  @param tmInfo    试卷详情
 *  @param callback  接口回调
 */

- (ApiRequest *)uploadPaperDetailsInfoRequest:(NSString*)paperInfo TMinfo:(NSString *)tmInfo callback:(API_CALLBACK)callback{
    ApiRequest * request = [ApiRequest requestWithBizData:@{SERVER_NAME : @"ReceiveKeep",
                                                            @"PaperInfo":paperInfo,
                                                            @"TMInfo":tmInfo}];
    
    [SZLApiHelper invokerApiRequest:request callback:callback];
    return request;
}


/**
 *  修改用户密码
 *
 */
- (ApiRequest *)changePersonPasswordRequest:(NSString *)oldPwd withNewPwd:(NSString *)newPwd callback:(API_CALLBACK)callback{
    ApiRequest * request = [ApiRequest requestWithBizData:@{SERVER_NAME : @"ReviseUrsePwd",
                                                            @"userPwd":oldPwd,
                                                            @"userPwds":newPwd}];
    
    [SZLApiHelper invokerApiRequest:request callback:callback];
    return request;
}


/**
 *  更改用户性别
 *@"stusex":userSex,
 @"stuphone":userPhone,
 @"stuemail":userMail,
 */
- (ApiRequest *)changePersonSexRequest:(NSString *)stuSex callback:(API_CALLBACK)callback{
    ApiRequest * request = [ApiRequest requestWithBizData:@{SERVER_NAME : @"ReviseUrseInfo",
                                                            @"stusex":stuSex}];
    
    [SZLApiHelper invokerApiRequest:request callback:callback];
    return request;
}

/**
 *  更改用户手机
 *
 */
- (ApiRequest *)changePersonPhoneRequest:(NSString *)stuPhone callback:(API_CALLBACK)callback{
    ApiRequest * request = [ApiRequest requestWithBizData:@{SERVER_NAME : @"ReviseUrseInfo",
                                                            @"stuphone":stuPhone}];
    
    [SZLApiHelper invokerApiRequest:request callback:callback];
    return request;
}


/**
 *  更改用户邮箱
 *
 */
- (ApiRequest *)changePersonEmailRequest:(NSString *)stuMail callback:(API_CALLBACK)callback{

    ApiRequest * request = [ApiRequest requestWithBizData:@{SERVER_NAME : @"ReviseUrseInfo",
                                                            @"stuemail":stuMail}];
    
    [SZLApiHelper invokerApiRequest:request callback:callback];
    return request;
}
/**
 *  更改用户头像
 *
 */
- (ApiRequest *)changePersonHeadViewRequest:(NSString *)headPicStr callback:(API_CALLBACK)callback{
    ApiRequest * request = [ApiRequest requestWithBizData:@{SERVER_NAME : @"Changes",
                                                            @"ImgString":headPicStr}];
    
    [SZLApiHelper invokerApiRequest:request callback:callback];
    return request;
}


/**
 *  获取考试概况
 *
 */
- (ApiRequest *)getUserExamInfoOutlineRequest:(NSInteger)type callback:(API_CALLBACK)callback{
    ApiRequest * request = [ApiRequest requestWithBizData:@{SERVER_NAME : @"MyScoreOutline",
                                                            @"type":[NSNumber numberWithInteger:type]}];
    
    [SZLApiHelper invokerApiRequest:request callback:callback];
    return request;
}


- (ApiRequest *)getVoteListWithPageSize:(NSInteger)pageSize pageNum:(NSInteger)pageNum callback:(API_CALLBACK)callback {
    ApiRequest * request = [ApiRequest requestWithBizData:@{SERVER_NAME : @"votedlist",
                                                            @"pagesize" : [NSNumber numberWithInteger:pageSize],
                                                            @"pagenum" : [NSNumber numberWithInteger:pageNum]}];
    [SZLApiHelper invokerApiRequest:request callback:callback];
    return request;
}

- (ApiRequest *)getVoteDetailWithVotedId:(NSInteger)votedId callback:(API_CALLBACK)callback {
    ApiRequest * request = [ApiRequest requestWithBizData:@{SERVER_NAME : @"voteddetails",
                                                            @"votedid" : [NSNumber numberWithInteger:votedId]}];
    [SZLApiHelper invokerApiRequest:request callback:callback];
    return request;
}

- (ApiRequest *)userVoteWithVotedId:(NSInteger)votedId subId:(NSInteger)subId callback:(API_CALLBACK)callback {
    ApiRequest * request = [ApiRequest requestWithBizData:@{SERVER_NAME : @"ivote",
                                                            @"votedid" : [NSNumber numberWithInteger:votedId],
                                                            @"subid" : [NSNumber numberWithInteger:subId]}];
    [SZLApiHelper invokerApiRequest:request callback:callback];
    return request;
}
@end
