//
//  CustomImageRadioButton.m
//  TNRadioButtonGroupDemo
//
//  Created by Frederik Jacques on 22/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import "TNImageRadioButton.h"

@interface TNImageRadioButton()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *choiceItem;

@end

@implementation TNImageRadioButton

#pragma mark - Initializers

- (instancetype)initWithData:(TNImageRadioButtonData *)data {
    
    self = [super initWithData:data];
    
    if (self) {
        // Initialization code
        self.data = data;
        
        [self setup];
    }
    
    return self;
}

#pragma mark - Creation
- (void)setup{
    
    [self createRadioButton];
    
    [super setup];
}

- (void)createRadioButton {    
    self.radioButton = [[UIView alloc] initWithFrame:CGRectMake(8, 0, self.data.unselectedImage.size.width, self.data.unselectedImage.size.height)];
    
    _choiceItem = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.data.unselectedImage.size.width, self.data.unselectedImage.size.height)];
    _choiceItem.font = [UIFont boldSystemFontOfSize:14.0f];
    _choiceItem.backgroundColor = [UIColor clearColor];
    _choiceItem.textColor = [UIColor darkGrayColor];
    _choiceItem.text = self.data.checkItemStr;
    _choiceItem.textAlignment = NSTextAlignmentCenter;
    
    self.imageView = [[UIImageView alloc] initWithImage:self.data.unselectedImage];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.radioButton addSubview:self.imageView];
    
    [self addSubview:self.radioButton];
    
}

#pragma mark - Animations
- (void)selectWithAnimation:(BOOL)animated {
    
    self.imageView.image = ( self.data.selected ) ? self.data.selectedImage : self.data.unselectedImage;
    
    _choiceItem.textColor = ( self.data.selected ) ? [UIColor whiteColor] : [UIColor darkGrayColor];
    
    [self.imageView addSubview:_choiceItem];
}

@end
