//
//  MainFuncCell.m
//  SZLTimberTrain
//
//  Created by Apple on 16/9/6.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "MainFuncCell.h"

@interface MainFuncCell ()


@property (strong, nonatomic) NSArray * imagesNameArr;
@property (strong, nonatomic) NSArray * funcNameArr;

@end

@implementation MainFuncCell

- (NSArray *)funcNameArr {
    if (!_funcNameArr) {
        _funcNameArr = @[@"新闻信息", @"公告消息", @"投票"];
    }
    return _funcNameArr;
}

- (NSArray *)imagesNameArr {
    if (!_imagesNameArr) {
        _imagesNameArr = @[@"ic_main_news",
                           @"ic_main_notice",
                           @"ic_main_vote",
                          ];
    }
    return _imagesNameArr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self createNoticeNumLabel];
    self.funcImageView.image = nil;
    _noticeNumBg.image = nil;
    self.funcTitleLabel.text = @"";
}

- (void)configFuncDetailWithIndexPath:(NSIndexPath *)indexPath {
    self.funcImageView.image = [UIImage imageNamed:self.imagesNameArr[indexPath.row]];
    self.funcTitleLabel.text = self.funcNameArr[indexPath.row];
}

-(void)createNoticeNumLabel{
//    _noticeNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _noticeNumBg.v_size.width, _noticeNumBg.v_size.height)];
//    _noticeNumLabel.textColor = WhiteColor;
//    _noticeNumLabel.font = [UIFont systemFontOfSize:12];
    
    [_noticeNumBg addSubview:_noticeNumLabel];

}


@end
