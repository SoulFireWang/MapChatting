//
//  SFtestViewController.m
//  DonkeyMate
//
//  Created by tarena on 15/11/7.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFtestViewController.h"
#import "UUInputFunctionView.h"
#import "SFInputText.h"
#import "SFApplication.h"
#import "SFPersonHeadView.h"

@interface SFtestViewController ()

@end

@implementation SFtestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    SFPersonHeadView *input = [[SFPersonHeadView alloc] initWithPerson:[SFApplication defoultSystemUser]];
    input.frame = CGRectMake(10, 100, input.frame.size.width, input.frame.size.height);
    [self.view addSubview:input];
    
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
