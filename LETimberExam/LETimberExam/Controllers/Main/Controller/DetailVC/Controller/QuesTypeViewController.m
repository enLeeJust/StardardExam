//
//  QuesTypeViewController.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/26.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "QuesTypeViewController.h"
#define IMGURL @"src=\"http://p1j4894351.51mypc.cn:11919/"
#define FONT_SIZE 16.0f
#define CELL_CONTENT_WIDTH [[UIScreen mainScreen] bounds].size.width
#define CELL_CONTENT_MARGIN 10.0f
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ID        @"id"
@interface QuesTypeViewController (){
    UIWebView* MywebView;
    
    FMDatabase *db;
    NSString *database_path;//数据库路径
}
@property(nonatomic,strong)UIScrollView *scroollView;

@end

@implementation QuesTypeViewController

- (id)initWithFrame:(CGRect)frame questitle:(NSString*)quesTitle examInfo:(ExamQuestionModel*)examinfo isShowAnswer:(BOOL)ShowAnswer examOrPractice:(long)examFlag inPaper:(NSString *)planName{

    saveAnswer = [[NSMutableArray alloc]init];
    //    self.childQTitleLable = [examinfo objectForKey:@"QTitle"];
    quesDetailModel = examinfo;
    self.childQTitleLable = quesTitle;
    
    //用于标识 题目类型:单选，多选，简答
    NSString *quesType = examinfo.ModuleUrl;
    if ([quesType isEqualToString:@"Question_S_Choice.ascx"]) {//单选
        self.childQTypeLable = @"1";
    }else if ([quesType isEqualToString:@"Question_M_Choice.ascx"]) {//多选
        self.childQTypeLable = @"2";
    }else if ([quesType isEqualToString:@"Question_Checking.ascx"]) {//判断
        self.childQTypeLable = @"3";
    }else if ([quesType isEqualToString:@"Question_Fill.ascx"]) {//填空
        self.childQTypeLable = @"4";
    }else if ([quesType isEqualToString:@"Question_Answer.ascx"]) {//简答
        self.childQTypeLable = @"5";
    }else{
        
    }
    
//    self.childQTypeLable = [NSString stringWithFormat:@"%ld",examinfo.type_id];
    self.childQIdLable = [NSString stringWithFormat:@"%ld",examinfo.ques_id];
    self.childQPointLable = examinfo.ques_point;
    self.childQAnswerLable = examinfo.ques_answer;
    self.childQBodyLable = examinfo.ques_body;
    self.childQMmarkLable = examinfo.ques_mark;

    //    self.childHistoryAnswer = [examinfo objectForKey:@""];
    _isShowAnswer = ShowAnswer;
    _examOrPractice = examFlag;
    _quesPlanName = planName;
    //以后增加字段
    _isMarkQuestion = false;
    
    return self;
}
//错题 收藏 传过来的参数  含有用户之前给的 答案
-(id)initWithFrame:(CGRect)frame questitle:(NSString*)quesTitle QBody:(NSString *)quesBody Qmark:(NSString *)quesMark QAnswer:(NSString *)quesAnswer UserAnswer:(NSString *)userAsnser QType:(long)quesType Qid:(long)quesId PlanName:(NSString *)planName examOrPractice:(long)examFlag isShowAnswer:(BOOL)isShow{
    self.childQTitleLable = quesTitle;
    
    //用于标识 题目类型:单选，多选，简答
    self.childQTypeLable = [NSString stringWithFormat:@"%ld",quesType];
    self.childQIdLable = [NSString stringWithFormat:@"%ld",quesId];
//    self.childQPointLable = examinfo.ques_point;
    self.childQAnswerLable = quesAnswer;
    self.childQBodyLable = quesBody;
    self.childQMmarkLable = quesMark;
    if(userAsnser==NULL|| userAsnser == nil||[userAsnser isKindOfClass:[NSNull class]]||[userAsnser isEqualToString:@""]){
         _userAnswerInErr = @"未答题";
    }else{
        _userAnswerInErr = userAsnser;
    }
    
    
    _examOrPractice = examFlag;
    _isShowAnswer = isShow;
    return self;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    数据库路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    db = [FMDatabase databaseWithPath:database_path];
    [self createTable:TABLECOLLECT];
    
    _isCollectQuestion = ![self selectDataInDB:TABLECOLLECT withID:quesDetailModel.ques_id];
    
    _scroollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CELL_CONTENT_WIDTH, self.view.frame.size.height-81)];

    [_scroollView setContentSize:CGSizeMake(WIDTH-10, HEIGHT*2)];
    [self.view addSubview:_scroollView];
    
    [self createHorizontalListWithImage:_childQTypeLable];
     NSLog(@"self.childQTypeLable:%@",self.childQTypeLable);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 创建答案列表（含图片）
- (void)createHorizontalListWithImage:(NSString *)typeID{
    NSRange titleRange = [self.childQTitleLable rangeOfString:@"src"];
    NSRange bodyRange = [self.childQBodyLable rangeOfString:@"src"];
    //创建题目title
    [self createQuesTitleView:titleRange];
    //创建题目Body
    if ([typeID isEqualToString:@"1"]||[typeID isEqualToString:@"3"]) {//单选，判断
        
        [self createQuesRadioContentBodyView:bodyRange];
        //创建题目答案和解析
        if (_isShowAnswer ==YES) {
            [self createAnsBtnAndDevideLine:_temperatureGroup hasPic:titleRange];
        }

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(temperatureGroupUpdated:) name:SELECTED_RADIO_BUTTON_CHANGED object:self.temperatureGroup];
        
    }else if([typeID isEqualToString:@"2"]){//多选
        [self createQuesCheckContentBodyView:bodyRange];
        //创建题目答案和解析
        if (_isShowAnswer ==YES) {
            [self createAnsBtnAndDevideLine:_loveGroup hasPic:titleRange];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loveGroupChanged:) name:GROUP_CHANGED object:self.loveGroup];
        
        
    }else{//填空，简答
    
    
    }
    

}



