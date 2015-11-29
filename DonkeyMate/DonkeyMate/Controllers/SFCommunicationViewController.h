//
//  SFCommunicationViewController.h
//  DonkeyMate
//
//  Created by tarena on 15/10/29.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFPersonEnity.h"

@interface SFCommunicationViewController : UIViewController

/**
 *  连接到服务器
 *
 *  @param ipAddress 连接地址
 *  @param person  连接人描述信息
 */
-(void)connectToHostWithIpAddress:(NSString *)ipAddress andPerson:(SFPersonEnity *)person;



@end
