//
//  FeedbackViewController.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/29.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController (){
    UITextView *feedbackTV;
    
    UILabel *connectPhoneLabel;
    UITextField *connectPhoneTF;
    
    UIButton *sureBtn;

}

@end

@implementation FeedbackViewController
static NSString * myTVPlaceholder = @"请输入遇到的问题或建议...";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNav];
    [self createFeedBackTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    DLog(@"dealloc success");

}

-(void)createNav{
    self.navigationTitle = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"ic_register_back"] forState:UIControlStateNormal];
    [self.navigationLeftButton addTarget:self action:@selector(buttonBackToLastView) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)buttonBackToLastView{
    [self.navigationController popViewControllerAnimated:YES];
    
}


/**
 *  创建反馈栏
 */

-(void)createFeedBackTextView{
    UIView *feedBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, WIDTH, 150)];
    feedBackView.backgroundColor = WhiteColor;
    feedbackTV = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, WIDTH-20, 140)];
    feedbackTV.backgroundColor=[UIColor whiteColor]; //背景色
    feedbackTV.scrollEnabled = YES;    //当文字超过视图的边框时是否允许滑动，默认为“YES”
    feedbackTV.editable = YES;        //是否允许编辑内容，默认为“YES”
    feedbackTV.delegate = self;       //设置代理方法的实现类
    feedbackTV.font=[UIFont fontWithName:@"Arial" size:16.0]; //设置字体名字和字体大小;
    feedbackTV.returnKeyType = UIReturnKeyDefault;//return键的类型
    feedbackTV.keyboardType = UIKeyboardTypeDefault;//键盘类型
    feedbackTV.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
    feedbackTV.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
    feedbackTV.textColor = [UIColor grayColor];
    feedbackTV.text = myTVPlaceholder;//设置显示的文本内容
    
//    [feedbackTV.layer setBorderColor:[UIColor blackColor].CGColor];
//    [feedbackTV.layer setBorderWidth:1];
//    [feedbackTV.layer setMasksToBounds:YES];
//    feedbackTV.layer.cornerRadius = 5.0;
    [feedBackView addSubview:feedbackTV];
    [self.contentView addSubview:feedBackView];
    
    UIView *connectView = [[UIView alloc] initWithFrame:CGRectMake(0, 195, WIDTH, 45)];
    connectView.backgroundColor = WhiteColor;
    
    connectPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, WIDTH/3, 21)];
    connectPhoneLabel.font = [UIFont systemFontOfSize:16];
    connectPhoneLabel.textColor = [UIColor darkGrayColor];
    connectPhoneLabel.textAlignment = NSTextAlignmentLeft;
    connectPhoneLabel.text = @"联系电话";
    
    
    connectPhoneTF = [[UITextField alloc] initWithFrame:CGRectMake(WIDTH/3+22, 7, WIDTH/2, 30)];
    connectPhoneTF.placeholder = @"选填，便于我们联系你";
    connectPhoneTF.font = [UIFont fontWithName:@"Avenir-Book" size:16.0f];
    connectPhoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    connectPhoneTF.delegate = self;
    
    [connectView addSubview:connectPhoneLabel];
    [connectView addSubview:connectPhoneTF];
    [self.contentView addSubview:connectView];
    
    
    sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10,270, WIDTH-20, 40);
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"ic_login_btn"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:19.0f];
    [sureBtn setTitle:@"提交" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    [sureBtn addTarget:self action:@selector(sendRequestForSubmitFeedBack) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:sureBtn];
    
    
    
}


/**
 *  sendRequestForSubmitFeedBack
 *  提交反馈
 */
-(void)sendRequestForSubmitFeedBack{


}


#pragma mark --UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    //    [textView resignFirstResponder];
    
    
    if ([feedbackTV.text isEqualToString:myTVPlaceholder]) {
        feedbackTV.text = @"";
        
    }else{
        
        
    }
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    [textView resignFirstResponder];

}

#pragma mark --UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if ([textField isEqual:connectPhoneTF]) {
        [connectPhoneTF resignFirstResponder];
    }
    return YES;
}
@end
