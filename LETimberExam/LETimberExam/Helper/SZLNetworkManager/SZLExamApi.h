//
//  SZLExamApi.h
//  SZLTimber
//
//  Created by 桂舟 on 16/11/2.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "SZLApi.h"
#define SZLServerHelper [SZLExamApi sharedInstance]
@interface SZLExamApi : SZLApi

+ (instancetype) sharedInstance;
/**
 *  公用的网络请求
 *
 */
//-(void)normalRequest:(NSDictionary *)prama callback:(API_CALLBACK)callback;

-(ApiRequest *)normalRequest:(NSDictionary *)prama callback:(API_CALLBACK)callback;
/**
 *  获取启动图
 *
 *  @param callback 接口回调
 */
//- (void)getStartPageImageWithCallback:(API_CALLBACK)callback;
- (ApiRequest *)getStartPageImageWithCallback:(API_CALLBACK)callback;
/**
 *  用户登录
 *
 */
//- (void)userLoginRequest:(NSDictionary *)loginInfo callback:(API_CALLBACK)callback;
- (ApiRequest *)userLoginRequest:(NSDictionary *)loginInfo callback:(API_CALLBACK)callback;
/**
 *  获取新闻网络请求
 *
 */
//-(void)getNewsNumRequest:(NSDictionary *)prama callback:(API_CALLBACK)callback;
-(ApiRequest *)getNewsNumRequest:(NSDictionary *)prama callback:(API_CALLBACK)callback;

/**
 *  获取轮播图URL的网络请求
 *
 */
//-(void)getImgUrlRequest:(NSDictionary *)prama callback:(API_CALLBACK)callback;
-(ApiRequest *)getImgUrlRequest:(NSDictionary *)prama callback:(API_CALLBACK)callback;
/**
 *  获取未完成考试的网络请求
 *
 */
-(ApiRequest *)getUnFinishedExamsWithCallback:(API_CALLBACK)callback;
/**
 *  获取已完成考试的网络请求
 *
 */

-(ApiRequest *)getFinishedExamsWithCallback:(API_CALLBACK)callback;



/**
 *  获取公告网络请求
 *
 */
//-(void)getNoticesNumRequest:(NSDictionary *)prama callback:(API_CALLBACK)callback;
-(ApiRequest*)getNoticesNumRequest:(NSDictionary *)prama callback:(API_CALLBACK)callback;
/**
 *  获取考试信息
 *
 */
//- (void)getExanInfoRequest:(NSString *)servletName withPrama:(NSMutableDictionary *)prama callback:(API_CALLBACK)callback;
- (ApiRequest *)getExanInfoRequest:(NSString *)servletName withPrama:(NSMutableDictionary *)prama callback:(API_CALLBACK)callback;


/**
 *  MyScore
 *  获取我的成绩信息
 *
 *  @param type     区分我的成绩和练习记录
 *  @param callback  接口回调
 */
//- (void)getMyGradeInfoRequest:(NSInteger)type callback:(API_CALLBACK)callback;
- (ApiRequest *)getMyGradeInfoRequest:(NSInteger)type callback:(API_CALLBACK)callback;

/**
 *  Papers
 *  获取试卷的具体资料
 *  @param PlanId    安排ID
 *  @param paperId   具体试卷ID
 *  @param callback  接口回调
 */
//- (void)getPaperDetailsInfoRequest:(NSInteger)PlanId PaperID:(NSInteger)paperId callback:(API_CALLBACK)callback;
- (ApiRequest *)getPaperDetailsInfoRequest:(NSInteger)PlanId PaperID:(NSInteger)paperId callback:(API_CALLBACK)callback;

/**
 *  用户交卷
 *
 *  @param paperInfo 答题详情
 *  @param tmInfo    试卷详情
 *  @param callback  接口回调
 */

//- (void)uploadPaperDetailsInfoRequest:(NSString*)paperInfo TMinfo:(NSString *)tmInfo callback:(API_CALLBACK)callback;
- (ApiRequest *)uploadPaperDetailsInfoRequest:(NSString*)paperInfo TMinfo:(NSString *)tmInfo callback:(API_CALLBACK)callback;


/**
 *  修改用户密码
 *
 */
//- (void)changePersonPasswordRequest:(NSString *)oldPwd withNewPwd:(NSString *)newPwd callback:(API_CALLBACK)callback;
- (ApiRequest *)changePersonPasswordRequest:(NSString *)oldPwd withNewPwd:(NSString *)newPwd callback:(API_CALLBACK)callback;
/**
 *  更改用户性别
 *
 */
//- (void)changePersonSexRequest:(NSString *)stuSex callback:(API_CALLBACK)callback;
- (ApiRequest *)changePersonSexRequest:(NSString *)stuSex callback:(API_CALLBACK)callback;
/**
 *  更改用户手机
 *
 */
//- (void)changePersonPhoneRequest:(NSString *)stuPhone callback:(API_CALLBACK)callback;
- (ApiRequest *)changePersonPhoneRequest:(NSString *)stuPhone callback:(API_CALLBACK)callback;

/**
 *  更改用户邮箱
 *
 */
//- (void)changePersonEmailRequest:(NSString *)stuMail callback:(API_CALLBACK)callback;
- (ApiRequest *)changePersonEmailRequest:(NSString *)stuMail callback:(API_CALLBACK)callback;

/**
 *  更改用户头像
 *
 */
//- (void)changePersonHeadViewRequest:(NSString *)headPicStr callback:(API_CALLBACK)callback;
- (ApiRequest *)changePersonHeadViewRequest:(NSString *)headPicStr callback:(API_CALLBACK)callback;

/**
 *  获取考试概况
 *
 */
- (ApiRequest *)getUserExamInfoOutlineRequest:(NSInteger)type callback:(API_CALLBACK)callback;
/**
 *  获取投票列表
 *
 *  @param pageSize 一页数量
 *  @param pageNum  页码
 *  @param callback 接口回调
 */
- (ApiRequest *)getVoteListWithPageSize:(NSInteger)pageSize pageNum:(NSInteger)pageNum callback:(API_CALLBACK)callback;

/**
 *  获取投票详情
 *
 *  @param votedId  投票ID
 *  @param callback 接口回调
 */
- (ApiRequest *)getVoteDetailWithVotedId:(NSInteger)votedId callback:(API_CALLBACK)callback;

/**
 *  用户投票
 *
 *  @param votedId  投票ID
 *  @param subId    选项ID
 *  @param callback 接口回调
 */
- (ApiRequest *)userVoteWithVotedId:(NSInteger)votedId subId:(NSInteger)subId callback:(API_CALLBACK)callback;
@end
