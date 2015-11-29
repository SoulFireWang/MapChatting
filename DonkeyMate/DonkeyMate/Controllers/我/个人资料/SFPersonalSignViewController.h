//
//  SFPersonalSignViewController.h
//  DonkeyMate
//
//  Created by tarena on 15/11/2.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NOTIFICATION_UPDATE_PERSON_SIGN @"NOTIFICATION_UPDATE_PERSON_SIGN"

@interface SFPersonalSignViewController : UIViewController
/**
 *  个性签名
 */
@property (nonatomic, strong)NSString *sign;
@end
