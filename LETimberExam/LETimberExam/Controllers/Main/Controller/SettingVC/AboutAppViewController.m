//
//  AboutAppViewController.m
//  SZLTimber
//
//  Created by 桂舟 on 16/9/29.
//  Copyright © 2016年 timber. All rights reserved.
//

#import "AboutAppViewController.h"
//#import "FeedbackViewController.h"
#import "SZLBaseWebViewController.h"
@interface AboutAppViewController (){
    UITableView *abourAppTB;
    UIImageView *appLogo;
    UILabel *appVersionLabel;
}

@end

@implementation AboutAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNav];
    [self createAboutAppTB];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{


}


-(void)createNav{
    self.navigationTitle = @"关于";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"ic_register_back"] forState:UIControlStateNormal];
    [self.navigationLeftButton addTarget:self action:@selector(buttonBackToLastView) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)buttonBackToLastView{
    [self.navigationController popViewControllerAnimated:YES];
    
}


/**
 *  创建TableView
 */
-(void)createAboutAppTB{
    abourAppTB = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStyleGrouped];
    
    abourAppTB.delegate = self;
    abourAppTB.dataSource = self;
    abourAppTB.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.contentView addSubview:abourAppTB];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,WIDTH, 140)];
//    headView.backgroundColor = MyBlue;
    
    appLogo = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/2-40, 25,80 ,80)];
    appLogo.image = [UIImage
                          imageNamed:@"ic_login_Logo"];
    appLogo.contentMode = UIViewContentModeScaleAspectFit;
    
    appVersionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 115, WIDTH-20, 20)];
    appVersionLabel.textAlignment = NSTextAlignmentCenter;
    appVersionLabel.textColor = [UIColor darkGrayColor];
    appVersionLabel.font = [UIFont fontWithName:@"Arial" size:16];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleName"];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    appVersionLabel.text = [NSString stringWithFormat:@"%@%@(%@)",app_Name, app_Version, app_build];

    
    [headView addSubview:appLogo];
    [headView addSubview:appVersionLabel];
    
    abourAppTB.tableHeaderView = headView;
    
}

#pragma mark TabelViewData Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
//根据是否展开返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}
#pragma mark TabelViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static    NSString * cellString = @"NewsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellString];
    //    如果如果没有多余单元，则需要创建新的单元
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellString];
    }
    
    switch (indexPath.row) {
//        case 0:
//            cell.textLabel.text = @"版本更新";
//            cell.detailTextLabel.text = @"目前为最新版本";
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            break;
        case 0:
            cell.textLabel.text = @"意见反馈";
//            cell.detailTextLabel.text = @"男";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;

            
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SZLBaseWebViewController *feedbackVC = [[SZLBaseWebViewController alloc]initWithUrl:[NSURL URLWithString:@"http://kf.timber2005.com/project/WapFeedBack.aspx?infoid=190"]];
        
        
        [self.navigationController pushViewController:feedbackVC animated:YES];
    }else if (indexPath.row == 1){
//        SZLBaseWebViewController *feedbackVC = [[SZLBaseWebViewController alloc]initWithUrl:[NSURL URLWithString:@"http://kf.timber2005.com/project/WapFeedBack.aspx?infoid=190"]];
//        
//        
//        [self.navigationController pushViewController:feedbackVC animated:YES];
        
        
        
        
    }else{
    
    
    }


}


@end
