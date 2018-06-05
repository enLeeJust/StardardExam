//
//  RadioButton.m
//  TNCheckBox
//
//  Created by Frederik Jacques on 02/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import "TNCheckBox.h"
#import <NSAttributedString+YYText.h>
@interface TNCheckBox()
@property (nonatomic,strong)UIWebView* web;
@end

@implementation TNCheckBox

#pragma mark - Initializers
- (instancetype)initWithData:(TNCheckBoxData *)data {
    
    self = [super init];
    
    if (self) {
        self.data = data;
    }
    
    return self;
}

#pragma mark - Setup
- (void)setup {
    
    //    [self createLabel];
    //    [self createHiddenButton];
    [self createLabelText];
    [self createSelectBtn];
    [self checkWithAnimation:NO];
    if ([self.data.HavePic isEqualToString:@"haveNo"]){
        self.frame = self.btnHidden.frame;
    }else{
        CGFloat btnHiddenFrame=self.lblLabel.frame.origin.x + self.lblLabel.frame.size.width;
        CGRect newFrame = self.btnHidden.frame;
        newFrame.size.width = btnHiddenFrame;
        self.frame = newFrame;
    }
    //    self.frame = self.btnHidden.frame;
}

- (void)createCheckbox {};

-(void)createLabelText{
    CGRect labelRect = [self.data.labelText boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-70, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    
    self.lblLabel =  [[YYLabel alloc] initWithFrame:CGRectMake(self.checkBox.frame.origin.x + self.checkBox.frame.size.width + 15, (self.checkBox.frame.size.height - labelRect.size.height) / 2, labelRect.size.width, labelRect.size.height)];
    
    
    self.lblLabel.numberOfLines = 0;
    self.lblLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.lblLabel.font = self.data.labelFont;
    self.lblLabel.textColor = self.data.labelColor;
    if ([self.data.HavePic isEqualToString:@"haveNo"]) {//没有图片
        self.lblLabel.text = self.data.labelText;
    }else{//有图片
        NSString *tmpStr = self.data.labelText;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:tmpStr];
        text.yy_font = [UIFont systemFontOfSize:16];
        NSRange range;
        for (int i = 0; i<self.data.picUrls.count; i++) {
            range = [tmpStr rangeOfString:[NSString stringWithFormat:@"图%d",i+1]];
            if (range.location != NSNotFound) {
                [text yy_setTextHighlightRange:NSMakeRange(range.location, range.length)
                                         color:[UIColor orangeColor]
                               backgroundColor:[UIColor whiteColor]
                                     tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                         //显示图片
                                         [self showMyPopView:self.data.picUrls[i]];
                                         
                                     }];
                
                
            }
            
        }
        self.lblLabel.attributedText = text;
        
    }
    
    
    [self addSubview:self.lblLabel];
    
}
//显示图片
-(void)showMyPopView:(NSString *)picUrl{
    if ([self.delegate respondsToSelector:@selector(showPopViewWithUrl:)]) {
        [self.delegate showPopViewWithUrl:picUrl];
    }
    
    
    
}

- (void)createLabel {
    if ([self.data.HavePic isEqualToString:@"haveNo"]) {
        CGRect labelRect = [self.data.labelText boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-70, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
        
        self.lblLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.checkBox.frame.origin.x + self.checkBox.frame.size.width + 15, (self.checkBox.frame.size.height - labelRect.size.height) / 2, labelRect.size.width, labelRect.size.height)];
        self.lblLabel.numberOfLines = 0;
        self.lblLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.lblLabel.font = self.data.labelFont;
        self.lblLabel.textColor = self.data.labelColor;
        self.lblLabel.text = self.data.labelText;
        [self addSubview:self.lblLabel];
    }else{
        CGRect rc = [UIScreen mainScreen].bounds;
        _web = [[UIWebView alloc]initWithFrame:CGRectMake(self.checkBox.frame.origin.x +self.checkBox.frame.size.width+15, self.checkBox.frame.origin.y-5, rc.size.width - self.checkBox.frame.size.width - self.checkBox.frame.origin.x -30, 50)];
        _web.dataDetectorTypes = UIDataDetectorTypeAll;
        _web.scalesPageToFit=YES;
        _web.delegate = self;
        NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        [_web loadHTMLString:self.data.labelText baseURL:baseURL];
        [self addSubview:_web];
    }
}
#pragma mark --UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:
     @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '320%'"];
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"]floatValue];
    CGFloat width = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth"]floatValue];
    CGFloat scale=height/width;
    
    webView.frame=CGRectMake(self.checkBox.frame.origin.x +self.checkBox.frame.size.width+15, self.checkBox.frame.origin.y-5, self.web.frame.size.width, (self.web.frame.size.width)*scale);
    [webView reload];
    CGRect frame = self.checkBox.frame;
    frame.size.height = (self.web.frame.size.width)*scale;
    self.checkBox.frame = frame;
}
//- (void)createHiddenButton {
//    
//    int height = MAX(self.lblLabel.frame.size.height, self.checkBox.frame.size.height);
//    
//    self.btnHidden = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.btnHidden.frame = CGRectMake(8, 0, self.lblLabel.frame.origin.x + self.lblLabel.frame.size.width, height);
//    [self addSubview:self.btnHidden];
//    
//    [self.btnHidden addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
//}


#pragma mark - Target / Actions
- (void)buttonTapped:(id)sender {
    
    self.data.checked = !self.data.checked;
    [self checkWithAnimation:YES];
    
    if ([self.delegate respondsToSelector:@selector(checkBoxDidChange:)]) {
        [self.delegate checkBoxDidChange:self];
    }
    
}
-(void)createSelectBtn{
    if ([self.data.HavePic isEqualToString:@"haveNo"]) {
        int height = MAX(self.lblLabel.frame.size.height, self.checkBox.frame.size.height);
        
        self.btnHidden = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHidden.frame = CGRectMake(8, 0, self.lblLabel.frame.origin.x + self.lblLabel.frame.size.width, height);
    }else if ([self.data.HavePic isEqualToString:@"have"]) {
        int height = MAX(self.web.frame.size.height, self.checkBox.frame.size.height);
        
        self.btnHidden = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHidden.frame = CGRectMake(8, 0, self.lblLabel.frame.origin.x-20, height);
    }
    
    
    [self addSubview:self.btnHidden];
    
    [self.btnHidden addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)createHiddenButton {
    if ([self.data.HavePic isEqualToString:@"haveNo"]) {
        int height = MAX(self.lblLabel.frame.size.height, self.checkBox.frame.size.height);
        
        self.btnHidden = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHidden.frame = CGRectMake(8, 0, self.lblLabel.frame.origin.x + self.lblLabel.frame.size.width, height);
    }else if ([self.data.HavePic isEqualToString:@"have"]) {
        int height = MAX(self.web.frame.size.height, self.checkBox.frame.size.height);
        
        self.btnHidden = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHidden.frame = CGRectMake(8, 0, self.web.frame.origin.x + self.web.frame.size.width, height);
    }
    
    [self addSubview:self.btnHidden];
    
    [self.btnHidden addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Animations
- (void)checkWithAnimation:(BOOL)animated {}

#pragma mark - Getters / Setters
- (void)setPosition:(CGPoint)position {
    
    _position = position;
    
    self.frame = CGRectMake( position.x, position.y, self.frame.size.width, self.frame.size.height);
    
}

@end
