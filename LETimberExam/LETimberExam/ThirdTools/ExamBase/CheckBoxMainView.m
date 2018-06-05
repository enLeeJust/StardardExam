//
//  MainView.m
//  TNCheckBoxDemo
//
//  Created by Frederik Jacques on 02/04/14.
//  Copyright (c) 2014 Frederik Jacques. All rights reserved.
//

#import "CheckBoxMainView.h"
#define IMGURL @"http://121.42.216.164/"
#define FONT_SIZE 16.0f
#define CELL_CONTENT_WIDTH [[UIScreen mainScreen] bounds].size.width
#define CELL_CONTENT_MARGIN 10.0f
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation CheckBoxMainView
{
    UIWebView* MywebView;
    UIScrollView * scrView;
}

- (id)initWithFrame:(CGRect)frame :(NSString *)title1 :(NSString *)title2 :(NSString *)title3 :(NSString *)title4 :(NSString *)title5 :(NSString *)title6 :(NSString *)title7 :(Boolean)isShowAnswer{
    str = @"显示答案和解析";
    saveAnswer = [[NSMutableArray alloc]init];
    self.childQTitleLable = title1;
    self.childQTypeLable = title2;
    self.childQIdLable = title3;
    self.childQPointLable = title4;
    self.childQAnswerLable = title5;
    self.childQBodyLable = title6;
    self.childQMmarkLable = title7;
    _isShowAnswer = isShowAnswer;
    //以后增加字段
    _isMarkQuestion = false;
    
    [self createHorizontalListWithImage];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame :(NSString *)title1 :(NSString *)title2 :(NSString *)title3 :(NSString *)title4 :(NSString *)title5 :(NSString *)title6 :(NSString *)title7 :(Boolean)isShowAnswer :(NSString *)title8{
    str = @"显示答案和解析";
    saveAnswer = [[NSMutableArray alloc]init];
    self.childQTitleLable = title1;
    self.childQTypeLable = title2;
    self.childQIdLable = title3;
    self.childQPointLable = title4;
    self.childQAnswerLable = title5;
    self.childQBodyLable = title6;
    self.childQMmarkLable = title7;
    self.childHistoryAnswer = title8;
    _isShowAnswer = isShowAnswer;
    //以后增加字段
    _isMarkQuestion = false;
    [self createHorizontalListWithImage];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame questitle:(NSString*)quesTitle examInfo:(ExamQuestionModel*)examinfo isShowAnswer:(BOOL)ShowAnswer{
    str = @"显示答案和解析";
    //    self.childQTitleLable = [examinfo objectForKey:@"QTitle"];
    self.childQTitleLable = quesTitle;
    
    self.childQTypeLable = [NSString stringWithFormat:@"%ld",examinfo.type_id];
    self.childQIdLable = [NSString stringWithFormat:@"%ld",examinfo.ques_id];
    self.childQIdLable = examinfo.ques_point;
    self.childQAnswerLable = examinfo.ques_answer;
    self.childQBodyLable = examinfo.ques_body;
    self.childQMmarkLable = examinfo.ques_mark;
    

    //    self.childHistoryAnswer = [examinfo objectForKey:@""];
    _isShowAnswer = ShowAnswer;
    //以后增加字段
    _isMarkQuestion = false;
    [self createHorizontalListWithImage];
    return self;
}


-(int)getTitleHight:(NSString *)titleInfo
{
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGRect size = [titleInfo boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]} context:nil];
    CGFloat height = MAX(size.size.height, 44.0f);
    return height + (CELL_CONTENT_MARGIN * 2);
}

