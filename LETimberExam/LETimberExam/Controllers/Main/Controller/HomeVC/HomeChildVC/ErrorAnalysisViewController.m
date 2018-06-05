//
//  ErrorAnalysisViewController.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/12.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "ErrorAnalysisViewController.h"
#import "ZFChart.h"
@interface ErrorAnalysisViewController ()<ZFPieChartDataSource, ZFPieChartDelegate>

@property (nonatomic,strong)NSMutableArray *valueArr;
@property (nonatomic, strong) ZFPieChart * pieChart;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat totalValue;
@end

@implementation ErrorAnalysisViewController
#pragma mark - setUp
- (void)setUp{
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
        //首次进入控制器为横屏时
        _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT * 0.5;
        
    }else{
        //首次进入控制器为竖屏时
        _height = SCREEN_HEIGHT - NAVIGATIONBAR_HEIGHT;
    }
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    [self createPieChartView];
    [self creatNav];
    [self getUserScoreInfoOutline:1];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    DLog(@"success");

}

#pragma mark - create View
-(void)creatNav{
    
    self.navigationTitle = @"考试通过率";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"ic_register_back"] forState:UIControlStateNormal];
    [self.navigationLeftButton addTarget:self action:@selector(buttonBackToLastView) forControlEvents:UIControlEventTouchUpInside];
}


-(void)createPieChartView{
    self.pieChart = [[ZFPieChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,  _height)];
    self.pieChart.dataSource = self;
    self.pieChart.delegate = self;
    self.pieChart.isShowPercent = NO;
    
}

-(void)createColorShow{
    
    NSArray *colorArr = @[MyBlue,MyOrange,[UIColor lightGrayColor]];
    NSArray *titleArr = @[@"通过考试",@"未通过考试",@"未公布"];

    
    for (int i =0; i<colorArr.count; i++) {
        UILabel *colorBlock = [[UILabel alloc] initWithFrame:CGRectMake(12, 12+32*i, 20, 20)];
        colorBlock.backgroundColor = colorArr[i];
        
        UILabel *colorBlockMain = [[UILabel alloc] initWithFrame:CGRectMake(40, 12+32*i, 100, 20)];
        colorBlockMain.textColor = MyTextColor;
        colorBlockMain.font = [UIFont systemFontOfSize:16];
        colorBlockMain.text = titleArr[i];
        
        UILabel *pencentLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 12+32*i, 150, 20)];
        pencentLabel.textColor = [UIColor lightGrayColor];
        pencentLabel.font = [UIFont systemFontOfSize:16];
        pencentLabel.text = [self getPercent:i];
        
        
        [self.pieChart addSubview:colorBlock];
        [self.pieChart addSubview:colorBlockMain];
        [self.pieChart addSubview:pencentLabel];
    }

}


/**
 *  计算百分比
 *
 *  @return NSString
 */
- (NSString *)getPercent:(NSInteger)index{
    CGFloat percent = [_valueArr[index] floatValue] / _totalValue * 100;
    NSString * string;
    string = [NSString stringWithFormat:@"所占比例为:%.2f%%",percent];
    return string;
}

-(void)buttonBackToLastView{
    [self.navigationController popViewControllerAnimated:YES];
    
}


/*
 *获取考试成绩概况
 *
 */

-(void)getUserScoreInfoOutline:(NSInteger)type{
    __weak ErrorAnalysisViewController * wself = self;
    if (kNetworkNotReachability) {
        [self.view makeToast:kError_Network_NotReachable];
        return;
    }
    __block ApiRequest *request = [SZLServerHelper getUserExamInfoOutlineRequest:type callback:^(NSInteger errCode, ApiResponse *response, BOOL success) {
        [wself.requestArr removeObject:request];
        if (success) {
            NSMutableDictionary *data = response.data;
            NSDictionary *userExamOutline = [data objectForKey:@"PlanInfo"];
            NSInteger passExam = [[userExamOutline objectForKey:@"p1"] integerValue];
            NSInteger disPassExam = [[userExamOutline objectForKey:@"p2"] integerValue];
            NSInteger unknowExam = [[userExamOutline objectForKey:@"p3"] integerValue];
            wself.valueArr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%lu",(long)passExam],[NSString stringWithFormat:@"%lu",disPassExam],[NSString stringWithFormat:@"%lu",unknowExam], nil];
            wself.totalValue = passExam + disPassExam+ unknowExam;
            [wself.pieChart strokePath];
            [wself createColorShow];
            [wself.contentView addSubview:wself.pieChart];

        }
        else{
            [wself.view makeToast:response.errDesc];
        }
    }];
    [wself.requestArr addObject:request];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - ZFPieChartDataSource

- (NSArray *)valueArrayInPieChart:(ZFPieChart *)chart{
    return _valueArr;
}

- (NSArray *)colorArrayInPieChart:(ZFPieChart *)chart{
    return @[MyBlue,MyOrange,[UIColor lightGrayColor]];
}

#pragma mark - ZFPieChartDelegate

- (void)pieChart:(ZFPieChart *)pieChart didSelectPathAtIndex:(NSInteger)index{
    DLog(@"第%ld个",(long)index);
    
    
    
}

- (CGFloat)radiusForPieChart:(ZFPieChart *)pieChart{
    return 130.f;
}

/** 此方法只对圆环类型(kPieChartPatternTypeForCirque)有效 */
- (CGFloat)radiusAverageNumberOfSegments:(ZFPieChart *)pieChart{
    return 2.f;
}

#pragma mark - 横竖屏适配(若需要同时横屏,竖屏适配，则添加以下代码，反之不需添加)

/**
 *  PS：size为控制器self.view的size，若图表不是直接添加self.view上，则修改以下的frame值
 */
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
//    
//    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight){
//        self.pieChart.frame = CGRectMake(0, 0, size.width, size.height - NAVIGATIONBAR_HEIGHT * 0.5);
//    }else{
//        self.pieChart.frame = CGRectMake(0, 0, size.width, size.height + NAVIGATIONBAR_HEIGHT * 0.5);
//    }
//    
//    [self.pieChart strokePath];
//}





@end
