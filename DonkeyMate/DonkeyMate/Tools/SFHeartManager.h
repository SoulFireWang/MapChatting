//
//  SFGroupManager.h
//  DonkeyMate
//
//  Created by tarena on 15/11/11.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFPersonEnity.h"
#import "SFMessageEntity.h"

//下线
typedef void(^PersonOffLineBlock)(SFPersonEnity *person);

//上线
typedef void(^PersonOnLineBlock)(SFPersonEnity *person);

//位置更新
typedef void(^PersonLocationUpgradeBlock)(SFPersonEnity *person);

//发言
typedef void(^PersonTalkingBlock)(SFPersonEnity *person);


/**
 *  心跳管理器理器
 */
@interface SFHeartManager : NSObject

/**
 *  监听间隔
 */
@property (nonatomic, assign)NSTimeInterval interval;

/**
 *  是否正在监听
 */
@property (nonatomic, readonly, assign)BOOL isMonitorOn;

/**
 *  是否蒸菜发送心跳
 */
@property (nonatomic, readonly, assign)BOOL isHeartOn;

/**
 *  在线朋友
 */
@property (nonatomic, readonly, strong)NSArray *friendsOnline;

/**
 *  初始化群聊监视器
 *
 *  @param mySelf 我自己
 *
 *  @return 群聊人员管理器
 */
-(id)initWithSelf:(SFPersonEnity *)mySelf;

/**
 *  初始化群聊监视器
 *
 *  @param mySelf             我自己
 *  @param personOffLineBlock 当有人下线时采取的操作
 *  @param personOffLineBlock 当有人上线时采取的操作
 *
 *  @return 群聊人员管理器
 */
-(id)initWithWithSelf:(SFPersonEnity *)mySelf andPersonOnLine:(PersonOnLineBlock)personOnLineBlock andPersonOffLine:(PersonOffLineBlock)personOffLineBlock andPersonLocationUpgrade:(PersonLocationUpgradeBlock)presonLocationUpgrade;

/**
 *  配置Block
 *
 *  @param personOnLineBlock     上线处理
 *  @param personOffLineBlock    下线处理
 *  @param presonLocationUpgrade 位置更新处理
 *
 */
-(void)setBlockPersonOnLine:(PersonOnLineBlock)personOnLineBlock andPersonOffLine:(PersonOffLineBlock)personOffLineBlock andPersonLocationUpgrade:(PersonLocationUpgradeBlock)presonLocationUpgrade;

/**
 *  配置Block
 *
 *  @param personOnLineBlock     上线处理
 *  @param personOffLineBlock    下线处理
 *  @param presonLocationUpgrade 位置更新处理
 *
 */
-(void)setBlockPersonOnLine:(PersonOnLineBlock)personOnLineBlock andPersonOffLine:(PersonOffLineBlock)personOffLineBlock andPersonLocationUpgrade:(PersonLocationUpgradeBlock)presonLocationUpgrade andPersonTalking:(PersonTalkingBlock)personTalking;

/**
 *  开启监听
 */
-(void)startMonitor;

/**
 *  结束监听
 */
-(void)stopMonitor;

/**
 *  开始心跳
 */
-(void)startHeart;

/**
 *  停止心跳
 */
-(void)stopHeart;

/**
 *  监听某对象
 *
 *  @param person 被监听人
 */
-(void)listenWithPerson:(SFPersonEnity *)person;

/**
 *  监听某对象
 *
 *  @param person  被监听人
 *  @param content 监听聊天内容
 */
-(void)listenWithPerson:(SFPersonEnity *)person andContent:(NSString *)content;

/**
 *  判断是否为心跳消息
 *
 *  @param message 发过来的消息
 *
 *  @return YES 是心跳， NO不是
 */
-(BOOL)isHeartPopWithMessage:(SFMessageEntity *)message;

@end
