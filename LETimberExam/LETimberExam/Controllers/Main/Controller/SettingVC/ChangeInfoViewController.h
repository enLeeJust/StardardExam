//
//  ChangeInfoViewController.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/29.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "SZLBaseVC.h"
#import "PersonInfoViewController.h"
@interface ChangeInfoViewController : SZLBaseVC

//@property(nonatomic,copy) NSString *changeItem;
@property(nonatomic,copy) NSString *changeItemName;
@property(nonatomic,copy) NSString *itemString;
@property (assign, nonatomic) id<ChangePersonInfoDelegate> delegate;
@end
