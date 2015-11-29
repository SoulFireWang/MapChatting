//
//  SFFriendsView.h
//  DonkeyMate
//
//  Created by tarena on 15/11/7.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFFriendsView : UIView
/**
 *  个人照片
 */
@property (weak, nonatomic) IBOutlet UIImageView *personImage;

/**
 *  个人签名
 */
@property (weak, nonatomic) IBOutlet UILabel *sign;

@end
