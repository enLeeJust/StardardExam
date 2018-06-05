//
//  NewsCell.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/13.
//  Copyright © 2016年 timber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *newsStatus;
@property (weak, nonatomic) IBOutlet UILabel *newsBody;

@property (weak, nonatomic) IBOutlet UILabel *newsType;
@property (weak, nonatomic) IBOutlet UILabel *newsDate;
@end
