//
//  SFViewController_TestPopActionSheet.m
//  DonkeyMate
//
//  Created by tarena on 15/11/2.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFViewController_TestPopActionSheet.h"
#import "SFAnimatePickerView.h"


@interface SFViewController_TestPopActionSheet ()

@end

@implementation SFViewController_TestPopActionSheet
- (IBAction)showSheet:(id)sender {
//    UIView *picker = [[UIView alloc]init];
//    picker.frame = CGRectMake(0, 480, 320, 100);
//    picker.backgroundColor = [UIColor redColor];
//    [self.view addSubview:picker];
//    [self viewAnimation:picker willHidden:picker.isHidden];
    
    SFAnimatePickerView *picker = [SFAnimatePickerView animatePickerViewWithInView:self.view];
    [picker show];
    
//    [actionSheet showInView:self.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewAnimation:(UIView*)view willHidden:(BOOL)hidden {
    
    [UIView animateWithDuration:0.3 animations:^{
        if (hidden) {
            view.frame = CGRectMake(0, 480, 320, 260);
        } else {
            [view setHidden:hidden];
            view.frame = CGRectMake(0, 245, 320, 260);
        }
    } completion:^(BOOL finished) {
        [view setHidden:hidden];
    }];
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
