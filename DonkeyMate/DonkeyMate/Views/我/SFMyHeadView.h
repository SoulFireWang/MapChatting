//
//  SFAboutMeTableViewCell.h
//  DonkeyMate
//
//  Created by tarena on 15/11/1.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFPersonEnity.h"
#import "SFPersonTableViewCell.h"

#define CUSTOM_TABLE_CELL_STYLE_ME @"SFMyHeadView"

typedef void(^PersoEditBlock)(SFPersonEnity *person);

@interface SFMyHeadView : UITableViewCell

@property (nonatomic, copy)PersoEditBlock personEditBlock;

@property (nonatomic, strong) SFPersonEnity *person;

+(id)myHeadViewWithPerson:(SFPersonEnity *)person;


@end
