//
//  CourseDetailCell.m
//  SZLTimberTrain
//
//  Created by Apple on 16/9/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "CourseDetailCell.h"

@interface CourseDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *courseImageView;
@property (weak, nonatomic) IBOutlet UIView *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (strong, nonatomic) NSArray * imagesNameArr;
@property (strong, nonatomic) NSArray * funcNameArr;
@end

@implementation CourseDetailCell
- (NSArray *)funcNameArr {
    if (!_funcNameArr) {
        _funcNameArr = @[@"我的考试", @"我的练习", @"我的成绩",@"我的错题",@"我的收藏",@"成绩分析"];
    }
    return _funcNameArr;
}

- (NSArray *)imagesNameArr {
    if (!_imagesNameArr) {
        _imagesNameArr = @[@"ic_main_exam",
                           @"ic_main_practice",
                           @"ic_main_grade",
                           @"ic_main_error",
                           @"ic_main_collect",
                           @"ic_main_grade_analysis",
                           ];
    }
    return _imagesNameArr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.courseImageView.image = nil;
    self.typeLabel.text = @"";
}

- (void)configFuncDetailWithIndexPath:(NSIndexPath *)indexPath {
    self.courseImageView.image = [UIImage imageNamed:self.imagesNameArr[indexPath.row]];
    self.typeLabel.text = self.funcNameArr[indexPath.row];
}

@end
