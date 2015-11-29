//
//  SFNameViewController.m
//  DonkeyMate
//
//  Created by tarena on 15/11/15.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFNameViewController.h"

@interface SFNameViewController ()

/**
 *  姓名输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *nameTextFiled;

@end

@implementation SFNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"姓名"; 
    
    self.navigationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(saveClick:)];
    
}

-(void)saveClick:(id)sender{

    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_UPDATE_PERSON_NAME object:nil userInfo:@{NOTIFICATION_UPDATE_PERSON_NAME: self.nameTextFiled.text}];
    
    [self.navigationController popViewControllerAnimated:YES];
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