#pragma mark person Function
/**
 *  创建label模板
 *
 */

-(UILabel *)createMyLabel:(CGFloat)labelLoactionX locationY:(CGFloat)labelLoactionY LabelColor:(UIColor*)labelColor withFont:(UIFont *)font AndTextStr:(NSString *)labelTextStr{
    UILabel *modelLabel = [[UILabel alloc]init];
    
    modelLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGRect size = [labelTextStr boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    [modelLabel setNumberOfLines:0];
    [modelLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    [modelLabel setText:labelTextStr];
    [modelLabel setFrame:CGRectMake(labelLoactionX+5, labelLoactionY, CELL_CONTENT_WIDTH-10 , MAX(size.size.height, 44.0f))];
    //    [modelLabel setFrame:labelFrame];
    modelLabel.backgroundColor = WhiteColor;
    modelLabel.textColor = labelColor;
    return modelLabel;
    
}

-(YYLabel *)createYYLabel:(CGFloat)labelLoactionX locationY:(CGFloat)labelLoactionY LabelColor:(UIColor*)labelColor withFont:(UIFont *)font AndTextStr:(NSString *)labelTextStr{
    YYLabel *modelLabel = [[YYLabel alloc]init];
    
    modelLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGRect size = [labelTextStr boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    [modelLabel setNumberOfLines:0];
    [modelLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    [modelLabel setText:labelTextStr];
    [modelLabel setFrame:CGRectMake(labelLoactionX+5, labelLoactionY, CELL_CONTENT_WIDTH-10 , MAX(size.size.height, 44.0f))];
    //    [modelLabel setFrame:labelFrame];
    modelLabel.backgroundColor = WhiteColor;
    modelLabel.textColor = labelColor;
    return modelLabel;
    
}

#pragma mark 创建题目视图(label)
-(void)createQuestionTitleLabelView{
    labltTitle = [self createYYLabel:5 locationY:0 LabelColor:[UIColor blackColor] withFont:[UIFont systemFontOfSize:FONT_SIZE] AndTextStr:[self filterHTML:self.childQTitleLable]];
}

-(void)createQuestionTitleYYLabelView:(NSString *)text{
    labltTitle = [self createYYLabel:5 locationY:0 LabelColor:[UIColor blackColor] withFont:[UIFont systemFontOfSize:FONT_SIZE] AndTextStr:[self filterHTML:text]];
}
#pragma mark 创建题目视图(webView)
-(void)createQuestionTitleWebView{
    MywebView = [[UIWebView alloc]initWithFrame:CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 40)];
    MywebView.dataDetectorTypes = UIDataDetectorTypeAll;
    MywebView.delegate = self;
    MywebView.scalesPageToFit=YES;
}

#pragma mark 创建标记按钮和分割线
-(void)createMarkAndDivideLineView:(UIView *)myView{
    markQuesBtn = [[UIButton alloc] initWithFrame:CGRectMake(CELL_CONTENT_WIDTH - 70, myView.frame.size.height+13, 65, 24)];

    if (_examOrPractice == 1) {
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
    }else if (_examOrPractice ==2){
        if (!_isCollectQuestion) {
            [markQuesBtn setBackgroundImage:[UIImage imageNamed:@"ic_practice_not_collect_bg"] forState:UIControlStateNormal];
            [markQuesBtn setTitle:@"收藏该题" forState:UIControlStateNormal];
            [markQuesBtn setImage:[UIImage imageNamed:@"ic_practice_not_collect"] forState:UIControlStateNormal];
            [markQuesBtn setTitleColor:MyOrange forState:UIControlStateNormal];//设置title在一般情况下为白色字体
        }else{
            [markQuesBtn setBackgroundImage:[UIImage imageNamed:@"ic_practice_collected_bg"] forState:UIControlStateNormal];
            [markQuesBtn setTitle:@"已收藏" forState:UIControlStateNormal];
            [markQuesBtn setImage:[UIImage imageNamed:@"ic_practice_collected"] forState:UIControlStateNormal];
            [markQuesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
            
        }
        [markQuesBtn addTarget:nil action:@selector(userCollectTheQuestion) forControlEvents:UIControlEventTouchUpInside];
    
    }else if (_examOrPractice ==3){//错题
        markQuesBtn = nil;
        
        
    
    }else if (_examOrPractice ==4){//收藏
        markQuesBtn = nil;
        
        
    }
    
    markQuesBtn.titleLabel.font = [UIFont systemFontOfSize:11];//title字体大小
    markQuesBtn.titleLabel.textAlignment = NSTextAlignmentLeft;//设置title的字体居左
    markQuesBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [_scroollView addSubview:markQuesBtn];
    
    divideLineView = [[UIView alloc] initWithFrame:CGRectMake(5, myView.frame.size.height+13+markQuesBtn.frame.size.height+5, CELL_CONTENT_WIDTH-10, 1)];
    divideLineView.backgroundColor = MyBackColor;
    [_scroollView addSubview:divideLineView];

}
#pragma mark 创建答案解析按钮和分割线
-(void)createAnsBtnAndDevideLine:(UIView*)bodyView hasPic:(NSRange)r{
    if (r.location == NSNotFound) {//没有图片
        divideLineView = [[UIView alloc] initWithFrame:CGRectMake(5, bodyView.frame.size.height+labltTitle.frame.size.height+70, CELL_CONTENT_WIDTH-10, 1)];
    }else{
        divideLineView = [[UIView alloc] initWithFrame:CGRectMake(5, bodyView.frame.size.height+MywebView.frame.size.height+70, CELL_CONTENT_WIDTH-10, 1)];
        
    }
    divideLineView.backgroundColor = MyBackColor;
    [_scroollView addSubview:divideLineView];
    
    showMarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showMarkBtn.frame = CGRectMake(CELL_CONTENT_MARGIN, bodyView.frame.size.height+labltTitle.frame.size.height+80, 90, 30);
//    showMarkBtn.tag = 1001;
    
    
    [showMarkBtn setBackgroundImage:[UIImage imageNamed:@"ic_error_ans_hide"] forState:UIControlStateNormal];
    [showMarkBtn setTitle:@"显示答案" forState:UIControlStateNormal];//设置button的title
    [showMarkBtn setImage:[UIImage imageNamed:@"ic_myExam_open"] forState:UIControlStateNormal];
    
    showMarkBtn.titleLabel.font = [UIFont systemFontOfSize:15];//title字体大小
    showMarkBtn.titleLabel.textAlignment = NSTextAlignmentRight;//设置title的字体居左
    [showMarkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
    [showMarkBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [showMarkBtn addTarget:nil action:@selector(showAnswersAndMark:) forControlEvents:UIControlEventTouchUpInside];
    
    [_scroollView addSubview:showMarkBtn];
    
    
    
}
#pragma mark 创建题目title视图
/**
 *  创建题目titil视图
 */
-(void)createQuesTitleView:(NSRange)r{
    if (r.location == NSNotFound) {//没有图片
        [MywebView removeFromSuperview];
        MywebView = nil;
        [self createQuestionTitleLabelView];
        [_scroollView addSubview:labltTitle];
        [self createMarkAndDivideLineView:labltTitle];
        
    }else{//有图片
//        [labltTitle removeFromSuperview];
//        labltTitle = nil;
        //创建网页视图
//        [self createQuestionTitleWebView];
        [MywebView removeFromSuperview];
        MywebView = nil;
        
        NSMutableString* html = [self.childQTitleLable mutableCopy];
        NSRange range=[html rangeOfString:@"src=\"/"];

        while (range.location!=NSNotFound) {
            [html replaceCharactersInRange:range withString:IMGURL];
            range=[html rangeOfString:@"src=\"/"];
        }
        NSMutableArray *titleArr = [[NSMutableArray alloc] init];
        titleArr = [self getImgUrlsFromHtml:html];
        html = [[self filterHTML:html] mutableCopy];
        [self createQuestionTitleYYLabelView:html];
        NSLog(@"-------html--------:%@",html);
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:html];
        text.yy_font = [UIFont systemFontOfSize:16];
        NSRange range1;
        for (int i = 0; i<titleArr.count; i++) {
            range1 = [html rangeOfString:[NSString stringWithFormat:@"图%d",i+1]];
            if (range1.location != NSNotFound) {
                [text yy_setTextHighlightRange:NSMakeRange(range1.location, range1.length)
                                         color:[UIColor orangeColor]
                               backgroundColor:[UIColor whiteColor]
                                     tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range1, CGRect rect){
                                         //显示图片
                                         [self showPopViewWithUrl:[titleArr safe_objectAtIndex:i]];
                                         
                                     }];
                
                
            }
            
        }
        labltTitle.attributedText = text;
//        NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
//        MywebView.userInteractionEnabled = YES;
//        [MywebView loadHTMLString:html baseURL:baseURL];
//        [_scroollView addSubview:MywebView];
        [_scroollView addSubview:labltTitle];
        [self createMarkAndDivideLineView:labltTitle];
    }

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
    [self.view addSubview: backView];
    
    //    [UIView animateWithDuration:.5f animations:^{
    //        [backView  layoutIfNeeded];
    //    }];
    
}

-(void)dismissWithAnimated:(BOOL)animated withBg:(UIButton *)sender{
    [sender.superview removeFromSuperview];

}
-(void)hideBackView:(UIButton *)sender{
//    [self dismissWithAnimated:YES withBg:sender];
    
    [sender.superview removeFromSuperview];
    NSLog(@"SUCCESS");
}
#pragma mark 创建题目内容视图
/**
 *  1、多选时的界面
 *
 *  @param r 判断是否包含图片
 */
-(void)createQuesCheckContentBodyView:(NSRange)r{
    NSMutableArray *totalArrStr = [[NSMutableArray alloc] init];
//    if (r.location == NSNotFound) {
    if (true) {
       
        NSMutableArray *array = [[NSMutableArray alloc]init];
        NSArray *_arrayStr ;
//        if([self.childQBodyLable rangeOfString:@"p><p>"].location == NSNotFound ){
//            
//            if ([self.childQBodyLable rangeOfString:@"<br/>"].location == NSNotFound ) {
//                _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"<BR/>"];
//                if ([self.childQBodyLable rangeOfString:@"<br />"].location == NSNotFound) {
//                    
//                }else{
//                    _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"<br />"];
//                }
//            }else{
//                _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"<br/>"];
//            }
//        }else{
//            _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"<\/p><p>"];
//        }
        
        
        if ([self.childQBodyLable rangeOfString:@"B"].location != NSNotFound ) {
            _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"B"];
            [totalArrStr addObject:[_arrayStr safe_objectAtIndex:0]];
            self.childQBodyLable = [_arrayStr safe_objectAtIndex:1];
            if ([self.childQBodyLable rangeOfString:@"C"].location != NSNotFound ) {
                _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"C"];
                [totalArrStr addObject:[_arrayStr safe_objectAtIndex:0]];
                self.childQBodyLable = [_arrayStr safe_objectAtIndex:1];
                if ([self.childQBodyLable rangeOfString:@"D"].location != NSNotFound ) {
                    _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"D"];
                    [totalArrStr addObject:[_arrayStr safe_objectAtIndex:0]];
                    self.childQBodyLable = [_arrayStr safe_objectAtIndex:1];
                    if ([self.childQBodyLable rangeOfString:@"E"].location != NSNotFound ) {
                        _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"E"];
                        [totalArrStr addObject:[_arrayStr safe_objectAtIndex:0]];
                        self.childQBodyLable = [_arrayStr safe_objectAtIndex:1];
                        if ([self.childQBodyLable rangeOfString:@"F"].location != NSNotFound ){
                            _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"F"];
                            [totalArrStr addObject:[_arrayStr safe_objectAtIndex:0]];
                            self.childQBodyLable = [_arrayStr safe_objectAtIndex:1];
                            if ([self.childQBodyLable rangeOfString:@"G"].location != NSNotFound ){
                                _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"G"];
                                [totalArrStr addObject:[_arrayStr safe_objectAtIndex:0]];
                                self.childQBodyLable = [_arrayStr safe_objectAtIndex:1];
                                
                            }else{
                                [totalArrStr addObject:[_arrayStr safe_objectAtIndex:1]];
                            }
                            
                        }else{
                            [totalArrStr addObject:[_arrayStr safe_objectAtIndex:1]];
                        }
                    }else{
                        [totalArrStr addObject:[_arrayStr safe_objectAtIndex:1]];
                    }
                }else{
                    [totalArrStr addObject:[_arrayStr safe_objectAtIndex:1]];
                }
            }else{
                [totalArrStr addObject:[_arrayStr safe_objectAtIndex:1]];
            }
            
        }
