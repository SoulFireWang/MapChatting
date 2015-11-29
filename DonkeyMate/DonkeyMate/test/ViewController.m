//
//  ViewController.m
//  CustomTabBar
//
//  Created by zhangshuai on 15/11/4.
//  Copyright © 2015年 zhangshuai. All rights reserved.
//

#import "ViewController.h"

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "MiddleViewController.h"
#import "ThirdViewController.h"
#import "FourViewController.h"

@interface ViewController ()
{
    UIImageView *imageView;
    NSArray *imageArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"startImg0"],[UIImage imageNamed:@"startImg1"],[UIImage imageNamed:@"startImg2"],[UIImage imageNamed:@"startImg3"],[UIImage imageNamed:@"startImg4"],[UIImage imageNamed:@"startImg5"],[UIImage imageNamed:@"startImg6"], nil];
    
    FirstViewController *first = [[FirstViewController alloc] init];
    first.tabBarItem.title = @"首页";
    first.tabBarItem.image = [UIImage imageNamed:@"tabbar_company_home"];
    [first.tabBarItem setSelectedImage:[UIImage imageNamed:@"tabbar_company_home_select"]];
    
    SecondViewController *second = [[SecondViewController alloc] init];
    second.tabBarItem.title = @"动态";
    second.tabBarItem.image = [UIImage imageNamed:@"tabbar_dynamic"];
    [second.tabBarItem setSelectedImage:[UIImage imageNamed:@"tabbar_dynamic_selected"]];
    
    MiddleViewController *middle = [[MiddleViewController alloc] init];
    [self addCenterButtonWithImage:[UIImage imageNamed:@"middleImage"] highlightImage:nil];
    
    ThirdViewController *third = [[ThirdViewController alloc] init];
    third.tabBarItem.title = @"广场";
    third.tabBarItem.image = [UIImage imageNamed:@"tabbar_position_oringin"];
    [third.tabBarItem setSelectedImage:[UIImage imageNamed:@"tabbar_position_selected"]];
    
    FourViewController *four = [[FourViewController alloc] init];
    four.tabBarItem.title = @"我的";
    four.tabBarItem.image = [UIImage imageNamed:@"tabbar_mine_oringin"];
    [four.tabBarItem setSelectedImage:[UIImage imageNamed:@"tabbar_mine_selected"]];

    self.viewControllers = @[first,second,middle,third,four];
}

//添加中间按钮
- (void)addCenterButtonWithImage:(UIImage *)buttonImage highlightImage:(UIImage *)highlightImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        button.center = center;
    }
    
    [self.view addSubview:button];
}

- (void)buttonClick
{
    NSLog(@"点击中间按钮");
   
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    imageView.animationImages = imageArray;
    imageView.animationRepeatCount = 0;
    imageView.animationDuration = 1.0f;
    [imageView startAnimating];
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
