//
//  TNCheckBoxGroup.m
//  TNCheckBoxDemo
//
//  Created by Frederik Jacques on 24/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import "TNCheckBoxGroup.h"

NSString *const GROUP_CHANGED = @"groupChanged";

@interface TNCheckBoxGroup()

@property (nonatomic, strong) NSArray *checkBoxData;
@property (nonatomic) TNCheckBoxLayout layout;
@property (nonatomic) NSInteger widthOfComponent;
@property (nonatomic) NSInteger heightOfComponent;

@end

@implementation TNCheckBoxGroup

- (instancetype)initWithCheckBoxData:(NSArray *)checkBoxData style:(TNCheckBoxLayout)layout {
    
    self = [super init];
    
    if (self) {
        self.checkBoxData = checkBoxData;
        self.layout = layout;
        self.marginBetweenItems = 15;
    }
    
    return self;
}

- (void)create {
    [self createCheckBoxes];
    
    self.frame = CGRectMake(0, 0, self.widthOfComponent, self.heightOfComponent);
}

- (void)createCheckBoxes {
    
    int xPos = 0;
    int yPos = 0;
    int maxHeight = 0;
    int i = 0;
    
    NSMutableArray *tmp = [NSMutableArray new];
    
    for (TNCheckBoxData *data in self.checkBoxData) {
        
        TNCheckBox *checkBox = nil;

        if( !data.labelFont) data.labelFont = self.labelFont;
        if( !data.labelColor) data.labelColor = self.labelColor;
        
        checkBox = [[TNImageCheckbox alloc] initWithData:(TNImageCheckBoxData *)data];
        
        data.tag = i;
        
        checkBox.delegate = self;
        
        CGRect frame;
        
        if( self.layout == TNCheckBoxLayoutHorizontal ){
            frame = CGRectMake(xPos, 0, checkBox.frame.size.width, checkBox.frame.size.height);
        }else{
            frame = CGRectMake(0, yPos, checkBox.frame.size.width, checkBox.frame.size.height);
        }
        
        checkBox.frame = frame;
        [self addSubview:checkBox];
        
        xPos += checkBox.frame.size.width + self.marginBetweenItems;
        yPos += checkBox.frame.size.height + self.marginBetweenItems;
        maxHeight = MAX(maxHeight, checkBox.frame.size.height);
        
        if( self.layout == TNCheckBoxLayoutVertical ){
            maxHeight = yPos;
        }
    
        [tmp addObject:checkBox];
        i++;
    }
    
    self.widthOfComponent = xPos;
    self.heightOfComponent = maxHeight;
    self.radioButtons = [NSArray arrayWithArray:tmp];
}

#pragma TNCheckBoxDelegate
- (void)checkBoxDidChange:(TNCheckBox *)checkbox {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:GROUP_CHANGED object:self];
}

- (void)setPosition:(CGPoint)position {
    
    self.frame = CGRectMake(position.x, position.y, self.frame.size.width, self.frame.size.height);
}

- (void)showPopViewWithUrl:(NSString *)picUrl{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    //    backView.backgroundColor = [UIColor colorWithHexString:@"" alpha:0.3];
    UIButton *bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [bgBtn setBackgroundColor:[UIColor colorWithHexString:@"000000" alpha:0.3]];
    [bgBtn addTarget:self action:@selector(hideBackView:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *showImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, WIDTH/6.0, WIDTH, WIDTH)];
    NSURL *url = [NSURL URLWithString:[picUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:data];
    showImg.contentMode = UIViewContentModeScaleAspectFit;
    [showImg setImage:image];
    
    [backView addSubview:bgBtn];
    [backView addSubview:showImg];
    [self.superview.superview addSubview: backView];
    
    //    [UIView animateWithDuration:.5f animations:^{
    //        [backView  layoutIfNeeded];
    //    }];
    
}

-(void)hideBackView:(UIButton *)sender{
    [sender.superview removeFromSuperview];
    NSLog(@"SUCCESS");
}
#pragma mark - Getters / Setters
- (NSArray *)checkedCheckBoxes {
    
    NSIndexSet *set = [self.checkBoxData indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
        TNCheckBoxData *data = (TNCheckBoxData *)obj;
        return data.checked;
    }];
    
    return [self.checkBoxData objectsAtIndexes:set];
}

- (NSArray *)uncheckedCheckBoxes {
    
    NSIndexSet *set = [self.checkBoxData indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        
        TNCheckBoxData *data = (TNCheckBoxData *)obj;
        return !data.checked;
    }];
    
    return [self.checkBoxData objectsAtIndexes:set];
}

- (UIColor *)labelColor {
    
    if( !_labelColor ){
        _labelColor = [UIColor blackColor];
    }
    
    return _labelColor;
    
}

- (UIFont *)labelFont {
    
    if( !_labelFont ){
        _labelFont = [UIFont systemFontOfSize:16];
    }
    
    return  _labelFont;
}


@end
