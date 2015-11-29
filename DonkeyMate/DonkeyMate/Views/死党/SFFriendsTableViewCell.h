//
//  SFFriendsTableViewCell.h
//  DonkeyMate
//
//  Created by tarena on 15/11/3.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CUSTOM_TABLE_CELL_STYLE_FRIENDS @"SFFriendsTableViewCell"


@interface SFFriendsTableViewCell : UITableViewCell
/**
 *  照片
 */
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
/**
 *  姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/**
 *  个性签名
 */
@property (weak, nonatomic) IBOutlet UILabel *signLabel;




@end
