//
//  STCalendar.h
//  STCalendarDemo
//
//  Created by https://github.com/STShenZhaoliang/STCalendar on 15/12/17.
//  Copyright © 2015年 ST. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnDateBlock)(NSString *_Nullable stringDate);

@interface STCalendar : UIView
/** 1.年数 */
@property (nonatomic, assign)NSInteger year;
/** 2.月数 */
@property (nonatomic, assign)NSInteger month;
/** 3.日期直径,default is 34  */
@property (nonatomic) NSInteger diameter;
/** 4.字体的普通色,default is [UIColor lightGrayColor]*/
@property (nonatomic, strong, nullable) UIColor *textNormalColor;
/** 5.字体的选中色,default is [UIColor redColor] */
@property (nonatomic, strong, nullable) UIColor *textSelectedColor;
/** 6.背景的普通色,default is [UIColor whiteColor]*/
@property (nonatomic, strong, nullable) UIColor *backgroundNormalColor;
/** 7.背景的选中色,default is [UIColor orangeColor] */
@property (nonatomic, strong, nullable) UIColor *backgroundSelectedColor;
/** 8.返回现在界面的日期,如2015年12月 */
@property (nonatomic, copy, nullable)ReturnDateBlock block;
/** 9.顶部文字视图 */
@property (nonatomic, strong, nullable) UIView * topView;
/** 返回当前年月信息 */
- (void)returnDate:(ReturnDateBlock _Nullable)block;

/**
 *  添加签到标记
 *
 *  @param days 已签到的日期
 */
- (void)addCheckSignalsWithDays:(NSArray *_Nullable)days;

@end
