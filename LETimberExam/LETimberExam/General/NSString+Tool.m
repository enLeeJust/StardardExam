//
//  NSString+Tool.m
//  SZLTimberTrain
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "NSString+Tool.h"

@implementation NSString (Tool)

/** 邮箱验证 */
-(BOOL)isValidateEmail
{
    //不是字符串
    if (!self) {
        return NO;
    }
    //如果长度为0 那不是邮箱
    if ([self length] == 0) {
        return NO;
    }
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

/** 手机号码验证 */
- (BOOL)isValidateMobile{
    //不是字符串
    if (!self) {
        return NO;
    }
    //如果长度为0 那不是电话号
    if ([self length] == 0) {
        return NO;
    }
    
    NSString * phoneRegex = @"^1[0-9]*$";
    NSPredicate *phoneTemp = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    return [phoneTemp evaluateWithObject:self];
}

-(BOOL)isValidateQQ {
    //不是字符串
    if (!self) {
        return NO;
    }
    //如果长度为0 那不是QQ号
    if ([self length] == 0) {
        return NO;
    }
    
    NSString *qq = @"^[1-9][0-9]{4,}";
    NSPredicate *qqTemp = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",qq];
    
    return [qqTemp evaluateWithObject:self];
}
//密码
+ (BOOL)validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,16}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

//身份证号
+ (BOOL)validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

+ (BOOL)validateUrl:(NSString *)url {
    BOOL flag;
    if (url.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^http[s]{0,1}://([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:url];
}

/** 得到身份证的生日****这个方法中不做身份证校验，请确保传入的是正确身份证 */
+ (NSString *)getIDCardBirthday:(NSString *)card {
    card = [card stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([card length] != 18) {
        return nil;
    }
    NSString *birthady = [NSString stringWithFormat:@"%@-%@-%@",[card substringWithRange:NSMakeRange(6,4)], [card substringWithRange:NSMakeRange(10,2)], [card substringWithRange:NSMakeRange(12,2)]];
    return birthady;
}

/** 得到身份证的性别（1男2女）****这个方法中不做身份证校验，请确保传入的是正确身份证 */
+ (NSInteger)getIDCardSex:(NSString *)card {
    card = [card stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger defaultValue = 2;
    if ([card length] != 18) {
        return defaultValue;
    }
    NSInteger number = [[card substringWithRange:NSMakeRange(16,1)] integerValue];
    if (number % 2 == 0) {  //偶数为女
        return 2;
    } else {
        return 1;
    }
}

+(NSString *)shieldImportantInfo:(NSString *)info {
    if (info.length < 11) {
        return info;
    }
    
    NSString * result = nil;
    NSMutableString * tmp = info.mutableCopy;
    NSMutableString *xing = [NSMutableString new];
    for (NSInteger i = 0; i < info.length - 7; i++) {
        [xing appendString:@"*"];
    }
    [tmp replaceCharactersInRange:NSMakeRange(3, info.length - 7) withString:xing];
    
    result = tmp.copy;
    
    return result;
}

-(BOOL)hasContainString:(NSString *)subString {
    NSString *version = [UIDevice currentDevice].systemVersion;
    if ([version floatValue]>=8.0) {
        return [self containsString:subString];
    }else {
        NSRange range = [self rangeOfString:subString];
        
        if (range.location != NSNotFound) {
            return YES;
        }
    }
    
    return NO;
}

- (CGSize)calculateSize:(CGSize)size font:(UIFont *)font {
    CGSize expectedLabelSize = CGSizeZero;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        
        expectedLabelSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }/*
      else {
      expectedLabelSize = [self sizeWithFont:font
      constrainedToSize:size
      lineBreakMode:NSLineBreakByWordWrapping];
      }
      */
    return CGSizeMake(ceil(expectedLabelSize.width), ceil(expectedLabelSize.height));
}

+(NSString *)arabictoHanzi:(NSString *)arabicStr {
    NSInteger a = [arabicStr integerValue];
    NSString * s = [[NSString alloc]init];
    
    switch (a) {
        case 0:
            s = @"零";
            break;
        case 1:
            s = @"一";
            break;
        case 2:
            s = @"二";
            break;
        case 3:
            s = @"三";
            break;
        case 4:
            s = @"四";
            break;
        case 5:
            s = @"五";
            break;
        case 6:
            s = @"六";
            break;
        case 7:
            s = @"七";
            break;
        case 8:
            s = @"八";
            break;
        case 9:
            s = @"九";
            break;
        case 10:
            s = @"十";
            break;
        case 11:
            s = @"十一";
            break;
        case 12:
            s = @"十二";
            break;
        default:
            break;
    }
    
    return s;
}

+(BOOL)isEmpty:(NSString *)str {
    if (!str) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}
+(NSInteger)hasWhiteSpace:(NSString *)str {
    NSInteger count = 0;
    for (int i=0; i<str.length; i++) {
        NSRange range = NSMakeRange(i,1);
        NSString *aStr = [str substringWithRange:range];
        if ([aStr isEqualToString:@" "]) {
            count++;
        }
    }
    
    return count;
}

+(BOOL)isDigitsOnly:(NSString *)string {
    NSString * tmp = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    return tmp.length > 0 ? NO : YES;
}

-(NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
