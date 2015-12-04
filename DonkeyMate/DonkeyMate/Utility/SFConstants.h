//
//  SFConstants.h
//  DonkeyMate
//
//  Created by tarena on 15/10/30.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**************系统***************/
#define CURRENT_USER [SFApplication defoultSystemUser]//当前用户
#define WeakSelf(weakSelf) __weak __typeof(&*self)weakSelf = self;//对象弱引用设置
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width//屏幕长度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height//屏幕宽度


/**************主题色***************/
//主题色
#define THEME_COLOR [UIColor colorWithRed:0.709804 green:0.784314 blue:0.917647 alpha:0.1]


/**************服务器配置**************/
//服务器地址
#define SERVICE_IP_ADDRESS @"192.168.5.129"
//服务器端口
#define SERVICE_IP_PORT 1042
//命令标示符
#define COMMAND_SPERAOTR @"%soulfirewangiscool%"

/*********尺寸设置*********/
#define LENGTH_HEAD_VIEW 44 //头视图
#define LENGTH_HEAD_SPACE (LENGTH_HEAD_VIEW + 5) //头视图所需要的空间
#define LENGTH_INPUT_LENTGTH (Main_Screen_Width - LENGTH_HEAD_SPACE - 5 - 20) //输入框长度

#define HEIGHT_ONLINE_PERSON_TABLE_CELL 70//单元格长度

/**************路径文件**************/
//路径文件路劲
#define FILE_PATH_TRACKING [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject] stringByAppendingPathComponent:@"Trackings"]

/**************轨迹追踪***************/
//轨迹文件后缀名
#define EXTENSION_TRACKING @"tracking"

/**************心跳管理***************/
//心跳间隔
#define HEART_INTERVAL 4


