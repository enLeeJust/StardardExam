//
//  RadioButton.m
//  TNRadioButtonGroupDemo
//
//  Created by Frederik Jacques on 22/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import "TNRadioButton.h"
#import <NSAttributedString+YYText.h>

@interface TNRadioButton()
@property (nonatomic,strong)UIWebView* web;
@property (nonatomic,strong)UIButton* backBtn;
@property (nonatomic,strong)UIView* popView;
@end

@implementation TNRadioButton

- (instancetype)initWithData:(TNRadioButtonData *)data {
    
    self = [super init];
    
    if (self) {
        self.data = data;
    }
    
    return self;
}

- (void)setup {
    
//    [self createLabel];
    [self createLabelText];
//    [self createHiddenButton];
    [self createSelectBtn];
    
    [self selectWithAnimation:NO];
    if ([self.data.HavePic isEqualToString:@"haveNo"]){
        self.frame = self.btnHidden.frame;
    }else{
        CGFloat btnHiddenFrame=self.lblLabel.frame.origin.x + self.lblLabel.frame.size.width;
        CGRect newFrame = self.btnHidden.frame;
        newFrame.size.width = btnHiddenFrame;
        self.frame = newFrame;
    }
    
}

- (void)createRadioButton {}


-(void)createLabelText{
    CGRect labelRect = [self.data.labelText boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-70, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    
    self.lblLabel = [[YYLabel alloc] initWithFrame:CGRectMake(self.radioButton.frame.origin.x + self.radioButton.frame.size.width + 15, (self.radioButton.frame.size.height - labelRect.size.height) / 2, labelRect.size.width, labelRect.size.height)];
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


- (void)createLabel {
    if ([self.data.HavePic isEqualToString:@"haveNo"]) {
        CGRect labelRect = [self.data.labelText boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-70, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
        
        self.lblLabel = [[YYLabel alloc] initWithFrame:CGRectMake(self.radioButton.frame.origin.x + self.radioButton.frame.size.width + 15, (self.radioButton.frame.size.height - labelRect.size.height) / 2, labelRect.size.width, labelRect.size.height)];
        self.lblLabel.numberOfLines = 0;
        self.lblLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.lblLabel.font = self.data.labelFont;
        
        
        self.lblLabel.textColor = self.data.labelColor;
        self.lblLabel.text = self.data.labelText;
        [self addSubview:self.lblLabel];
    }else{
        CGRect rc = [UIScreen mainScreen].bounds;
        self.web = [[UIWebView alloc]initWithFrame:CGRectMake(self.radioButton.frame.origin.x +self.radioButton.frame.size.width+15, self.radioButton.frame.origin.y-5, rc.size.width - self.radioButton.frame.size.width - self.radioButton.frame.origin.x - 30, 50)];
        _web.dataDetectorTypes = UIDataDetectorTypeAll;
        _web.scalesPageToFit=YES;
        _web.delegate = self;
        NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        [_web loadHTMLString:self.data.labelText baseURL:baseURL];
        [self addSubview:_web];
    }
}

//显示图片
-(void)showMyPopView:(NSString *)picUrl{
    if ([self.delegate respondsToSelector:@selector(showPopViewWithUrl:)]) {
        [self.delegate showPopViewWithUrl:picUrl];
    }
    
    
    
}



#pragma mark -- UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:
     @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '320%'"];
//    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"]floatValue];
//    CGFloat width = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth"]floatValue];
//    CGFloat scale=height/width;
    CGFloat webViewHeight=[webView.scrollView contentSize].height;
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    webView.frame = newFrame;
    CGFloat scale=webViewHeight/WIDTH;
//    webView.frame=CGRectMake(self.radioButton.frame.origin.x +self.radioButton.frame.size.width+15, self.radioButton.frame.origin.y-5, self.web.frame.size.width, (self.web.frame.size.width)*scale);
    [webView reload];
    CGRect frame = self.radioButton.frame;
    frame.size.height = (self.web.frame.size.width)*scale;
    self.radioButton.frame = frame;
}

-(void)createSelectBtn{
    if ([self.data.HavePic isEqualToString:@"haveNo"]) {
        int height = MAX(self.lblLabel.frame.size.height, self.radioButton.frame.size.height);
        
        self.btnHidden = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHidden.frame = CGRectMake(8, 0, self.lblLabel.frame.origin.x + self.lblLabel.frame.size.width, height);
    }else if ([self.data.HavePic isEqualToString:@"have"]) {
        int height = MAX(self.web.frame.size.height, self.radioButton.frame.size.height);
        
        self.btnHidden = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHidden.frame = CGRectMake(8, 0, self.lblLabel.frame.origin.x-20, height);
    }
    
    
    [self addSubview:self.btnHidden];
    
    [self.btnHidden addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)createHiddenButton {
    if ([self.data.HavePic isEqualToString:@"haveNo"]) {
        int height = MAX(self.lblLabel.frame.size.height, self.radioButton.frame.size.height);
        
        self.btnHidden = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHidden.frame = CGRectMake(8, 0, self.lblLabel.frame.origin.x + self.lblLabel.frame.size.width, height);
    }else if ([self.data.HavePic isEqualToString:@"have"]) {
        int height = MAX(self.web.frame.size.height, self.radioButton.frame.size.height);
        
        self.btnHidden = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHidden.frame = CGRectMake(8, 0, self.web.frame.origin.x + self.web.frame.size.width, height);
    }

    [self addSubview:self.btnHidden];
    
    [self.btnHidden addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonTapped:(id)sender {
    
    if( !self.data.selected ){
        self.data.selected = !self.data.selected;
        
        if ([self.delegate respondsToSelector:@selector(radioButtonDidChange:)]) {
            [self.delegate radioButtonDidChange:self];
        }
        
    }
}

#pragma mark - Animations
- (void)selectWithAnimation:(BOOL)animated {}

@end
