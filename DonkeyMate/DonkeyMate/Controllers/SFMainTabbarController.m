//
//  SFMainTabbarController.m
//  DonkeyMate
//
//  Created by tarena on 15/11/6.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFMainTabbarController.h"
#import "SFMapViewController.h"

@implementation SFMainTabbarController

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self addCenterButtonWithImage:[UIImage imageNamed:@"map_64px_1092370_easyicon.net"] highlightImage:nil];
    }
    return self;
}

//添加中间按钮
- (void)addCenterButtonWithImage:(UIImage *)buttonImage highlightImage:(UIImage *)highlightImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    //    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    //    self.tabBarController.tabBar adds
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    
    [button addTarget:self action:@selector(jumpToMap) forControlEvents:UIControlEventTouchDown];
    if (heightDifference < 0)
        button.center = self.tabBarController.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        center.x = self.tabBar.frame.size.width - button.frame.size.width / 2;
        button.center = center;
    }
    
    [self.tabBar addSubview:button];
    
    self.selectedIndex = 3;
}

-(void)jumpToMap{
    self.selectedIndex = 3;
}




@end
