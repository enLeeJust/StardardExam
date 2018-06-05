//
//  NewsDetailViewController.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/18.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "SZLBaseVC.h"
#import "NewsOrNoticeModel.h"
@interface NewsDetailViewController : SZLBaseVC<UIWebViewDelegate>

@property (nonatomic,strong) NewsOrNoticeModel *newsOrNoticeDetail;
@property (nonatomic,strong) UIWebView *newsOrNoticeWebView;


@end
