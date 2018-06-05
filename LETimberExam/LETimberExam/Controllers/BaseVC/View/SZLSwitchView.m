//
//  SZLSwitchView.m
//  SZLTimberTrain
//
//  Created by Apple on 16/9/9.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SZLSwitchView.h"

@interface SZLSwitchView ()

@property (nonatomic, copy) NSArray * items;

@property (nonatomic, strong) UILabel * lineDraw;

@end

@implementation SZLSwitchView

- (UILabel *)lineDraw {
    if (!_lineDraw) {
        _lineDraw = [[UILabel alloc]init];
        [_lineDraw setBackgroundColor:self.drawColor];
    }
    return _lineDraw;
}

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items {
    if (self = [super initWithFrame:frame]) {
        self.items = [NSArray arrayWithArray:items];
        [self initData];
        [self setupView];
    }
    return self;
}

- (void)initData {
    self.titleDefaultcolor = MyTextColor;
    self.titleSelectedColor = MyNavColor;
    self.drawColor = MyNavColor;
    self.selectedIndex = 0;
    self.lineTakePercent = 0.6f;
}

- (void)setupView {
    self.backgroundColor = WhiteColor;
    
    UILabel * line = [[UILabel alloc]init];
    line.backgroundColor = MyLineColor;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    for (int i = 0; i < self.items.count; i++) {
        UIButton * itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemBtn setExclusiveTouch:NO];
        [itemBtn setTag:i];
        [itemBtn setFrame:CGRectMake(i*(WIDTH/self.items.count), 0, WIDTH/self.items.count, 40)];
        [itemBtn setTitle:self.items[i] forState:UIControlStateNormal];
        [itemBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [itemBtn setTitleColor:self.titleDefaultcolor forState:UIControlStateNormal];
        [itemBtn setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
        [itemBtn addTarget:self action:@selector(itemSwitchChangedAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == self.selectedIndex) {
            itemBtn.selected = YES;
        }
        [self addSubview:itemBtn];
    }
    
    [self addSubview:self.lineDraw];
    [self.lineDraw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@2);
        make.bottom.equalTo(@0);
        make.width.equalTo((WIDTH/self.items.count)*self.lineTakePercent);
        make.leading.equalTo((WIDTH/self.items.count)*(self.selectedIndex+(1-self.lineTakePercent))*0.5);
    }];
    
    
   
    
    
    
    
}

- (void)itemSwitchChangedAction:(UIButton *)sender {
    if (sender.tag != self.selectedIndex) {
        for (UIView * subView in self.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                UIButton * btn = (UIButton *)subView;
                if (btn != sender) {
                    btn.selected = NO;
                }else{
                    btn.selected = YES;
                }
            }
        }
        self.selectedIndex = sender.tag;
        
        [UIView animateWithDuration:.2f animations:^{
//            self.lineDraw.v_left = (WIDTH/self.items.count)*(self.selectedIndex+(1-self.lineTakePercent)*0.5);
//            [self.lineDraw setNeedsDisplay];
            [self.lineDraw mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo((WIDTH/self.items.count)*(self.selectedIndex+(1-self.lineTakePercent)*0.5));
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:.2f animations:^{
                    [self layoutIfNeeded];
                }];
            });
            
            
            
            
        } completion:^(BOOL finished) {
            
        }];
        
        if ([self.delegate respondsToSelector:@selector(switchView:hasChangedIndex:)]) {
            [self.delegate switchView:self hasChangedIndex:sender.tag];
        }
    }
}

@end
