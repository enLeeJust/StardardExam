//
//  STCalendar.m
//  STCalendarDemo
//
//  Created by https://github.com/STShenZhaoliang/STCalendar on 15/12/17.
//  Copyright © 2015年 ST. All rights reserved.
//

#import "STCalendar.h"
#import "NSCalendar+ST.h"
#import "STCalendarItem.h"

#define WidthCalendar  self.frame.size.width
#define HeightCalendar self.frame.size.height
#define TopViewHeight  36
// 每周的天数
static NSInteger const DaysCount = 7;

@interface STCalendar()

/** 1.开始的日期元件器 */
@property (nonatomic, strong, nullable)NSDateComponents *componentsBegin;
/** 2.结束的日期元件器 */
@property (nonatomic, strong, nullable)NSDateComponents *componentsEnd;
/** 3.已选择的日期元件器数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayCalendarSelected;

@end

@implementation STCalendar
/**
 *  1.初始化方法
 *
 *  @param frame <#frame description#>
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupDefaultData];
        //[self addGestureRecognizer];
        [self reloadData];
        [self setupTopView];
    }
    return self;
}
/**
 *  设置默认值
 */
- (void)setupDefaultData
{
    _year = [NSCalendar currentYear];
    _month = [NSCalendar currentMonth];
    _diameter = 24;
    _textNormalColor = [UIColor grayColor];
    _textSelectedColor = MyOrangeColor;
    _backgroundNormalColor = [UIColor whiteColor];
    _backgroundSelectedColor = [UIColor whiteColor];
}

/**
 *  设置顶部视图
 */
- (void)setupTopView {
    self.topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, TopViewHeight)];
    CGFloat widthRow = WidthCalendar / DaysCount;
    for (int i = 0; i < 8; i++) {
        CGFloat itemCenterX = (i % DaysCount + 0.5) * widthRow;
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, self.diameter, self.diameter)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel setV_centerX:itemCenterX];
        titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        titleLabel.textColor = [UIColor grayColor];
        NSString * title;
        switch (i) {
            case 0:
                title = @"日";
                break;
            case 1:
                title = @"一";
                break;
            case 2:
                title = @"二";
                break;
            case 3:
                title = @"三";
                break;
            case 4:
                title = @"四";
                break;
            case 5:
                title = @"五";
                break;
            case 6:
                title = @"六";
                break;
            default:
                break;
        }
        titleLabel.text = title;
        [self.topView addSubview:titleLabel];
    }
    
    UIImageView * lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, self.topView.v_bottom - 1, self.frame.size.width - 8, 1)];
    lineImageView.image = [UIImage drawLineByImageView:lineImageView];
    [self.topView addSubview:lineImageView];
    
    [self addSubview:self.topView];
    
}

/**
 *  重载数据
 */
- (void)reloadData
{
    
    // 1.获取指定年月的第一天是周几和这个月的天数
    NSInteger firstWeekday = [NSCalendar getFirstWeekdayWithYear:self.year month:self.month];
    NSInteger daysMonth = [NSCalendar getDaysWithYear:self.year month:self.month];
    
    // 2.移除子视图
    NSMutableArray * tmpSubviews = [NSMutableArray array];
    for (UIView * view in self.subviews) {
        if (view != self.topView) {
            [tmpSubviews addObject:view];
        }
    }
    [tmpSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 3.设置子视图
    CGFloat itemW = self.diameter;
    CGFloat itemH = itemW;
    CGFloat widthRow = WidthCalendar / DaysCount;
    CGFloat heightRow = HeightCalendar / DaysCount;
    
    NSInteger day = 0;
    for (NSInteger i = firstWeekday-1; i < daysMonth + firstWeekday-1; i++) {
        day++;
        NSString *stringDay = [NSString stringWithFormat:@"%@", @(i - firstWeekday+2)];
        
        CGFloat itemCenterX = (i % DaysCount + 0.5) * widthRow;
        CGFloat itemCenterY = (i / DaysCount + 0.5) * heightRow + TopViewHeight;
        STCalendarItem *calendarItem = [STCalendarItem calendarItemWithFrame:CGRectMake(0,
                                                                                        0,
                                                                                        itemW,
                                                                                        itemH)
                                                                       title:stringDay
                                                            colorNormalTitle:self.textNormalColor
                                                          colorSelectedTitle:self.textSelectedColor
                                                                      center:CGPointMake(itemCenterX,
                                                                                         itemCenterY)];
        [calendarItem setBackgroundColor:self.backgroundNormalColor];
        [calendarItem.layer setCornerRadius:self.diameter/2];
        [calendarItem.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [calendarItem.layer setBorderColor:MyOrangeColor.CGColor];
        [calendarItem setUserInteractionEnabled:NO];
        [calendarItem setTag:day];
        
        [self.arrayCalendarSelected enumerateObjectsUsingBlock:^(NSDateComponents *obj,
                                                                 NSUInteger idx,
                                                                 BOOL * _Nonnull stop) {
            NSDateComponents *dateComponents = obj;
            if (dateComponents.year == self.year &&
                dateComponents.month == self.month &&
                dateComponents.day == stringDay.integerValue) {
                [calendarItem setSelected:YES];
                [calendarItem setBackgroundColor:self.backgroundSelectedColor];
            }
        }];
        
        [self addSubview:calendarItem];
    }
    
    NSString *stringDate = [NSString stringWithFormat:@"%@年%@月", @(self.year), @(self.month)];
    if (self.block) {
        self.block(stringDate);
    }
    
    
    [self bringSubviewToFront:self.topView];
}

- (void)returnDate:(ReturnDateBlock)block
{
    self.block = block;
}

- (void)addCheckSignalsWithDays:(NSArray *_Nullable)days {
    for (UIView * view in self.subviews) {
        UIButton * itemBtn = (UIButton *)view;
        if ([days containsObject:[NSString stringWithFormat:@"%@", @(view.tag)]]) {
            [itemBtn.layer setBorderWidth:2.0f];
            itemBtn.selected = YES;
        }else{
            [itemBtn.layer setBorderWidth:0];
            if ([view isKindOfClass:[UIButton class]]) {
                itemBtn.selected = NO;
            }
        }
    }
}

/**
 *  添加手势
 */
/*
- (void)addGestureRecognizer
{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(swipeView:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(swipeView:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight ];
    [self addGestureRecognizer:swipeRight];
}
*/
/**
 *  手势的点击事件
 *
 *  @param swipe <#swipe description#>
 */
/*
- (void)swipeView:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        ++self.month;
    } else {
       --self.month;
    }
}
*/
/**
 *  数据的Set方法
 */
- (void)setMonth:(NSInteger)month
{
    if (month > 12) {
        ++self.year;
        month = 1;
    }
    
    if (month < 1) {
        --self.year;
        month = 12;
    }    
    _month = month;
    
    [self reloadData];
}

- (void)setYear:(NSInteger)year
{
    _year = year;
}

- (NSMutableArray *)arrayCalendarSelected
{
    if (!_arrayCalendarSelected) {
        _arrayCalendarSelected = [NSMutableArray array];
    }
    return _arrayCalendarSelected;
}
@end
