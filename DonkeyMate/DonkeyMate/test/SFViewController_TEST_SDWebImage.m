//
//  SFViewController_TEST_SDWebImage.m
//  DonkeyMate
//
//  Created by tarena on 15/10/31.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFViewController_TEST_SDWebImage.h"
#import "UIImageView+WebCache.h"

@interface SFViewController_TEST_SDWebImage ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SFViewController_TEST_SDWebImage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"%@", NSHomeDirectory());
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://m2.img.srcdd.com/farm5/d/2015/0806/17/2DAA07362972AF04112D76AFC64B6612_B250_400_250_300.jpeg"]];
    
    NSLog(@"%@", self.view.backgroundColor);
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
