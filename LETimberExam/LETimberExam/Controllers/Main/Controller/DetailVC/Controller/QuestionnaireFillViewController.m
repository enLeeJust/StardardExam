//
//  QuestionnaireFillViewController.m
//  SZLTimber
//
//  Created by 桂舟 on 16/10/17.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "QuestionnaireFillViewController.h"
#define IMGURL @"src=\"http://exam1.timber2005.com/"//@"http://121.42.216.164/"
#define FONT_SIZE 16.0f
#define CELL_CONTENT_WIDTH [[UIScreen mainScreen] bounds].size.width
#define CELL_CONTENT_MARGIN 10.0f
#define MARGIN 10

@interface QuestionnaireFillViewController ()<UITextFieldDelegate,UITextViewDelegate>{
    UIWebView* MywebView;
    UILabel *labltTitle;
    
    
    

}



@end

@implementation QuestionnaireFillViewController

- (id)initWithFrame:(CGRect)frame QuestionnaireInfo:(questionnaireDetailModel*)questionnaireInfo{
    _questionnaireInfo = questionnaireInfo;
    _QuestionnaireTitle = [NSString stringWithFormat:@"%ld、%@",questionnaireInfo.QuestionNum,questionnaireInfo.Title];
    _QuestionnaireOption = questionnaireInfo.Option;
    _questionnaireID = questionnaireInfo.QuestionId;
    return self;
}



//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textFiled resignFirstResponder];
    [self.textUView resignFirstResponder];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _scroollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CELL_CONTENT_WIDTH, self.view.frame.size.height-81)];
    
    [_scroollView setContentSize:CGSizeMake(WIDTH, HEIGHT*2)];
    [self.view addSubview:_scroollView];
    
    
    [self creatTitleView];
    [self creatUserAnswerView];
}


//得到相匹配的的视图高度
-(int)getTitleHight:(NSString *)titleInfo
{
    CGSize constraint = CGSizeMake(WIDTH - (MARGIN * 2), 20000.0f);
    CGRect size = [titleInfo boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE]} context:nil];
    
    CGFloat height = MAX(size.size.height, 44.0f);
    return height + (MARGIN * 2);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//创建试题头区域
- (void)creatTitleView{
    
//    _scroollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH,HEIGHT-64-44)];
//    [self.view addSubview:_scroollView];
    
    labltTitle =[[UILabel alloc]init];
    labltTitle.lineBreakMode = NSLineBreakByWordWrapping;
    labltTitle.numberOfLines = 0;
    labltTitle.font = [UIFont systemFontOfSize:16];
    [labltTitle setNumberOfLines:0];
    [labltTitle setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    [labltTitle setText:[self filterHTML:_QuestionnaireTitle]];
    [labltTitle setFrame:CGRectMake(MARGIN, MARGIN, WIDTH - (MARGIN * 2), MAX(44.0f,[self getTitleHight:_QuestionnaireTitle]))];
//    labltTitle.backgroundColor = UIColorFromRGB(0xfafafa);
    labltTitle.backgroundColor = [UIColor clearColor];
    
    [_scroollView addSubview:labltTitle];
    
    
}


//创建用户答题区域
- (void)creatUserAnswerView{
    NSRange r = [self.QuestionnaireTitle rangeOfString:@"src"];
    if(_questionnaireInfo.TypeId==4){//填空

        self.textFiled = [[UITextField alloc]init];
        if (r.location == NSNotFound) {//没有图片
            self.textFiled.frame = CGRectMake(MARGIN/2, labltTitle.frame.size.height+MARGIN*2, WIDTH-MARGIN*2, 44);
        }else{
            self.textFiled.frame = CGRectMake(MARGIN/2, MywebView.frame.size.height+MARGIN*2, WIDTH-MARGIN*2, 44);
        }
        
        //        textFiled.backgroundColor= [UIColor colorWithWhite:0.5 alpha:0.5];
        [self.textFiled.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self.textFiled.layer setBorderWidth:1];
        [self.textFiled.layer setMasksToBounds:YES];
        self.textFiled.layer.cornerRadius = 15.0;
        self.textFiled.placeholder = @"请在此区域内填写！";
        
        if ([self.childHistoryAnswer isEqualToString:@""]||[self.childHistoryAnswer isEqualToString:@"-"]) {
            self.textFiled.placeholder = @"请在此区域内填写！";
        }else{
            self.textFiled.text = self.childHistoryAnswer;
            NSString *ansUserStr = [self.textFiled.text  stringByReplacingOccurrencesOfString:@" " withString:@""];
            _answerUser = [ansUserStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }
        
        self.textFiled.delegate = self;
        [_scroollView addSubview:self.textFiled];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserAnswerChange:) name:@"FillTextField" object:self.textFiled];
        
    }else {//简答
        self.textUView = [[UITextView alloc]init];
        if (HEIGHT<500) {
            self.textUView.frame = CGRectMake(MARGIN, labltTitle.frame.size.height+MARGIN*2, WIDTH-MARGIN*2, 150);
        }else{
            self.textUView.frame = CGRectMake(MARGIN, labltTitle.frame.size.height+MARGIN*2, WIDTH-MARGIN*2, 200);
        }
//        textUView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
        [self.textUView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self.textUView.layer setBorderWidth:1];
        [self.textUView.layer setMasksToBounds:YES];
        self.textUView.layer.cornerRadius = 15.0;
  
        
        if ([self.childHistoryAnswer isEqualToString:@""]||[self.childHistoryAnswer isEqualToString:@"-"]) {
           
        }else{
            self.textUView.text = self.childHistoryAnswer;
        }
        
        
        self.textUView.delegate = self;
        [_scroollView addSubview:self.textUView];
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserAnswerChange:) name:@"FillTextView" object:self.textUView];
        
    }
    
}

-(void)UserAnswerChange:(NSNotification *)notification{
    NSString *ansString;
    NSString *ansUserStr;
    if ([notification.name isEqualToString:@"FillTextField"]) {
        ansString = self.textFiled.text;
        _answerUser = [ansString  stringByReplacingOccurrencesOfString:@" " withString:@""];
    }else if ([notification.name isEqualToString:@"FillTextView"]) {
        ansString = self.textUView.text;
        ansUserStr = [ansString  stringByReplacingOccurrencesOfString:@" " withString:@""];
        _answerUser = [ansUserStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    

    NSLog(@"用户给出的答案:%@",_answerUser);
    
}



//开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.delegate userAnserCount];
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self.delegate userAnserCount];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *ansString = textField.text;
    _answerUser = [ansString  stringByReplacingOccurrencesOfString:@" " withString:@""];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSString *ansString = textView.text;
    NSString *ansUserStr = [ansString  stringByReplacingOccurrencesOfString:@" " withString:@""];
    _answerUser = [ansUserStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSLog(@"用户给出的答案:%@",_answerUser);
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
