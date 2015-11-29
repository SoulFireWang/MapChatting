//
//  SFAboutMeTableViewCell.m
//  DonkeyMate
//
//  Created by tarena on 15/11/1.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFMyHeadView.h"
#import "SFMyDetailTableViewController.h"

@interface SFMyHeadView()

/**
 *  头部视图
 */
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

/**
 *  姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/**
 *  心情
 */
@property (weak, nonatomic) IBOutlet UILabel *signLabel;



@end

@implementation SFMyHeadView

- (IBAction)click:(id)sender {
    
    self.personEditBlock(self.person);
    
}


+(id)myHeadViewWithPerson:(SFPersonEnity *)person{
    SFMyHeadView *myHeadView = [[[NSBundle mainBundle] loadNibNamed:CUSTOM_TABLE_CELL_STYLE_ME owner:nil options:nil] firstObject];
    
    [myHeadView setPerson:person];
    
    return myHeadView;
}

-(void)setPerson:(SFPersonEnity *)person{
    
//    super.person = person;
    
    self.headImageView.image = [UIImage imageNamed:person.imageURL];
    
    self.nameLabel.text = person.name;
    
    self.signLabel.text = person.sign;
    
    _person = person;
    
    self.layer.cornerRadius = 20;
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
