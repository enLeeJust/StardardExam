//
//  GuidePageViewController.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/28.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuidePageViewController : UIViewController

@property (nonatomic, strong) NSArray * guideImages;

- (id)initWithGuideImages:(NSArray *)images;

@end
