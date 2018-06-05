//
//  SZLBaseWebViewController.h
//  SZLTimberTrain
//
//  Created by Apple on 16/11/4.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "SZLBaseVC.h"

@interface SZLBaseWebViewController : SZLBaseVC

@property (nonatomic, strong) NSString * webTitle;

@property (nonatomic, strong) NSURL * url;

@property (nonatomic, strong) UIWebView * webView;

@property (nonatomic, strong) UIColor * progressViewColor;

- (instancetype)initWithUrl:(NSURL *)url;

- (void)reloadWebView;

@end
