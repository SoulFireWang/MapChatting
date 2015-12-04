//
//  SFApplication.h
//  DonkeyMate
//
//  Created by tarena on 15/11/4.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFPersonEnity.h"
#import "SFHeartManager.h"

@interface SFApplication : NSObject

/**
 *  是否开启定位
 */
@property (nonatomic, assign)BOOL isLocateOn;

/**
 *  当前用户
 */
+(SFPersonEnity *)currentUser;


+(SFApplication *)defaultApplication;

/**
 *  群聊管理器
 *
 *  @return 系统默认群聊管理器对系那个
 */
+(SFHeartManager *)defaultHeartManger;

@end
