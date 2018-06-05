//
//  FillBlankViewController.m
//  TimberExam
//
//  Created by Mac on 15/9/16.
//  Copyright (c) 2015年 timber. All rights reserved.
//

#import "FillBlankViewController.h"
#import "AnswerTextFieldsCell.h"

#define CELL_CONTENT_WIDTH [[UIScreen mainScreen] bounds].size.width
#define IMGURL @"src=\"http://p1j4894351.51mypc.cn:11919/"
#define MARGIN 10
#define FONT_SIZE 16.0f
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define CELL_CONTENT_WIDTH [[UIScreen mainScreen] bounds].size.width
#define CELL_CONTENT_MARGIN 10.0f

#define ID        @"id"
@interface FillBlankViewController ()<UITextFieldDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    UILabel * labltTitle;

    
    UIScrollView * scollView;
    
//    UITextField * textFiled;
    UITextView * textUView;
    UITableView *textFieldTV;
    
    NSMutableArray *userAnswersArr;
    
    UIWebView* MywebView;
    UIScrollView * scrView;
    
    FMDatabase *db;
    NSString *database_path;//数据库路径
    
    int textFieldNum;
    BOOL _wasKeyboardManagerEnabled;
}

@end

@implementation FillBlankViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self creatUserAnswerView];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    db = [FMDatabase databaseWithPath:database_path];
    [self createTable:TABLECOLLECT];
    
   
    
    _isCollectQuestion = ![self selectDataInDB:TABLECOLLECT withID:quesDetailModel.ques_id];
    
    [self creatTitleView];
    
}
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
//    [[IQKeyboardManager sharedManager] setEnable:NO];
//}
//-(void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (id)initWithFrame:(CGRect)frame :(NSString *)title1 :(NSString *)title2 :(NSString *)title3 :(NSString *)title4 :(NSString *)title5 :(NSString *)title6 :(NSString *)title7 :(Boolean)isShowAnswer :(NSString *)isShow{
    self.childQTitleLable = title1;
    self.childQTypeLable = title2;
    self.childQIdLable = title3;
    self.childQPointLable = title4;
    self.childQAnswerLable = title5;
    self.childQBodyLable = title6;
    self.childQMmarkLable = title7;
    self.isShow = isShow;
    _isShowAnswer = isShowAnswer;
    //以后增加字段
    _isMarkQuestion = false;

    return self;
}


- (id)initWithFrame:(CGRect)frame :(NSString *)title1 :(NSString *)title2 :(NSString *)title3 :(NSString *)title4 :(NSString *)title5 :(NSString *)title6 :(NSString *)title7 :(Boolean)isShowAnswer :(NSString *)isShow examOrPractice:(long)examFlag inPaper:(NSString *)planName{
    self.childQTitleLable = title1;
    self.childQTypeLable = title2;
    self.childQIdLable = title3;
    self.childQPointLable = title4;
    self.childQAnswerLable = title5;
    self.childQBodyLable = title6;
    self.childQMmarkLable = title7;
    self.isShow = isShow;
    
    _isShowAnswer = isShowAnswer;
    _examOrPractice = examFlag;
    _quesPlanName = planName;
    //以后增加字段
    _isMarkQuestion = false;
    return self;
}
- (id)initWithFrame:(CGRect)frame :(NSString *)title1 :(NSString *)title2 :(NSString *)title3 :(NSString *)title4 :(NSString *)title5 :(NSString *)title6 :(NSString *)title7 :(Boolean)isShowAnswer :(NSString *)isShow :(NSString *)title8 {
    self.childQTitleLable = title1;
    self.childQTypeLable = title2;
    self.childQIdLable = title3;
    self.childQPointLable = title4;
    self.childQAnswerLable = title5;
    self.childQBodyLable = title6;
    self.childQMmarkLable = title7;
    self.childHistoryAnswer = title8;
    self.isShow = isShow;

    _isShowAnswer = isShowAnswer;
    //以后增加字段
    _isMarkQuestion = false;
    return self;
}