#pragma mark 创建题目视图(label)
-(void)createQuestionTitleLabelView{
    labltTitle = [[UILabel alloc]init];
    labltTitle.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    NSString *qTitleStr = [self filterHTML:self.childQTitleLable];
    CGRect size = [qTitleStr boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]} context:nil];
    [labltTitle setNumberOfLines:0];
    [labltTitle setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    [labltTitle setText:[self filterHTML:self.childQTitleLable]];
    [labltTitle setFrame:CGRectMake(5, 0, CELL_CONTENT_WIDTH-10 , MAX(size.size.height, 44.0f))];
    labltTitle.backgroundColor = WhiteColor;
}
#pragma mark 创建题目视图(webView)
-(void)createQuestionTitleWebView{
    MywebView = [[UIWebView alloc]initWithFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 60)];
    MywebView.dataDetectorTypes = UIDataDetectorTypeAll;
    MywebView.delegate = self;
    MywebView.scalesPageToFit=YES;
}
#pragma mark 创建标记按钮和分割线
-(void)createMarkAndDivideLineView:(UIView *)myView{
    markQuesBtn = [[UIButton alloc] initWithFrame:CGRectMake(CELL_CONTENT_WIDTH - 70, myView.frame.size.height+3, 65, 24)];
    
    if (!_isMarkQuestion) {
        [markQuesBtn setBackgroundImage:[UIImage imageNamed:@"ic_exam_not_mark_bg"] forState:UIControlStateNormal];
        [markQuesBtn setTitle:@"标记该题" forState:UIControlStateNormal];
        [markQuesBtn setImage:[UIImage imageNamed:@"ic_exam_mark_question"] forState:UIControlStateNormal];
        [markQuesBtn setTitleColor:MyOrange forState:UIControlStateNormal];//设置title在一般情况下为白色字体
    }else{
        [markQuesBtn setBackgroundImage:[UIImage imageNamed:@"ic_exam_mark_bg"] forState:UIControlStateNormal];
        [markQuesBtn setTitle:@"已标记" forState:UIControlStateNormal];
        [markQuesBtn setImage:[UIImage imageNamed:@"ic_exam_marked"] forState:UIControlStateNormal];
        [markQuesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
        
    }
    
    [markQuesBtn addTarget:nil action:@selector(userMarkTheQuestion) forControlEvents:UIControlEventTouchUpInside];
    
    markQuesBtn.titleLabel.font = [UIFont systemFontOfSize:11];//title字体大小
    markQuesBtn.titleLabel.textAlignment = NSTextAlignmentLeft;//设置title的字体居左
    markQuesBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [scrollView addSubview:markQuesBtn];
    
    
    divideLineView = [[UIView alloc] initWithFrame:CGRectMake(5, myView.frame.size.height+3+markQuesBtn.frame.size.height+5, CELL_CONTENT_WIDTH-10, 1)];
    divideLineView.backgroundColor = MyBackColor;
    [scrollView addSubview:divideLineView];
}


- (void)createHorizontalListWithImage {
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CELL_CONTENT_WIDTH, self.view.frame.size.height-81)];
    NSRange r = [self.childQTitleLable rangeOfString:@"src"];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    
    if (r.location == NSNotFound) {//没有图片
        [MywebView removeFromSuperview];
        MywebView = nil;
        [self createQuestionTitleLabelView];
        [self.view addSubview:labltTitle];
        [self createMarkAndDivideLineView:labltTitle];
        
    }else{//有图片
        [labltTitle removeFromSuperview];
        labltTitle = nil;
        [self createQuestionTitleWebView];
        NSMutableString* html = [self.childQTitleLable mutableCopy];
        NSRange range=[html rangeOfString:@"../"];
        while (range.location!=NSNotFound) {
            [html replaceCharactersInRange:range withString:IMGURL];
            range=[html rangeOfString:@"../"];
        }
        NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        [MywebView loadHTMLString:html baseURL:baseURL];
        [self.view addSubview:MywebView];
        
        [self createMarkAndDivideLineView:MywebView];
    }
    
    if (r.location == NSNotFound) {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        NSArray *_arrayStr ;
        if([self.childQBodyLable rangeOfString:@"p><p>"].location == NSNotFound ){
            
            if ([self.childQBodyLable rangeOfString:@"<br/>"].location == NSNotFound ) {
                _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"<BR/>"];
                if ([self.childQBodyLable rangeOfString:@"<br />"].location == NSNotFound) {
                    
                }else{
                    _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"<br />"];
                }
            }else{
                _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"<br/>"];
            }
        }else{
            _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"<\/p><p>"];
        }
        
        NSMutableArray *selectNumbers = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K", nil];
        for (int i = 0; i<[_arrayStr count]; i++) {
            NSString* s = [_arrayStr objectAtIndex:i];
            s = [s stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
            s = [s stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
            s = [s stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
            NSRange rang = [s rangeOfString:@"src"];
            TNImageCheckBoxData *womanData = [[TNImageCheckBoxData alloc] init];
            if (rang.location == NSNotFound) {
                womanData.HavePic = @"haveNo";
                womanData.labelText = s;
            }else{
                NSMutableString* html = [s mutableCopy];
                NSRange range=[html rangeOfString:@"../"];
                while (range.location!=NSNotFound) {
                    [html replaceCharactersInRange:range withString:IMGURL];
                    range=[html rangeOfString:@"../"];
                }
                womanData.HavePic = @"have";
                womanData.labelText = html;
            }
            womanData.identifier = [NSString stringWithFormat:@"%d",i];
            womanData.checkedImage = [UIImage imageNamed:@"check_icon"];
            womanData.uncheckedImage = [UIImage imageNamed:@"uncheck_icon"];
            if (self.childHistoryAnswer.length!=0&&[self.childHistoryAnswer rangeOfString:[selectNumbers objectAtIndex:i]].location!=NSNotFound) {
                womanData.checked = YES;
            }
            [array addObject:womanData];
        }
        
        
        self.loveGroup = [[TNCheckBoxGroup alloc] initWithCheckBoxData:array style:TNCheckBoxLayoutVertical];
        [self.loveGroup create];
        //    self.loveGroup.position = CGPointMake(0, [self getTitleHight:self.childQTitleLable]+50);
        if (r.location == NSNotFound) {
            self.loveGroup.position = CGPointMake(0, CGRectGetMaxY(labltTitle.frame)+markQuesBtn.frame.size.height+divideLineView.frame.size.height+28);
        }else{
            self.loveGroup.position = CGPointMake(0, CGRectGetMaxY(MywebView.frame)+markQuesBtn.frame.size.height+divideLineView.frame.size.height+28);
        }
        if (_isShowAnswer ==YES) {
            hideLable = [[UILabel alloc]init];
            hideLable.tag = 0;
            hideLable.lineBreakMode = NSLineBreakByWordWrapping;
            CGRect size = [str boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]} context:nil];
            [hideLable setNumberOfLines:1];
            [hideLable setFont:[UIFont systemFontOfSize:FONT_SIZE]];
            [hideLable setText:str];
            if (r.location == NSNotFound) {
                [hideLable setFrame:CGRectMake(CELL_CONTENT_MARGIN, self.loveGroup.frame.size.height+labltTitle.frame.size.height+70, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.size.height, 44.0f))];
            }else{
                [hideLable setFrame:CGRectMake(CELL_CONTENT_MARGIN, self.loveGroup.frame.size.height+MywebView.frame.size.height+70, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.size.height, 44.0f))];
            }
            
            hideLable.backgroundColor = UIColorFromRGB(0xfafafa);
            hideLable.userInteractionEnabled=YES;
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAnswerAndMark)];
            [hideLable addGestureRecognizer:tapGesture];
        }
        if (r.location == NSNotFound) {
            scrollView.contentSize = CGSizeMake(CELL_CONTENT_WIDTH, self.loveGroup.frame.size.height+labltTitle.frame.size.height+markQuesBtn.frame.size.height+divideLineView.frame.size.height+150+hideLable.frame.size.height);
        }else{
            scrollView.contentSize = CGSizeMake(CELL_CONTENT_WIDTH, self.loveGroup.frame.size.height+MywebView.frame.size.height+markQuesBtn.frame.size.height+divideLineView.frame.size.height+150+hideLable.frame.size.height);
        }

        [scrollView addSubview:self.loveGroup];
        [scrollView addSubview:hideLable];
        [self.view addSubview:scrollView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loveGroupChanged:) name:GROUP_CHANGED object:self.loveGroup];
    }
}


