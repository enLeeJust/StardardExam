//
//  NewsDetailViewController.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/18.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "NewsDetailViewController.h"


@interface NewsDetailViewController ()<UIWebViewDelegate>{

    MBProgressHUD *hud;

}

@end


@implementation NewsDetailViewController

#pragma lazy loading
-(UIWebView *)newsOrNoticeWebView{
    if(!_newsOrNoticeWebView){
        _newsOrNoticeWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT -64)];
        _newsOrNoticeWebView.opaque = NO;
        _newsOrNoticeWebView.delegate = self;
        _newsOrNoticeWebView.backgroundColor= [UIColor clearColor];
        
    }
    return _newsOrNoticeWebView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNewsAndNoticeNav];
    
    [self createConfigView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)createNewsAndNoticeNav{
    self.navigationTitle = @"详情";

    [self.navigationLeftButton setImage:[UIImage imageNamed:@"ic_register_back"] forState:UIControlStateNormal];
    [self.navigationLeftButton addTarget:nil action:@selector(BackBtnClick) forControlEvents:UIControlEventTouchUpInside];

}

/**
 *  创建webView
 */

-(void)createConfigView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    NSString *path = _newsOrNoticeDetail.url;
    NSURL *url = [[NSURL alloc] initWithString:path];
    [self.newsOrNoticeWebView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.contentView addSubview:_newsOrNoticeWebView];
}




-(void)BackBtnClick{
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
