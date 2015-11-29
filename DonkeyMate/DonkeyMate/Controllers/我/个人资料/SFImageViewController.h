//
//  SFImageViewController.h
//  DonkeyMate
//
//  Created by tarena on 15/11/15.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NOTIFICATION_UPDATE_PERSON_IMAGE @"NOTIFICATION_UPDATE_PERSON_IMAGE"

@interface SFImageViewController : UIViewController

/**
 *  图像
 */
@property (nonatomic, strong) NSString *image;

@end