- (id)initWithFrame:(CGRect)frame questitle:(NSString*)quesTitle examInfo:(ExamQuestionModel*)examinfo isShowAnswer:(BOOL)ShowAnswer examOrPractice:(long)examFlag inPaper:(NSString *)planName{
//    str = @"显示答案和解析";
    //    self.childQTitleLable = [examinfo objectForKey:@"QTitle"];
    quesDetailModel = examinfo;
    
    self.childQTitleLable = quesTitle;
    self.childQTypeLable = [NSString stringWithFormat:@"%ld",examinfo.type_id];
    self.childQIdLable = [NSString stringWithFormat:@"%ld",examinfo.ques_id];
    self.childQPointLable = examinfo.ques_point;
    self.childQAnswerLable = examinfo.ques_answer;
    self.childQBodyLable = examinfo.ques_body;
    self.childQMmarkLable = examinfo.ques_mark;
    
    _examOrPractice = examFlag;
    _isShowAnswer = ShowAnswer;

    _quesPlanName = planName;
    //以后增加字段
    _isMarkQuestion = false;
    return self;
}
//错题，收藏
-(id)initWithFrame:(CGRect)frame questitle:(NSString*)quesTitle QBody:(NSString *)quesBody Qmark:(NSString *)quesMark QAnswer:(NSString *)quesAnswer UserAnswer:(NSString *)userAsnser QType:(long)quesType Qid:(long)quesId PlanName:(NSString *)planName examOrPractice:(long)examFlag isShowAnswer:(BOOL)isShow{
    self.childQTitleLable = quesTitle;
    
    //用于标识 题目类型:单选，多选，简答
    self.childQTypeLable = [NSString stringWithFormat:@"%ld",quesType];
    self.childQIdLable = [NSString stringWithFormat:@"%ld",quesId];
    //    self.childQPointLable = examinfo.ques_point;
    self.childQAnswerLable = quesAnswer;
    self.childQBodyLable = quesBody;
    self.childQMmarkLable = quesMark;
    _answerUser = userAsnser;
    _examOrPractice = examFlag;
    _isShowAnswer = isShow;
    return self;
}


//创建试题头区域
- (void)creatTitleView{
    
    scollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH,HEIGHT-64-44)];
    NSRange r = [self.childQTitleLable rangeOfString:@"src"];
    [self.view addSubview:scollView];
    
    [self createQuestionTitleLabelView];

    if (r.location == NSNotFound) {//没有图片
        [MywebView removeFromSuperview];
        MywebView = nil;
        [scollView addSubview:labltTitle];
        
        [self createMarkAndDivideLineView:labltTitle];
    }else{//有图片
        [labltTitle removeFromSuperview];
        labltTitle = nil;
        [self createQuestionTitleWebView];
        
        NSMutableString* html = [self.childQTitleLable mutableCopy];
        NSRange range=[html rangeOfString:@"src=\"/"];
        while (range.location!=NSNotFound) {
            [html replaceCharactersInRange:range withString:IMGURL];
            range=[html rangeOfString:@"src=\"/"];
        }
        NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
        [MywebView loadHTMLString:html baseURL:baseURL];
        [scollView addSubview:MywebView];
        
        [self createMarkAndDivideLineView:MywebView];
    }
    if (r.location == NSNotFound) {
        [self creatUserAnswerView];
    }
}