//        NSLog(@"---------totalArrStr:%@",totalArrStr);
        
        NSMutableArray *selectNumbers = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K", nil];
        for (int i = 0; i<[totalArrStr count]; i++) {
            NSString* s = [totalArrStr objectAtIndex:i];
            
            s = [s stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
            s = [s stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
            s = [s stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
            NSString* getChar = s;
            NSRange rang = [s rangeOfString:@"src"];
            
            NSString *firstStr = [getChar substringToIndex:1];
            if([selectNumbers containsObject:firstStr]){
                s = [s substringFromIndex:2];
            }else{
                s = [s substringFromIndex:1];
            }
            
            
            TNImageCheckBoxData *womanData = [[TNImageCheckBoxData alloc] init];
            if (rang.location == NSNotFound) {
                womanData.HavePic = @"haveNo";
                womanData.labelText = s;
            }else{
                NSMutableString* html = [s mutableCopy];
                NSRange range=[html rangeOfString:@"src=\"/"];
                while (range.location!=NSNotFound) {
                    [html replaceCharactersInRange:range withString:IMGURL];
                    range=[html rangeOfString:@"src=\"/"];
                }
                
                womanData.picUrls = [self getImgUrlsFromHtml:html];
                womanData.HavePic = @"have";
                
                html = [[self filterHTML:html] mutableCopy];
                
                NSLog(@"---------获得的数据:\n%@",html);
                womanData.labelText = html;
                
//                womanData.HavePic = @"have";
//                NSLog(@"html:%@",html);
//                womanData.labelText = html;
                
            }
            womanData.identifier = [NSString stringWithFormat:@"%d",i];
            womanData.checkItemStr = selectNumbers[i];
            womanData.checkedImage = [UIImage imageNamed:@"check_selected_btn_bg"];
            womanData.uncheckedImage = [UIImage imageNamed:@"check_unselected_btn_bg"];
            if (self.childHistoryAnswer.length!=0&&[self.childHistoryAnswer rangeOfString:[selectNumbers objectAtIndex:i]].location!=NSNotFound) {
                womanData.checked = YES;
            }
            [array addObject:womanData];
        }
        
        self.loveGroup = [[TNCheckBoxGroup alloc] initWithCheckBoxData:array style:TNCheckBoxLayoutVertical];
        [self.loveGroup create];
        if (r.location == NSNotFound) {
            self.loveGroup.position = CGPointMake(0, CGRectGetMaxY(labltTitle.frame)+markQuesBtn.frame.size.height+divideLineView.frame.size.height+38);
        }else{
            self.loveGroup.position = CGPointMake(0, CGRectGetMaxY(labltTitle.frame)+markQuesBtn.frame.size.height+divideLineView.frame.size.height+38);
        }
    }
    [_scroollView addSubview:self.loveGroup];
    [self.view addSubview:_scroollView];
}

/**
 *  2、单选时的界面
 *
 *  @param r 判断是否包含图片
 */

-(void)createQuesRadioContentBodyView:(NSRange)bodyRange{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSMutableArray *totalArrStr = [[NSMutableArray alloc] init];
    NSArray *_arrayStr;
    
   
    if ([self.childQTypeLable intValue] == 1) {
            //        把字符串截断存到数组
//            if([self.childQBodyLable rangeOfString:@"<BR />"].location == NSNotFound ){
//                if([self.childQBodyLable rangeOfString:@"<br />"].location == NSNotFound ){
//                    _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"<\/p><p>"];
//                    
//                }else{
//                    _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"<br />"];
//                }
//            }else{
//                _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"<BR />"];
//            }
        
        if ([self.childQBodyLable rangeOfString:@"B"].location != NSNotFound ) {
            _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"B"];
            [totalArrStr addObject:[_arrayStr safe_objectAtIndex:0]];
            self.childQBodyLable = [_arrayStr safe_objectAtIndex:1];
            if ([self.childQBodyLable rangeOfString:@"C"].location != NSNotFound ) {
                _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"C"];
                [totalArrStr addObject:[_arrayStr safe_objectAtIndex:0]];
                self.childQBodyLable = [_arrayStr safe_objectAtIndex:1];
                if ([self.childQBodyLable rangeOfString:@"D"].location != NSNotFound ) {
                    _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"D"];
                    [totalArrStr addObject:[_arrayStr safe_objectAtIndex:0]];
                    self.childQBodyLable = [_arrayStr safe_objectAtIndex:1];
                    if ([self.childQBodyLable rangeOfString:@"E"].location != NSNotFound ) {
                        _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"E"];
                        [totalArrStr addObject:[_arrayStr safe_objectAtIndex:0]];
                        self.childQBodyLable = [_arrayStr safe_objectAtIndex:1];
                        if ([self.childQBodyLable rangeOfString:@"F"].location != NSNotFound ){
                            _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"F"];
                            [totalArrStr addObject:[_arrayStr safe_objectAtIndex:0]];
                            self.childQBodyLable = [_arrayStr safe_objectAtIndex:1];
                            if ([self.childQBodyLable rangeOfString:@"G"].location != NSNotFound ){
                                _arrayStr = [self.childQBodyLable componentsSeparatedByString:@"G"];
                                [totalArrStr addObject:[_arrayStr safe_objectAtIndex:0]];
                                self.childQBodyLable = [_arrayStr safe_objectAtIndex:1];
                                
                            }else{
                                [totalArrStr addObject:[_arrayStr safe_objectAtIndex:1]];
                            }
                            
                        }else{
                            [totalArrStr addObject:[_arrayStr safe_objectAtIndex:1]];
                        }
                    }else{
                        [totalArrStr addObject:[_arrayStr safe_objectAtIndex:1]];
                    }
                }else{
                    [totalArrStr addObject:[_arrayStr safe_objectAtIndex:1]];
                }
            }else{
                [totalArrStr addObject:[_arrayStr safe_objectAtIndex:1]];
            }
            
        }
        
        
        NSLog(@"---------totalArrStr:%@",totalArrStr);
        
            NSMutableArray *selectNumbers = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K", nil];
            
            for (int i = 0; i<[totalArrStr count]; i++) {
                NSString* s = [totalArrStr objectAtIndex:i];
                
                s = [s stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
                s = [s stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
                s = [s stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
                NSString* getChar = s;
                NSRange rang = [s rangeOfString:@"src"];

                NSString *firstStr = [getChar substringToIndex:1];
                if([selectNumbers containsObject:firstStr]){
                    s = [s substringFromIndex:2];
                }else{
                    s = [s substringFromIndex:1];
                }
                TNImageRadioButtonData *coldData = [TNImageRadioButtonData new];
                if (rang.location == NSNotFound) {
                    coldData.HavePic = @"haveNo";
                    coldData.labelText = s;
                }else{
                    NSMutableString* html = [s mutableCopy];
                    
                    NSRange range=[html rangeOfString:@"src=\"/"];
                    while (range.location!=NSNotFound) {
                        [html replaceCharactersInRange:range withString:IMGURL];
                        range=[html rangeOfString:@"src=\"/"];
                    }
                    coldData.picUrls = [self getImgUrlsFromHtml:html];
                    coldData.HavePic = @"have";
                    
                    html = [[self filterHTML:html] mutableCopy];
                    
                    NSLog(@"---------获得的数据:\n%@",html);
                    coldData.labelText = html;
                }
                coldData.identifier = [NSString stringWithFormat:@"%d",i];
                coldData.checkItemStr = selectNumbers[i];
                coldData.unselectedImage = [UIImage imageNamed:@"radio_unselected_btn_bg"];
                coldData.selectedImage = [UIImage imageNamed:@"radio_selected_btn_bg"];
                if ([self.childHistoryAnswer isEqualToString:[selectNumbers objectAtIndex:i]]) {
                    coldData.selected = YES;
                }else{
                    coldData.selected = NO;
                }
                [array addObject:coldData];
            }
        }
    else{//判断题
            _arrayStr = [[NSArray alloc]initWithObjects:@"正确",@"错误", nil];
            NSMutableArray *selectNumbers = [[NSMutableArray alloc]initWithObjects:@"正确",@"错误", nil];
            for (int i = 0; i<[_arrayStr count]; i++) {
                TNImageRadioButtonData *coldData = [TNImageRadioButtonData new];
                coldData.HavePic = @"haveNo";
                coldData.labelText = [_arrayStr objectAtIndex:i];
                coldData.identifier = [NSString stringWithFormat:@"%d",i];
                coldData.unselectedImage = [UIImage imageNamed:@"radio_unselected_btn_bg"];
                coldData.selectedImage = [UIImage imageNamed:@"radio_selected_btn_bg"];
                if ([self.childHistoryAnswer isEqualToString:[selectNumbers objectAtIndex:i]]) {
                    coldData.selected = YES;
                }else{
                    coldData.selected = NO;
                }
                [array addObject:coldData];
            }
        }
        
    self.temperatureGroup = [[TNRadioButtonGroup alloc] initWithRadioButtonData:array layout:TNRadioButtonGroupLayoutVertical];
    self.temperatureGroup.identifier = @"Temperature group";
    [self.temperatureGroup create];
    NSRange titleRange = [self.childQTitleLable rangeOfString:@"src"];
    if (titleRange.location == NSNotFound) {
        self.temperatureGroup.position = CGPointMake(0, CGRectGetMaxY(labltTitle.frame)+markQuesBtn.frame.size.height+divideLineView.frame.size.height+36);
    }else{
        self.temperatureGroup.position = CGPointMake(0, CGRectGetMaxY(labltTitle.frame)+CGRectGetMaxY(markQuesBtn.frame)+CGRectGetMaxY(divideLineView.frame)+36);
//        self.temperatureGroup.position = CGPointMake(0, 480);
    }
 
    [_scroollView addSubview:self.temperatureGroup];
    
    [self.view addSubview:_scroollView];


}


#pragma mark 创建答案解析视图
-(void)createAnsAndMarkView:(UIView *)myView{
    showMarkView = [[UIView alloc] initWithFrame:CGRectMake(0, myView.frame.size.height+80+labltTitle.frame.size.height+showMarkBtn.frame.size.height, WIDTH, HEIGHT)];
    
    [_scroollView addSubview:showMarkView];
    
    UILabel *quesAnsLabel = [self createMyLabel:8 locationY:5 LabelColor:MyBlue withFont:[UIFont systemFontOfSize:13] AndTextStr:[NSString stringWithFormat:@"正确答案: %@",_childQAnswerLable]];
    
    [showMarkView addSubview:quesAnsLabel];
    //用户答案
    UILabel *userAnsLabel;
    //对比答案给出人工解析
    UILabel *personMarkLabel;
    if(_examOrPractice == 3){
        if(_userAnswerInErr==NULL|| _userAnswerInErr == nil||[_userAnswerInErr isKindOfClass:[NSNull class]]||[_userAnswerInErr isEqualToString:@" "]){
            _userAnswerInErr = @"未答题";
        }
        
        userAnsLabel = [self createMyLabel:8 locationY:5+quesAnsLabel.frame.size.height +5 LabelColor:[UIColor redColor] withFont:[UIFont systemFontOfSize:13] AndTextStr:[NSString stringWithFormat:@"用户答案: %@",_userAnswerInErr]];
        [showMarkView addSubview:userAnsLabel];
        
        
        if([_childQAnswerLable isEqualToString:_userAnswerInErr]){
            personMarkLabel = [self createMyLabel:8 locationY:5+quesAnsLabel.frame.size.height+5 +userAnsLabel.frame.size.height+5 LabelColor:MyNavColor withFont:[UIFont systemFontOfSize:13] AndTextStr:[NSString stringWithFormat:@"人工评卷: 正确   得分:%@",_childQPointLable]];
            
        }else{
            personMarkLabel = [self createMyLabel:8 locationY:5+quesAnsLabel.frame.size.height+5 +userAnsLabel.frame.size.height+5 LabelColor:MyNavColor withFont:[UIFont systemFontOfSize:13] AndTextStr:[NSString stringWithFormat:@"人工评卷: 错误   得分:0"]];
            
        }
        [showMarkView addSubview:personMarkLabel];
    }
    
    //答案解析
    UILabel *examMarkLabel = [self createMyLabel:8 locationY:5+quesAnsLabel.frame.size.height+5 +userAnsLabel.frame.size.height+5+personMarkLabel.frame.size.height LabelColor:[UIColor darkGrayColor] withFont:[UIFont systemFontOfSize:13] AndTextStr:[NSString stringWithFormat:@"试卷解析: %@",_childQMmarkLable]];
    
    [showMarkView addSubview:examMarkLabel];
    
    [_scroollView setContentSize:CGSizeMake(WIDTH,examMarkLabel.frame.size.height+examMarkLabel.frame.origin.y+showMarkView.frame.origin.y+130)];
    
    
}

#pragma mark 删除答案解析视图
-(void)removeShowMarkView{
    [showMarkView removeFromSuperview];
    showMarkView = nil;
}
/**
 *  显示答案和解析
 *
 */

-(void)showAnswersAndMark:(UIButton *)sender{
    _isShowAndMarkQuesFlag = !_isShowAndMarkQuesFlag;
    NSLog(@"Click");
    if (!_isShowAndMarkQuesFlag) {
        [sender setTitle:@"显示答案" forState:UIControlStateNormal];//设置button的title
        [sender setImage:[UIImage imageNamed:@"ic_myExam_open"] forState:UIControlStateNormal];
        [self removeShowMarkView];
    }else{
        [sender setTitle:@"隐藏答案" forState:UIControlStateNormal];//设置button的title
        [sender setImage:[UIImage imageNamed:@"ic_myExam_close"] forState:UIControlStateNormal];
        
        if([_childQTypeLable isEqualToString:@"1"]||[_childQTypeLable isEqualToString:@"3"]){
            [self createAnsAndMarkView:_temperatureGroup];
        }else if([_childQTypeLable isEqualToString:@"2"]){
            [self createAnsAndMarkView:_loveGroup];
        
        }
        
        
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

#pragma mark 收藏题目事件
-(void)userCollectTheQuestion{
    NSLog(@"CollectQuestion");
    _isCollectQuestion = !_isCollectQuestion;
    
    if (!_isCollectQuestion) {
        [markQuesBtn setBackgroundImage:[UIImage imageNamed:@"ic_practice_not_collect_bg"] forState:UIControlStateNormal];
        [markQuesBtn setTitle:@"收藏该题" forState:UIControlStateNormal];
        [markQuesBtn setImage:[UIImage imageNamed:@"ic_practice_not_collect"] forState:UIControlStateNormal];
        [markQuesBtn setTitleColor:MyOrange forState:UIControlStateNormal];//设置title在一般情况下为白色字体
        
        [self deleteDatatableName:TABLECOLLECT :quesDetailModel.ques_id];
        
    }else{
        [markQuesBtn setBackgroundImage:[UIImage imageNamed:@"ic_practice_collected_bg"] forState:UIControlStateNormal];
        [markQuesBtn setTitle:@"已收藏" forState:UIControlStateNormal];
        [markQuesBtn setImage:[UIImage imageNamed:@"ic_practice_collected"] forState:UIControlStateNormal];
        [markQuesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
        
        //把用户收藏的题目情况写入数据库
        [self insertDatatableName:TABLECOLLECT :quesDetailModel.ques_id :quesDetailModel.type_id :quesDetailModel.ques_title :quesDetailModel.ques_body :quesDetailModel.ques_answer :quesDetailModel.ques_mark :@"01":_quesPlanName:quesDetailModel.ModuleUrl];
//        [self insertDatatableName:TABLECOLLECT :quesDetailModel.ques_id :quesDetailModel.type_id :quesDetailModel.ques_title :quesDetailModel.ques_body :quesDetailModel.ques_answer :quesDetailModel.ques_mark :@"01":_quesPlanName:_quesPlanName];
    }
}

#pragma mark - private Action

-(NSString *)filterFillHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    int imgIndex = 1;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
//        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        NSLog(@"要替换的数据:%@",[NSString stringWithFormat:@"%@>",text]);
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:[NSString stringWithFormat:@"<a href=%@> 图%d </a>",[NSString stringWithFormat:@"%@",text],imgIndex]];
        
        imgIndex++;
    }
    NSString * regEx = @"&nbsp;";
    html = [html stringByReplacingOccurrencesOfString:regEx withString:@" "];
    
    NSLog(@"-------------html:%@",html);
    return html;
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:
     @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '250%'"];
//    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"]floatValue];
//    CGFloat width = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth"]floatValue];
//    CGFloat scale=height/width;
//    
//    webView.frame=CGRectMake(0, 0, MywebView.frame.size.width, (MywebView.frame.size.width)*scale);
//    [webView reload];
    CGFloat webViewHeight=[webView.scrollView contentSize].height;
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    webView.frame = newFrame;
    webView.scrollView.scrollEnabled = NO;
    [webView reload];
    [self createMarkAndDivideLineView:MywebView];
    self.temperatureGroup.position = CGPointMake(0, CGRectGetMaxY(MywebView.frame)+markQuesBtn.frame.size.height+divideLineView.frame.size.height+26);
}

- (void)loveGroupChanged:(NSNotification *)notification {
    [saveAnswer removeAllObjects];
    saveAnswer = [[NSMutableArray alloc]init];
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
        }else if ((int)[[result objectAtIndex:i] tag]==5){
            [saveAnswer addObject:@"F"];
        }else if ((int)[[result objectAtIndex:i] tag]==6){
            [saveAnswer addObject:@"G"];
        }else if ((int)[[result objectAtIndex:i] tag]==7){
            [saveAnswer addObject:@"H"];
        }else if ((int)[[result objectAtIndex:i] tag]==8){
            [saveAnswer addObject:@"I"];
        }else if ((int)[[result objectAtIndex:i] tag]==9){
            [saveAnswer addObject:@"J"];
        }else{
            [saveAnswer addObject:@"K"];
        }
    }
    NSString * Str = [NSString stringWithFormat:@""];
    NSArray *sortedArray = [saveAnswer sortedArrayUsingSelector:@selector(compare:)];//重新按照字母进行排序
    for (int  i = 0; i < [sortedArray count] ; i ++ ) {
//        Str  = [Str stringByAppendingString:[sortedArray objectAtIndex:i]];
        
        if (i<[sortedArray count]-1) {
            Str  = [Str stringByAppendingString:[NSString stringWithFormat:@"%@,",[sortedArray objectAtIndex:i]]];
        }else{
            Str  = [Str stringByAppendingString:[sortedArray objectAtIndex:i]];
        }
        
    }
    self.answerUser = Str;
    
    [self.countCheckDelegate userCheckAnserCount];
    DLog(@"--%@",self.answerUser);
    
}


