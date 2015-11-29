//
//  SFCommucationTool.h
//  DonkeyMate
//
//  Created by tarena on 15/10/29.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "SFPersonEnity.h"
#import "SFMessageEntity.h"
#import "SFConstants.h"

#define NOTIFICATION_COMMUNICATION_RECEIVE @"NOTIFICATION_COMMUNICATION"
#define NOTIFICATION_COMMUNICATION_RECEIVE_MESSAGE @"NOTIFICATION_COMMUNICATION_RECEIVE_MESSAGE"
#define NOTIFICATION_COMMUNICATION_RECEIVE_PERSON @"NOTIFICATION_COMMUNICATION_RECEIVE_PERSON"

@interface SFCommucationTool : NSObject

/**
 *  通过person和message实体类生成通讯命令
 *
 *  @param person  消息发送人
 *  @param message 消息信息
 *
 *  @return 通讯命令
 */
+(NSData *)getCommunicationCommandWithPerson:(SFPersonEnity *)person andMessage:(SFMessageEntity *)message;

/**
 *  通过通讯命令解析出消息发送人
 *
 *  @param communicationMessage 通讯命令
 *
 *  @return 消息发送人
 */
+(SFPersonEnity *)getPersonWithCommunicationMessage:(NSData *)communicationMessage;

/**
 *  通过通讯命令解析出消息
 *
 *  @param communicationMessage 通讯命令
 *
 *  @return 消息内容
 */
+(SFMessageEntity *)getMessageWithCommunicationMessage:(NSData *)communicationMessage;

/**
 *  获得通讯对象单例(线程保护)
 *
 *  @return 通讯对象单例
 */
+(id)sharedAsyCommunictionSocket;

/**
 *  连接到主机
 *
 *  @param ipAddress 主机ip地址
 *  @param person    连接人详细信息
 */
-(void)connectToHostWithIpAddress:(NSString *)ipAddress andPerson:(SFPersonEnity *)person;

/**
 * 发送消息
 *
 *  @param message 消息内容
 *  @param person  发送人信息
 */
- (void)sendMessageWithMessage:(NSString *)message andPerson:(SFPersonEnity *)person;

/**
 *  发送消息
 *
 *  @param message 消息实体对象
 *  @param person  消息发送人
 */
- (void)sendMessageWithMessageEntity:(SFMessageEntity *)message andPerson:(SFPersonEnity *)person;

@end