#pragma mark 标记题目事件
-(void)userMarkTheQuestion{
    NSLog(@"Mark");
    _isMarkQuestion = !_isMarkQuestion;
    if (!_isMarkQuestion) {
        [markQuesBtn setBackgroundImage:[UIImage imageNamed:@"ic_exam_not_mark_bg"] forState:UIControlStateNormal];
        [markQuesBtn setTitle:@"标记该题" forState:UIControlStateNormal];
        [markQuesBtn setImage:[UIImage imageNamed:@"ic_exam_mark_question"] forState:UIControlStateNormal];
        [markQuesBtn setTitleColor:MyOrange forState:UIControlStateNormal];//设置title在一般情况下为白色字体
    }else{
        [markQuesBtn setBackgroundImage:[UIImage imageNamed:@"ic_exam_mark_bg"] forState:UIControlStateNormal];
        [markQuesBtn setTitle:@"已标记" forState:UIControlStateNormal];
        [markQuesBtn setImage:[UIImage imageNamed:@"ic_exam_marked"] forState:UIControlStateNormal];
        [markQuesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
        
    }
}
#pragma mark --UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:
     @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '250%'"];
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"]floatValue];
    CGFloat width = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth"]floatValue];
    CGFloat scale=height/width;
    
    webView.frame=CGRectMake(0, 0, MywebView.frame.size.width, (MywebView.frame.size.width)*scale);
    [webView reload];
}
-(void)showAnswerAndMark
{
    NSString *resultMark = [NSString stringWithFormat:@"%@%@%@%@%@",@"答案:  ",self.childQAnswerLable,@"\n",@"解析:  ",self.childQMmarkLable];
    if (hideLable.tag == 0) {
        hideLable.tag = 1;
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
        CGRect size = [resultMark boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]} context:nil];
        [hideLable setNumberOfLines:0];
        [hideLable setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [hideLable setText:resultMark];
        NSRange r = [self.childQTitleLable rangeOfString:@"src"];
        if (r.location == NSNotFound) {
            [hideLable setFrame:CGRectMake(CELL_CONTENT_MARGIN, self.loveGroup.frame.size.height+labltTitle.frame.size.height+70, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.size.height, 44.0f))];
            scrollView.contentSize = CGSizeMake(CELL_CONTENT_WIDTH, self.loveGroup.frame.size.height+labltTitle.frame.size.height+140+MAX(size.size.height, 44.0f));
        }else{
            [hideLable setFrame:CGRectMake(CELL_CONTENT_MARGIN, self.loveGroup.frame.size.height+MywebView.frame.size.height+70, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(size.size.height, 44.0f))];
            scrollView.contentSize = CGSizeMake(CELL_CONTENT_WIDTH, self.loveGroup.frame.size.height+MywebView.frame.size.height+140+MAX(size.size.height, 44.0f));
        }
        
        
    }else{
        hideLable.tag = 0;
        CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
       CGRect sizeHide = [str boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]} context:nil];
        
        [hideLable setNumberOfLines:1];
        [hideLable setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [hideLable setText:str];
        NSRange r = [self.childQTitleLable rangeOfString:@"src"];
        if (r.location == NSNotFound) {
            [hideLable setFrame:CGRectMake(CELL_CONTENT_MARGIN, self.loveGroup.frame.size.height+labltTitle.frame.size.height+70, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(sizeHide.size.height, 44.0f))];
            scrollView.contentSize = CGSizeMake(CELL_CONTENT_WIDTH, self.loveGroup.frame.size.height+labltTitle.frame.size.height+140+MAX(sizeHide.size.height, 44.0f));
        }else{
            [hideLable setFrame:CGRectMake(CELL_CONTENT_MARGIN, self.loveGroup.frame.size.height+MywebView.frame.size.height+70, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), MAX(sizeHide.size.height, 44.0f))];
            scrollView.contentSize = CGSizeMake(CELL_CONTENT_WIDTH, self.loveGroup.frame.size.height+MywebView.frame.size.height+140+MAX(sizeHide.size.height, 44.0f));
        }
        
        
    }
    
}