- (void)temperatureGroupUpdated:(NSNotification *)notification {
    int index = [self.temperatureGroup.selectedRadioButton.data.identifier intValue];
    if ([self.childQTypeLable intValue]==1) {//单选
        if (index == 0) {
            self.answerUser = @"A";
        }else if (index == 1) {
            self.answerUser = @"B";
        }else if (index == 2) {
            self.answerUser = @"C";
        }else if (index == 3) {
            self.answerUser = @"D";
        }else if (index == 4) {
            self.answerUser = @"E";
        }else if (index == 5) {
            self.answerUser = @"F";
        }else if (index == 6) {
            self.answerUser = @"G";
        }else if (index == 7) {
            self.answerUser = @"H";
        }else if (index == 8) {
            self.answerUser = @"I";
        }
    }else{//判断
        if (index == 0) {
            self.answerUser = @"正确";
        }else{
            self.answerUser = @"错误";
        }
    }
    
    [self.countRadioDelegate userRadioAnserCount];
    DLog(@"--%@",self.answerUser);
}





- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GROUP_CHANGED object:self.loveGroup];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SELECTED_RADIO_BUTTON_CHANGED object:self.temperatureGroup];

}

-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    int index = 1;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:[NSString stringWithFormat:@"图%d",index]];
        index ++;
    }
    NSString * regEx = @"&nbsp;";
    html = [html stringByReplacingOccurrencesOfString:regEx withString:@" "];
    return html;
}