#pragma mark 创建题目视图(label)
-(void)createQuestionTitleLabelView{
    
    
    labltTitle =[[UILabel alloc]init];
    labltTitle.lineBreakMode = NSLineBreakByWordWrapping;
    labltTitle.numberOfLines = 0;
    labltTitle.font = [UIFont systemFontOfSize:16];
    [labltTitle setNumberOfLines:0];
    [labltTitle setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    if ([self.childQTypeLable isEqualToString:@"4"]) {
        [labltTitle setText:[self filterHTML:self.childQTitleLable]];
    }else{
        [labltTitle setText:[self filterFillHTML:self.childQTitleLable]];
    }
    
    
    [labltTitle setFrame:CGRectMake(12, 0, WIDTH -24, MAX(44.0f,[self getTitleHight:self.childQTitleLable]))];
    labltTitle.backgroundColor = WhiteColor;
    
}
#pragma mark 创建题目视图(webView)
-(void)createQuestionTitleWebView{
    MywebView = [[UIWebView alloc]initWithFrame:CGRectMake(MARGIN, MARGIN, WIDTH - (MARGIN * 2), 60)];
    MywebView.dataDetectorTypes = UIDataDetectorTypeAll;
    MywebView.delegate = self;
    MywebView.scalesPageToFit=YES;
}
#pragma mark 创建标记按钮和分割线
-(void)createMarkAndDivideLineView:(UIView *)myView{
    markQuesBtn = [[UIButton alloc] initWithFrame:CGRectMake(CELL_CONTENT_WIDTH - 70, myView.frame.size.height+3, 65, 24)];
    [scollView setContentSize:CGSizeMake(WIDTH, HEIGHT*1.1)];
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
    
    }else if (_examOrPractice == 2){
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
    [scollView addSubview:markQuesBtn];
    
    
    divideLineView = [[UIView alloc] initWithFrame:CGRectMake(5, myView.frame.size.height+3+markQuesBtn.frame.size.height+5, CELL_CONTENT_WIDTH-10, 1)];
    divideLineView.backgroundColor = MyBackColor;
    [scollView addSubview:divideLineView];
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

//创建用户答题区域
- (void)creatUserAnswerView{
     NSRange r = [self.childQTitleLable rangeOfString:@"src"];
    if([self.childQTypeLable intValue]==4){//填空
//        textFiled = [[UITextField alloc]init];
        textFieldTV = [[UITableView alloc] init];
        if (r.location == NSNotFound) {//没有图片
//            textFiled.frame = CGRectMake(MARGIN/2, labltTitle.frame.size.height+markQuesBtn.frame.size.height+divideLineView.frame.size.height+MARGIN*2, WIDTH-MARGIN*2, 44);
            textFieldTV.frame = CGRectMake(MARGIN/2, labltTitle.frame.size.height+markQuesBtn.frame.size.height+divideLineView.frame.size.height+MARGIN*2, WIDTH-MARGIN*2, HEIGHT);
            
        }else{
//            textFiled.frame = CGRectMake(MARGIN/2, MywebView.frame.size.height+markQuesBtn.frame.size.height+divideLineView.frame.size.height+MARGIN*2, WIDTH-MARGIN*2, 44);
            
            textFieldTV.frame = CGRectMake(MARGIN/2, MywebView.frame.size.height+markQuesBtn.frame.size.height+divideLineView.frame.size.height+MARGIN*2, WIDTH-MARGIN*2, HEIGHT);
        }
        
        textFieldTV.dataSource = self;
        textFieldTV.delegate = self;
        textFieldTV.separatorStyle = UITableViewCellSeparatorStyleNone;
        textFieldTV.scrollEnabled = YES;
        textFieldTV.backgroundColor = WhiteColor;
        [scollView addSubview:textFieldTV];
//以下代码为有用代码
//        [textFiled.layer setBorderColor:[UIColor lightGrayColor].CGColor];
//        [textFiled.layer setBorderWidth:1];
//        [textFiled.layer setMasksToBounds:YES];
//        textFiled.layer.cornerRadius = 15.0;
//        textFiled.placeholder = @"请在此区域内填写您的答案！";
//        if ([self.childHistoryAnswer isEqualToString:@""]||[self.childHistoryAnswer isEqualToString:@"-"]) {
//            textFiled.placeholder = @"请在此区域内填写您的答案！";
//        }else{
//            textFiled.text = self.childHistoryAnswer;
//            NSString *ansUserStr = [textFiled.text  stringByReplacingOccurrencesOfString:@" " withString:@""];
//            _answerUser = [ansUserStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        }
//
//        textFiled.delegate = self;
//        [scollView addSubview:textFiled];
        
    }else if([self.childQTypeLable intValue]==5||[self.childQTypeLable intValue]==26||[self.childQTypeLable intValue]==37){//简答
        textUView = [[UITextView alloc]init];
        if (r.location == NSNotFound) {
            if (HEIGHT<500) {
                textUView.frame = CGRectMake(MARGIN, labltTitle.frame.size.height+markQuesBtn.frame.size.height+divideLineView.frame.size.height+MARGIN*2, WIDTH-MARGIN*2, 150);
            }else{
                textUView.frame = CGRectMake(MARGIN, labltTitle.frame.size.height+markQuesBtn.frame.size.height+divideLineView.frame.size.height+MARGIN*2, WIDTH-MARGIN*2, 200);
            }
        }else{
            if (HEIGHT<500) {
                textUView.frame = CGRectMake(MARGIN, MywebView.frame.size.height+markQuesBtn.frame.size.height+divideLineView.frame.size.height+MARGIN*2, WIDTH-MARGIN*2, 150);
            }else{
                textUView.frame = CGRectMake(MARGIN, MywebView.frame.size.height+markQuesBtn.frame.size.height+divideLineView.frame.size.height+MARGIN*2, WIDTH-MARGIN*2, 200);
            }
        }
        
//        textUView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        [textUView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [textUView.layer setBorderWidth:1];
        [textUView.layer setMasksToBounds:YES];
        textUView.layer.cornerRadius = 15.0;
        
        if ([self.childHistoryAnswer isEqualToString:@""]||[self.childHistoryAnswer isEqualToString:@"-"]) {//无答题纪录
//            textUView.text = @"请在此区域内填写您的答案!";
        }else{//有答案
            textUView.text = self.childHistoryAnswer;
        }
        
        textUView.delegate = self;
        [scollView addSubview:textUView];
        
    }
    if (_isShowAnswer ==YES) {
        
        [self createAnsBtnAndDevideLine];//显示答案区域视图
     
    }
    
}
#pragma mark 创建答案解析按钮和分割线
-(void)createAnsBtnAndDevideLine{
    showMarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if([self.childQTypeLable intValue]==5){
        divideLineView = [[UIView alloc] initWithFrame:CGRectMake(5, textUView.frame.size.height+labltTitle.frame.size.height+70, CELL_CONTENT_WIDTH-10, 1)];
        showMarkBtn.frame = CGRectMake(CELL_CONTENT_MARGIN, textUView.frame.size.height+labltTitle.frame.size.height+80, 90, 30);
    
    }else if([self.childQTypeLable intValue]==4){
//        divideLineView = [[UIView alloc] initWithFrame:CGRectMake(5, textFiled.frame.size.height+labltTitle.frame.size.height+70, CELL_CONTENT_WIDTH-10, 1)];
//         showMarkBtn.frame = CGRectMake(CELL_CONTENT_MARGIN, textFiled.frame.size.height+labltTitle.frame.size.height+80, 90, 30);
        divideLineView = [[UIView alloc] initWithFrame:CGRectMake(5,  60*textFieldNum+5+labltTitle.frame.size.height+70, CELL_CONTENT_WIDTH-10, 1)];
        showMarkBtn.frame = CGRectMake(CELL_CONTENT_MARGIN, 60*textFieldNum+5+labltTitle.frame.size.height+80, 90, 30);
    
        
    }
    
    
    divideLineView.backgroundColor = MyBackColor;
    [scollView addSubview:divideLineView];
    
    
    [showMarkBtn setBackgroundImage:[UIImage imageNamed:@"ic_error_ans_hide"] forState:UIControlStateNormal];
    [showMarkBtn setTitle:@"显示答案" forState:UIControlStateNormal];//设置button的title
    [showMarkBtn setImage:[UIImage imageNamed:@"ic_myExam_open"] forState:UIControlStateNormal];
    
    showMarkBtn.titleLabel.font = [UIFont systemFontOfSize:15];//title字体大小
    showMarkBtn.titleLabel.textAlignment = NSTextAlignmentRight;//设置title的字体居左
    [showMarkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
    [showMarkBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [showMarkBtn addTarget:nil action:@selector(showAnswersAndMark:) forControlEvents:UIControlEventTouchUpInside];
    
    [scollView addSubview:showMarkBtn];
    
    
    
    
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
/**
 *  显示答案和解析
 *
 *  showAnswersAndMark
 */

-(void)showAnswersAndMark:(UIButton *)sender{
    _isShowAndMarkQuesFlag = !_isShowAndMarkQuesFlag;
    NSLog(@"Click");
    if (!_isShowAndMarkQuesFlag) {
        [sender setTitle:@"显示答案" forState:UIControlStateNormal];//设置button的title
        [sender setImage:[UIImage imageNamed:@"ic_myExam_open"] forState:UIControlStateNormal];
        //        showMarkView.hidden = YES;
        [self removeShowMarkView];
    }else{
        [sender setTitle:@"隐藏答案" forState:UIControlStateNormal];//设置button的title
        [sender setImage:[UIImage imageNamed:@"ic_myExam_close"] forState:UIControlStateNormal];
        //        showMarkView.hidden = NO;
        [self createAnsAndMarkView];
    }
    
    
    
}
#pragma mark 创建答案解析视图
-(void)createAnsAndMarkView{
    NSRange r = [self.childQTitleLable rangeOfString:@"src"];
    if (r.location == NSNotFound) {//没有图片
        if([self.childQTypeLable intValue]==5){
            showMarkView = [[UIView alloc] initWithFrame:CGRectMake(0, textUView.frame.size.height+80+labltTitle.frame.size.height+showMarkBtn.frame.size.height, WIDTH, HEIGHT)];
            
        }else if([self.childQTypeLable intValue]==4){
            showMarkView = [[UIView alloc] initWithFrame:CGRectMake(0, 60*textFieldNum+5+80+labltTitle.frame.size.height+showMarkBtn.frame.size.height, WIDTH, HEIGHT)];
            
        }
    }else{
        if([self.childQTypeLable intValue]==5){
            showMarkView = [[UIView alloc] initWithFrame:CGRectMake(0, textUView.frame.size.height+80+MywebView.frame.size.height+showMarkBtn.frame.size.height, WIDTH, HEIGHT)];
            
        }else if([self.childQTypeLable intValue]==4){
            showMarkView = [[UIView alloc] initWithFrame:CGRectMake(0,60*textFieldNum+5+80+MywebView.frame.size.height+showMarkBtn.frame.size.height, WIDTH, HEIGHT)];
            
        }
    
    }
    
    [scollView addSubview:showMarkView];
    
    UILabel *quesAnsLabel = [self createMyLabel:5 locationY:5 LabelColor:MyBlue withFont:[UIFont systemFontOfSize:13] AndTextStr:[NSString stringWithFormat:@"正确答案: %@",_childQAnswerLable]];
    
    [showMarkView addSubview:quesAnsLabel];
    
    //用户答案
    UILabel *userAnsLabel;
    UILabel *personMarkLabel;
    if(_examOrPractice == 3){
        
        if(_answerUser==NULL|| _answerUser == nil||[_answerUser isKindOfClass:[NSNull class]]||[_answerUser isEqualToString:@" "]){
            _answerUser = @"未答题";
        }
        
        userAnsLabel = [self createMyLabel:5 locationY:5+quesAnsLabel.frame.size.height +5 LabelColor:[UIColor redColor] withFont:[UIFont systemFontOfSize:13] AndTextStr:[NSString stringWithFormat:@"用户答案: %@",_answerUser]];
        [showMarkView addSubview:userAnsLabel];
        //对比答案给出人工解析
        
        NSLog(@"_childQAnswerLable:%@",_childQAnswerLable);
        NSLog(@"_answerUser:%@",_answerUser);
        if([_childQAnswerLable isEqualToString:_answerUser]){
            personMarkLabel = [self createMyLabel:5 locationY:5+quesAnsLabel.frame.size.height+5 +userAnsLabel.frame.size.height+5 LabelColor:MyNavColor withFont:[UIFont systemFontOfSize:13] AndTextStr:[NSString stringWithFormat:@"人工评卷: 正确   得分:%@",_childQPointLable]];
        }else{
            personMarkLabel = [self createMyLabel:5 locationY:5+quesAnsLabel.frame.size.height+5 +userAnsLabel.frame.size.height+5 LabelColor:MyNavColor withFont:[UIFont systemFontOfSize:13] AndTextStr:[NSString stringWithFormat:@"人工评卷: 错误   得分:0"]];
        }
        [showMarkView addSubview:personMarkLabel];
    
    }
        
    //答案解析
    UILabel *examMarkLabel = [self createMyLabel:5 locationY:5+quesAnsLabel.frame.size.height+5 +userAnsLabel.frame.size.height+5+personMarkLabel.frame.size.height LabelColor:[UIColor darkGrayColor] withFont:[UIFont systemFontOfSize:13] AndTextStr:[NSString stringWithFormat:@"试卷解析: %@",_childQMmarkLable]];
    [showMarkView addSubview:examMarkLabel];
    
    [scollView setContentSize:CGSizeMake(WIDTH,examMarkLabel.frame.size.height+examMarkLabel.frame.origin.y+showMarkView.frame.origin.y+130)];
    
}

#pragma mark 删除答案解析视图
-(void)removeShowMarkView{
    [showMarkView removeFromSuperview];
    showMarkView = nil;
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
        [self insertDatatableName:TABLECOLLECT :quesDetailModel.ques_id :quesDetailModel.type_id :quesDetailModel.ques_title :quesDetailModel.ques_body :quesDetailModel.ques_answer :quesDetailModel.ques_mark :@"01":_quesPlanName];
        
    }
}


#pragma mark UITextFieldDelegate
//开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.delegate userAnserCount];
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self.delegate userAnserCount];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    //拼接答案
    
//    NSString *ansString = textField.text;
//    _answerUser = [ansString  stringByReplacingOccurrencesOfString:@" " withString:@""];
    for (int i = 0; i<textFieldNum; i++) {
        if(textField.tag == 1000+i){
            NSString *ansString = textField.text;
//            _answerUser
            userAnswersArr[i] = ansString;
        }
    }
    NSLog(@"--------------------userAnswersArr:%@",userAnswersArr);
    
    _answerUser = @"";
    for (int i = 0; i<userAnswersArr.count; i++) {
        if (i<userAnswersArr.count-1) {
            _answerUser = [_answerUser stringByAppendingString:[NSString stringWithFormat:@"%@^",userAnswersArr[i]]];
            
        }else{
            _answerUser = [_answerUser stringByAppendingString:[NSString stringWithFormat:@"%@",userAnswersArr[i]]];
        }
        
    }
    
    NSLog(@"---------------answerUser:%@",_answerUser);
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSString *ansString = textView.text;
    NSString *ansUserStr = [ansString  stringByReplacingOccurrencesOfString:@" " withString:@""];
    _answerUser = [ansUserStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}
//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }

    return YES;
}

////当用户按下return键或者按回车键，keyboard消失
//-(BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [textUView resignFirstResponder];
//}

//得到相匹配的的视图高度
-(int)getTitleHight:(NSString *)titleInfo
{
    CGSize constraint = CGSizeMake(WIDTH - (MARGIN * 2), 20000.0f);
   CGRect size = [titleInfo boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]} context:nil];
    
    CGFloat height = MAX(size.size.height, 44.0f);
    return height + (MARGIN * 2);
}
/**
 *  <#Description#>
 *
 *  @param label <#label description#>
 */

