//
//  MainFuncCell.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * MainFuncCellIdentifier = @"MainFuncCell";

@interface MainFuncCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *funcImageView;
@property (weak, nonatomic) IBOutlet UILabel *funcTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *noticeNumBg;
@property (strong, nonatomic) IBOutlet UILabel * noticeNumLabel;

- (void)configFuncDetailWithIndexPath:(NSIndexPath *)indexPath;

@end