-(NSMutableArray *)getImgUrlsFromHtml:(NSString *)string{
    NSError *error;
    NSString *regulaStr = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch = [string substringWithRange:match.range];
        
        [urls addObject:substringForMatch];
    }
    NSLog(@"substringForMatch:%@",urls);
    return urls;
}


//持久化考试数据
- (void)createTable:(NSString *)tableName{
    //sql 语句
    if ([tableName isEqualToString:TABLECOLLECT]) {//收藏
        
        if ([db open]) {
            NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' INTEGER,'%@' TEXT, '%@' INTEGER, '%@' TEXT , '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT,'%@' TEXT,'%@' TEXT)",TABLECOLLECT,ID,userID,qId,qType,qTitle,qBody,qAnswer,qMark,qMode,qPlanName,userQAnswer,qModuleUrl];
            
            
            BOOL res = [db executeUpdate:sqlCreateTable];
            if (!res) {
                NSLog(@"error when creating db table");
            } else {
                //                NSLog(@"success to creating db table");
            }
            [db close];
            
        }
        
    }
    
}

/**
 *  查询用户错题是否在数据库中已经存在
 *
 */
-(BOOL)selectDataInDB:(NSString *)tableName withID:(long)qID{
    NSString * sql;
    sql = [NSString stringWithFormat:@"SELECT * FROM %@ where %@ = %ld Order By rowid  DESC",tableName,qId, qID];
    if ([db open]) {
        FMResultSet * resultSet = [db executeQuery:sql];
        @try {
            if ([resultSet next]) {
                return NO;//存在错题
            }else{
                return YES;//数据库不存在这题，可以添加
            }
        } @catch (NSException *exception) {
            @throw exception;
        } @finally {
//            [db close];
        }
        
        
    }else{
        NSLog(@"数据库查询失败！");
        return NO;
    }
    
}

