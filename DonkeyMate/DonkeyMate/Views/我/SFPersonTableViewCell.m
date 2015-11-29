//
//  SFPersonTableViewCell.m
//  DonkeyMate
//
//  Created by tarena on 15/11/14.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFPersonTableViewCell.h"

@implementation SFPersonTableViewCell

-(void)setPerson:(SFPersonEnity *)person{
    _person = person;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
