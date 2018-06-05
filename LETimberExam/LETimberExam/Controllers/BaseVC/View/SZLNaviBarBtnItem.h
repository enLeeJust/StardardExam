//
//  SZLNaviBarBtnItem.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/5.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZLNaviBarBtnItem : UIButton

//创建文字按钮
+ (instancetype)buttonWithTitle:(NSString *)buttonTitle;

//创建图标按钮
+ (instancetype)buttonWithImageNormal:(UIImage *)imageNormal imageSelected:(UIImage *)imageSelected;

@end
