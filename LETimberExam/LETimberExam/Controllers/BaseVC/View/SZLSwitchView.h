//
//  SZLSwitchView.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SZLSwitchView;

@protocol SZLSwitchViewDelegate <NSObject>

- (void)switchView:(SZLSwitchView *)switchView hasChangedIndex:(NSInteger)index;

@end

@interface SZLSwitchView : UIView

/** 文字默认颜色 */
@property (nonatomic, strong) UIColor * titleDefaultcolor;
/** 文字选中颜色 */
@property (nonatomic, strong) UIColor * titleSelectedColor;
/** 滑条颜色 */
@property (nonatomic, strong) UIColor * drawColor;
/** 选中序号 */
@property (nonatomic, assign) NSInteger selectedIndex;
/** 滑条长度百分比 */
@property (nonatomic, assign) CGFloat lineTakePercent;

@property (nonatomic, weak) id <SZLSwitchViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items;

@end
