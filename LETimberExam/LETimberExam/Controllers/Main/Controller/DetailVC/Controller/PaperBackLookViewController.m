//
//  PaperBackLookViewController.m
//  SZLTimber
//
//  Created by 桂舟 on 16/11/2.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "PaperBackLookViewController.h"

@interface PaperBackLookViewController ()<UIWebViewDelegate>{
    MBProgressHUD *hud;
    
}
@property (nonatomic,strong) UIWebView *paperDetailWV;

@end

@implementation PaperBackLookViewController
-(UIWebView *)paperDetailWV{
    if (!_paperDetailWV) {
        _paperDetailWV = [[UIWebView alloc] initWithFrame:CGRectMake(0
                                                                     , 0,WIDTH , HEIGHT-64)];
        _paperDetailWV.opaque = NO;
        _paperDetailWV.delegate = self;
        _paperDetailWV.backgroundColor= [UIColor clearColor];
    }
    return _paperDetailWV;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createPaperDetailNav];
    [self createConfigView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - createView
-(void)createPaperDetailNav{
    self.navigationTitle = @"试卷回顾";
    
    
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"ic_register_back"] forState:UIControlStateNormal];
    [self.navigationLeftButton addTarget:nil action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)createConfigView{
    self.view.backgroundColor = [UIColor whiteColor];
    
//    NSString *path = [_paperUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[_paperUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    
//    NSURL *url = [[NSURL alloc] initWithString:path];
    [self.paperDetailWV loadRequest:[NSURLRequest requestWithURL:url]];
    [self.contentView addSubview:self.paperDetailWV];
}


#pragma mark - buttonAction
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}



#pragma mark - UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.color = [UIColor colorWithRed:0 green:0.0 blue:0.0 alpha:0.5];
    
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{
    hud.hidden = YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [SZLInfoHelperManager JumpAlter:@"数据加载错误请重试" after:1.0f To:self.view];
    //    sleep(3.0f);
    
    //    [self.navigationController popViewControllerAnimated:YES];
}
@end