-(UILabel *)createMyLabel:(CGFloat)labelLoactionX locationY:(CGFloat)labelLoactionY LabelColor:(UIColor*)labelColor withFont:(UIFont *)font AndTextStr:(NSString *)labelTextStr{
    UILabel *modelLabel = [[UILabel alloc]init];
    
    modelLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGRect size = [labelTextStr boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    [modelLabel setNumberOfLines:0];
    [modelLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    [modelLabel setText:labelTextStr];
    [modelLabel setFrame:CGRectMake(labelLoactionX, labelLoactionY, CELL_CONTENT_WIDTH-10 , MAX(size.size.height, 44.0f))];
    //    [modelLabel setFrame:labelFrame];
    modelLabel.backgroundColor = WhiteColor;
    modelLabel.textColor = labelColor;
    return modelLabel;
    
}


-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    textFieldNum = -1;

    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"(" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@")" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@)",text] withString:@"_______________"];
        textFieldNum++;
    }
    
    
    userAnswersArr = [[NSMutableArray alloc] initWithCapacity:textFieldNum];
    for (int i =0; i<textFieldNum; i++) {
        userAnswersArr[i] = @"";
    }
    
    
    NSString * regEx = @"&nbsp;";
    html = [html stringByReplacingOccurrencesOfString:regEx withString:@" "];
    return html;
}

