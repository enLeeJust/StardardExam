//
//  QuesCardCell.h
//  SZLTimber
//
//  Created by 桂舟 on 16/9/20.
//  Copyright © 2016年 timber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuesCardCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *quesIndexLabel;
@property (weak, nonatomic) IBOutlet UIImageView *quesMarkIV;

@property (weak, nonatomic) IBOutlet UIImageView *quesDoneIV;
@end
