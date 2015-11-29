//
//  SFApplication.m
//  DonkeyMate
//
//  Created by tarena on 15/11/4.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFApplication.h"
#import "SFFriendEntity.h"

@implementation SFApplication

/**
 *  系统用户单例对象
 */
static SFPersonEnity *_user;
+(SFPersonEnity *)defoultSystemUser{
    if (_user==nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            {
                _user = [SFPersonEnity new];
                _user.name = @"王秀峰";
                _user.gender = YES;
                _user.height = 170;
                _user.weight = 65;
                _user.sign = @"个性签名构思中";
                _user.age = 28;
                _user.imageURL = @"rBACFFPSD3yDf8EMAADeQiNCD2Y614_200x200_3";
                _user.friends = [SFFriendEntity demoData];
            }
        });
    }
    return _user;
}

static SFApplication *_application;
+(id)defaultApplication{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _application = [SFApplication alloc];
    });
    return _application;
}

/**
 *  心跳管理器
 */
static SFHeartManager *_heartManager;
+(id)defaultHeartManger{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _heartManager = [[SFHeartManager alloc]initWithSelf:[SFApplication defoultSystemUser]];
    });
    return _heartManager;
}

@end
