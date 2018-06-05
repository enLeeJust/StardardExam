//
//  NSString+Tool.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tool)

/**
 * 判断是否是电话号
 * return 返回判断的结果
 */
- (BOOL)isValidateMobile;
/**
 * 判断是否是邮箱号
 * return 返回判断的结果
 */
-(BOOL)isValidateEmail;
/**
 * 判断是否是QQ号
 * return 返回判断的结果
 */
-(BOOL)isValidateQQ;
/**
 * 判断是否是符合的密码
 * return 返回判断的结果
 */
+ (BOOL)validatePassword:(NSString *)passWord;
/**
 * 判断是否是身份证号
 * return 返回判断的结果
 */
+ (BOOL)validateIdentityCard: (NSString *)identityCard;
/**
 *  判断是否是url
 *
 *  @param url url
 *
 *  @return yes/no
 */
+ (BOOL)validateUrl:(NSString *)url;
/**
 得到身份证的生日****这个方法中不做身份证校验，请确保传入的是正确身份证
 */
+ (NSString *)getIDCardBirthday:(NSString *)card;
/**
 得到身份证的性别（1男2女）****这个方法中不做身份证校验，请确保传入的是正确身份证
 */
+ (NSInteger)getIDCardSex:(NSString *)card;
/**
 * 隐藏手机号等重要信息
 */
+ (NSString *)shieldImportantInfo:(NSString *)info;

/**
 *  判断是否包含某个子串
 *
 *  @param subString 子字符串
 *
 *  @return 是否包含
 */
- (BOOL)hasContainString:(NSString *)subString;

/**
 *  字符串自适应宽高
 */
- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font;
/**
 *  数字 -> 十一
 *
 *  @param arabicStr 数字字符串
 *
 *  @return 十一
 */
+(NSString *)arabictoHanzi:(NSString *)arabicStr;
/**
 *  判断是否空串 全部空格属于空
 *
 *  @param str 字符串
 *
 *  @return 结果
 */
+(BOOL)isEmpty:(NSString *)str;
/**
 *  判断字符串中空格的个数
 *
 *  @param str 字符串
 *  @return 结果
 */
+(NSInteger)hasWhiteSpace:(NSString *)str;

/**
 *  判断字符串是否全部是数字
 *
 *  @param string 字符串
 *
 *  @return 结果
 */
+(BOOL)isDigitsOnly:(NSString *)string;

/**
 *  去除字符串中的空格
 *
 *  @return 结果
 */
-(NSString *)trim;


@end
