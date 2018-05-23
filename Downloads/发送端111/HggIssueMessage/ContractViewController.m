//
//  ContractViewController.m
//  HggIssueMessage
//
//  Created by 微微只是一只程序员 on 2018/5/22.
//  Copyright © 2018年 jinshuaier. All rights reserved.
//

#import "ContractViewController.h"

@interface ContractViewController ()

@end

@implementation ContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"联系方式";
    //添加一个小头
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0,80, 300, 40);
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.text = @"联系方式：qq2198706859";
    titleLabel.textColor = [UIColor redColor];
    [self.view addSubview:titleLabel];
    
    UILabel *titleLabel1 = [[UILabel alloc] init];
    titleLabel1.frame = CGRectMake(0,160, 300, 40);
    titleLabel1.font = [UIFont systemFontOfSize:20];
    titleLabel1.text = @"邮箱：2198706859@qq.com";
    titleLabel1.textColor = [UIColor redColor];
    [self.view addSubview:titleLabel1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
