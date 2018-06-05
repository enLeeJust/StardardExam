//
//  SZLLineView.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/27.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZLLineView : UIView

@property (nonatomic, strong) NSArray   *lineDashPattern;  // 线段分割模式
@property (nonatomic, assign) CGFloat    endOffset;        // 取值在 0.001 --> 0.499 之间

- (instancetype)initWithFrame:(CGRect)frame
              lineDashPattern:(NSArray *)lineDashPattern
                    endOffset:(CGFloat)endOffset;


@end
