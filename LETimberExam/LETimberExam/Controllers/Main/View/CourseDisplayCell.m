//
//  CourseDisplayCell.m
//  SZLTimberTrain
//
//  Created by Apple on 16/9/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#define kPadding 3
#define kVerticalSpacing 8
#define kSideLength (375-65)/3
#define kItemHeight (375-35)/3
#import "CourseDisplayCell.h"

@implementation CourseDetailCollectionView

@end

@interface CourseDisplayCell ()

@property (weak, nonatomic) IBOutlet UIView *displayView;

@end

@implementation CourseDisplayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.sectionInset = UIEdgeInsetsMake(kVerticalSpacing, kPadding, kVerticalSpacing, kPadding);
    layout.sectionInset = UIEdgeInsetsMake(8, 5, 8, 5);
    layout.itemSize = CGSizeMake(kSideLength, kItemHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = kPadding;
    self.collectionView = [[CourseDetailCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CourseDetailCellIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.displayView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.leading.trailing.equalTo(0);
        make.bottom.equalTo(@0);
    }];
}

+ (instancetype)loadCourseDisplayCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"CourseDisplayCell" owner:self options:nil]lastObject];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView bringSubviewToFront:self.courseStyleImageView];
}

+ (CGFloat)loadCellHeight {
    CGFloat height = 20 + kItemHeight*2 + 3*kVerticalSpacing;
//    if (ISIPHONE_6p) {
//        height = 20 + kItemHeight*2 + 3*kVerticalSpacing;
//    }else{
//        
//    }
    
    return height;
}

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath
{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.indexPath = indexPath;
    
    [self.collectionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
