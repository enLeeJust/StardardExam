//
//  SZLBaseVC.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZLBaseVC : UIViewController

/** 自定义导航栏 */
@property (nonatomic, strong) UIView *navigationView;
/** 标题视图 */
@property (nonatomic, strong) UIControl *navigationTitleView;
/** 标题文字 */
@property (nonatomic, copy) NSString *navigationTitle;
/** 导航栏背景色 */
@property (nonatomic, strong) UIColor *navigationBackgroundColor;
/** 导航栏左侧按钮 */
@property (nonatomic, strong) UIButton *navigationLeftButton;
/** 导航栏右侧按钮 */
@property (nonatomic, strong) UIButton *navigationRightButton;
/** 导航栏左侧按钮集合（最多两个） */
@property (nonatomic, copy) NSArray<UIButton *> *navigationLeftButtons;
/** 导航栏右侧按钮集合（最多两个）*/
@property (nonatomic, copy) NSArray<UIButton *> *navigationRightButtons;
/** 导航栏背景透明度 */
@property (nonatomic, assign) CGFloat navigationAlpha;
/** 内容视图 */
@property (nonatomic, strong) UIView * contentView;
/** 是否首次加载 */
@property (nonatomic, assign) BOOL hasAppear;
/** 标题label */
@property (nonatomic, strong) UILabel *navigationTitleLabel;

/** 当前网络请求队列 */
@property (nonatomic, strong) NSMutableArray *requestArr;
@end
