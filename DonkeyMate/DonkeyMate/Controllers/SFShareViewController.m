//
//  SFShareViewController.m
//  DonkeyMate
//
//  Created by tarena on 15/11/1.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFShareViewController.h"

@interface SFShareViewController ()

@end

@implementation SFShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.tabBarItem.image = [UIImage imageNamed:@"tabbar_discover"];
    self.navigationController.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_discoverHL"];
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
