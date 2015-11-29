//
//  SFPersonEnity.h
//  DonkeyMate
//
//  Created by tarena on 15/10/29.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFBaseEntity.h"
#import <CoreLocation/CoreLocation.h>

@interface SFPersonEnity : SFBaseEntity

/**
 *  姓名
 */
@property (nonatomic, strong) NSString *name;

/**
 *  人物当前坐标
 */
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/**
 *  人物头像
 */
@property (nonatomic ,strong) NSString *imageURL;

/**
 *  身高
 */
@property (nonatomic, assign) double height;

/**
 *  体重
 */
@property (nonatomic, assign) double weight;

/**
 *  年龄
 */
@property (nonatomic, assign) NSInteger age;

/**
 *  性别 YES：男  NO:女
 */
@property (nonatomic, assign) BOOL gender;

/**
 *  我的故事
 */
@property (nonatomic, strong) NSArray *storys;

/**
 *  我的朋友
 */
@property (nonatomic, strong) NSArray *friends;

/**
 *  我的足迹
 */
@property (nonatomic, strong) NSString *tracks;

/**
 *  个性签名
 */
@property (nonatomic, strong) NSString *sign;

/**
 *  登陆时间
 */
@property (nonatomic, strong) NSDate *loginTime;

/**
 *  聊天内容
 */
@property (nonatomic, strong) NSMutableArray *chattingContent;



@end