- (void)loveGroupChanged:(NSNotification *)notification {
    [saveAnswer removeAllObjects];
    NSArray *result = self.loveGroup.checkedCheckBoxes;
    for (int i =0; i<[result count]; i++) {
        if ((int)[[result objectAtIndex:i] tag]==0) {
            [saveAnswer addObject:@"A"];
        }else if ((int)[[result objectAtIndex:i] tag]==1) {
            [saveAnswer addObject:@"B"];
        }else if ((int)[[result objectAtIndex:i] tag]==2) {
            [saveAnswer addObject:@"C"];
        }else if ((int)[[result objectAtIndex:i] tag]==3) {
            [saveAnswer addObject:@"D"];
        }else if ((int)[[result objectAtIndex:i] tag]==4) {
            [saveAnswer addObject:@"E"];
        }else{
            [saveAnswer addObject:@"F"];
        }
    }
    NSString * Str = [NSString stringWithFormat:@""];
    NSArray *sortedArray = [saveAnswer sortedArrayUsingSelector:@selector(compare:)];//重新按照字母进行排序
    for (int  i = 0; i < [sortedArray count] ; i ++ ) {
        Str  = [Str stringByAppendingString:[sortedArray objectAtIndex:i]];
    }
    self.answerUser = Str;
    
    [self.delegate userAnserCount];
    NSLog(@"--%@",self.answerUser);
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GROUP_CHANGED object:self.loveGroup];
}

-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    NSString * regEx = @"&nbsp;";
    html = [html stringByReplacingOccurrencesOfString:regEx withString:@" "];
    return html;
}

@end
