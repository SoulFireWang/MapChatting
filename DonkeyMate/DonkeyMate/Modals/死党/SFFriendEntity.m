//
//  SFFriendEntity.m
//  DonkeyMate
//
//  Created by tarena on 15/11/3.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFFriendEntity.h"

@implementation SFFriendEntity
//39.886 116.456
+(NSArray *)demoData{
    SFFriendEntity *friend1 = [SFFriendEntity new];
    friend1.name = @"大野";
    friend1.sign = @"自由 随性";
    friend1.imageURL = @"rBACE1LP8UKwL0FcAAAeyQH9soc176_200x200_3";
    friend1.coordinate = CLLocationCoordinate2DMake(39.886 + arc4random_uniform(10.0)/1000, 116.456 + arc4random_uniform(10.0)/1000);
    
    SFFriendEntity *friend2 = [SFFriendEntity new];
    friend2.name = @"小花";
    friend2.sign = @"今天心情不美丽";
    friend2.imageURL = @"rBACE1NzOQOzNKD5AAB3cJB_RW0336_200x200_3";
    friend2.coordinate = CLLocationCoordinate2DMake(39.886 + arc4random_uniform(10.0)/1000, 116.456 + arc4random_uniform(10.0)/1000);
    
    SFFriendEntity *friend3 = [SFFriendEntity new];
    friend3.name = @"山猫";
    friend3.sign = @"哈哈哈";
    friend3.imageURL = @"rBACE1OYPoyzwUb8AAAbiR4VA0w215_200x200_3";
    friend3.coordinate = CLLocationCoordinate2DMake(39.886 + arc4random_uniform(10.0)/1000, 116.456 + arc4random_uniform(10.0)/1000);
    
    SFFriendEntity *friend4 = [SFFriendEntity new];
    friend4.name = @"随风";
    friend4.sign = @"再见青春";
    friend4.imageURL = @"rBACE1P1rDzj1Io1AAAaEl08MDQ481_200x200_3";
    friend4.coordinate = CLLocationCoordinate2DMake(39.886 + arc4random_uniform(10.0)/1000, 116.456 + arc4random_uniform(10.0)/1000);
    
    SFFriendEntity *friend5 = [SFFriendEntity new];
    friend5.name = @"奥特曼";
    friend5.sign = @"dfds";
    friend5.imageURL = @"rBACFFHybr_StWCEAAAhkjZOycI762_200x200_3";
    friend5.coordinate = CLLocationCoordinate2DMake(39.886 + arc4random_uniform(10.0)/1000, 116.456 + arc4random_uniform(10.0)/1000);
    
    SFFriendEntity *friend6 = [SFFriendEntity new];
    friend6.name = @"秋秋秋";
    friend6.sign = @"sfds";
    friend6.imageURL = @"rBACFFOYPoyih-G3AAAjXyz4XMk996_200x200_3";
    friend6.coordinate = CLLocationCoordinate2DMake(39.886 + arc4random_uniform(10.0)/1000, 116.456 + arc4random_uniform(10.0)/1000);
    
    SFFriendEntity *friend7 = [SFFriendEntity new];
    friend7.name = @"酒肉和尚";
    friend7.sign = @"dfehu";
    friend7.imageURL = @"u=4196456247,3870486792&fm=21&gp=0";
    friend7.coordinate = CLLocationCoordinate2DMake(39.886 + arc4random_uniform(10.0)/1000, 116.456 + arc4random_uniform(10.0)/1000);
    
    return @[friend1, friend2, friend3, friend4, friend5, friend6, friend7];
}

@end
