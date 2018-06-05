//
//  RadioButton.h
//  TNCheckBox
//
//  Created by Frederik Jacques on 02/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TNCheckBoxDelegate.h"
#import "TNCheckBoxProtocol.h"

#import "TNCheckBoxData.h"
#import "TNImageCheckBoxData.h"
#import <YYLabel.h>
@interface TNCheckBox : UIView <TNCheckBoxProtocol,UIWebViewDelegate>

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, strong) TNCheckBoxData *data;

@property (nonatomic, strong) UIView *checkBox;
@property (nonatomic, strong) YYLabel *lblLabel;
@property (nonatomic, strong) UIButton *btnHidden;
@property (nonatomic) CGPoint position;

@property (nonatomic, weak) id<TNCheckBoxDelegate> delegate;

- (instancetype)initWithData:(TNCheckBoxData *)data;
- (void)setup;
- (void)checkWithAnimation:(BOOL)animated;

@end