-(NSString *)filterFillHTML:(NSString *)html
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

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return textFieldNum;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static    NSString * cellString = @"NewsCell";
    AnswerTextFieldsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    if (!cell) {
        NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"AnswerTextFieldsCell" owner:self options:nil];
        cell = [nibViews objectAtIndex:0];
    }
    cell.answerIndex.text = [NSString stringWithFormat:@"%ld、",indexPath.row+1];
    cell.answerContentTF.tag = indexPath.row+1000;
    cell.answerContentTF.delegate = self;
    return cell;
    
    
}


#pragma mark dataBase操作
//持久化考试数据
- (void)createTable:(NSString *)tableName{
    //sql 语句
    if ([tableName isEqualToString:TABLECOLLECT]) {//收藏
        
        if ([db open]) {
//            NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT,'%@' INTEGER, '%@' INTEGER, '%@' TEXT , '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT,'%@' TEXT)",TABLECOLLECT,ID,userID,qId,qType,qTitle,qBody,qAnswer,qMark,qMode,qPlanName,userQAnswer];
            NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' INTEGER,'%@' TEXT, '%@' INTEGER, '%@' TEXT , '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT,'%@' TEXT,'%@' TEXT)",TABLECOLLECT,ID,userID,qId,qType,qTitle,qBody,qAnswer,qMark,qMode,qPlanName,userQAnswer,qModuleUrl];
            
            //            NSString * sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ()"]
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
    sql = [NSString stringWithFormat:@"SELECT * FROM %@ where %@ = %ld Order By rowid ",tableName,qId, qID];
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
//           [db close];
        }
        
        
    }else{
        NSLog(@"数据库查询失败！");
        return NO;
    }
    
}

-(void) insertDatatableName:(NSString *)tableName :(long) _qId :(long)_qType :(NSString *)_qTitle :(NSString *)_qBody :(NSString *)_qAnswer :(NSString *)_qMark :(NSString *)_qMode :(NSString *)_qPlanName {
    
    if ([db open]) {
        if ([self selectDataInDB:tableName withID:_qId]) {
            NSString *insertSql1= [NSString stringWithFormat:
                                   @"INSERT INTO '%@' ('%@', '%@','%@', '%@','%@', '%@', '%@','%@','%@') VALUES ('%@','%ld', '%ld', '%@','%@', '%@', '%@','%@','%@')",TABLECOLLECT, userID,qId, qType, qTitle,qBody,qAnswer,qMark,qMode,qPlanName,USERID,_qId, _qType, _qTitle,_qBody, _qAnswer, _qMark,_qMode,_qPlanName];
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
