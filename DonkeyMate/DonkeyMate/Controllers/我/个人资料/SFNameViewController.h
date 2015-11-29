//
//  SFNameViewController.h
//  DonkeyMate
//
//  Created by tarena on 15/11/15.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NOTIFICATION_UPDATE_PERSON_NAME @"NOTIFICATION_UPDATE_PERSON_NAME"

@interface SFNameViewController : UIViewController
/**
 *  姓名
 */
@property (nonatomic, strong)NSString *name;
@end
