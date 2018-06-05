//
//  CourseDisplayCell.h
//  SZLTimberTrain
//
//  Created by Apple on 16/9/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseDetailCollectionView : UICollectionView

@property (nonatomic, strong) NSIndexPath * indexPath;

@end

static NSString * CourseDetailCellIdentifier = @"CourseDetailCell";

@interface CourseDisplayCell : UITableViewCell

@property (nonatomic, strong) CourseDetailCollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *courseStyleImageView;

+ (instancetype)loadCourseDisplayCell;

+ (CGFloat)loadCellHeight;

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;

@end
