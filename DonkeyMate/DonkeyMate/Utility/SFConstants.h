//
//  SFConstants.h
//  DonkeyMate
//
//  Created by tarena on 15/10/30.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**************服务器配置**************/
//服务器地址
#define SERVICE_IP_ADDRESS @"192.168.5.129"
//服务器端口
#define SERVICE_IP_PORT 1042
//命令标示符
#define COMMAND_SPERAOTR @"%soulfirewangiscool%"

/*********头像大小配置视图控制*********/
#define LENGTH_HEAD_VIEW 44 //头视图
#define LENGTH_HEAD_SPACE (LENGTH_HEAD_VIEW + 5) //头视图所需要的空间
#define LENGTH_INPUT_LENTGTH (Main_Screen_Width - LENGTH_HEAD_SPACE - 5 - 20) //输入框长度

/**************路径文件**************/
//路径文件路劲
#define FILE_PATH_TRACKING [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"Trackings"]

/**************轨迹追踪***************/
//轨迹文件后缀名
#define EXTENSION_TRACKING @"tracking"

/**************心跳管理***************/
//心跳间隔
#define HEART_INTERVAL 4

@interface SFConstants : NSObject

/**
 *  主题色
 *
 *  @return 返回主题色
 */
+(UIColor *)themeColor;

@end
