//
//  SFMyDetailTableViewController.h
//  DonkeyMate
//
//  Created by tarena on 15/11/1.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFPersonEnity.h"

#define NOTIFICATION_PERSONAL_DETAIL @"NOTIFICATION_PERSONAL_DETAIL"

@interface SFMyDetailTableViewController : UITableViewController

/**
 *  人实体类
 */
@property (nonatomic, strong)SFPersonEnity *person;


@end