-(void) insertDatatableName:(NSString *)tableName :(long) _qId :(long)_qType :(NSString *)_qTitle :(NSString *)_qBody :(NSString *)_qAnswer :(NSString *)_qMark :(NSString *)_qMode :(NSString *)_qPlanName :(NSString *)quesType{
    
    if ([db open]) {
        if ([self selectDataInDB:tableName withID:_qId]) {
            NSString *insertSql1= [NSString stringWithFormat:
                                   @"INSERT INTO '%@' ('%@', '%@', '%@','%@','%@', '%@', '%@','%@','%@','%@') VALUES ('%@','%ld', '%ld', '%@','%@', '%@', '%@','%@','%@','%@')",TABLECOLLECT, userID,qId, qType, qTitle,qBody,qAnswer,qMark,qMode,qPlanName,qModuleUrl,USERID,_qId, _qType, _qTitle,_qBody, _qAnswer, _qMark,_qMode,_qPlanName,quesType];
            BOOL res = [db executeUpdate:insertSql1];
            if (!res) {
                NSLog(@"error when insert db table");
            } else {
                
            }
        }else{
            NSLog(@"改错题已经收藏过了！");
            
        }
        
        
        [db close];
        
    }

    
    
//    if ([tableName isEqualToString:TABLECOLLECT]) {
//        
//        if ([db open]) {
//            NSString *insertSql1= [NSString stringWithFormat:
//                                   @"INSERT INTO '%@' ('%@', '%@', '%@','%@', '%@', '%@','%@','%@') VALUES ('%ld', '%ld', '%@','%@', '%@', '%@','%@','%@')",TABLECOLLECT, qId, qType, qTitle,qBody,qAnswer,qMark,qMode,qPlanName,_qId, _qType, _qTitle,_qBody, _qAnswer, _qMark,_qMode,_qPlanName];
//            BOOL res = [db executeUpdate:insertSql1];
//            if (!res) {
//                NSLog(@"error when insert db table");
//            } else {
//                //                NSLog(@"success to insert db table");
//            }
//            [db close];
//            
//        }
//        
//        
//    }
    
    
}


/**
 *  删除数据库内容
 */
-(void) deleteDatatableName:(NSString *)tableName :(long)_qId {
    if([tableName isEqualToString:TABLECOLLECT]){
        if ([db open]) {
            NSString *deleteSql;
            if (_qId==0) {
                deleteSql = [NSString stringWithFormat:
                             @"delete  from %@ ",TABLECOLLECT ];
            }else{
                deleteSql = [NSString stringWithFormat:
                             @"delete from %@ where %@ = %ld",
                             TABLECOLLECT, qId, _qId];
            }
            BOOL res = [db executeUpdate:deleteSql];
            
            if (!res) {
                NSLog(@"error when delete db table");
            } else {
                NSLog(@"success to delete db table");
            }
            [db close];
            
        }
    }
    
    
}

@end
