//
//  SFFriendTableViewCell.m
//  DonkeyMate
//
//  Created by tarena on 15/11/13.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFMapFriendTableViewCell.h"
#import "SFPersonHeadView.h"
#import "SFConstants.h"

#define SEPERATOR_WIDTH 5

@interface SFMapFriendTableViewCell()

@property (nonatomic, strong)SFPersonHeadView *headView;

@property (nonatomic, strong)UIView *backGroundView;

@end

@implementation SFMapFriendTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CUSTOM_TABLE_CELL_STYLE_FRIEND]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    return [super initWithCoder:aDecoder];
}

-(instancetype)init{
    return [super init];
}



-(void)setPerson:(SFPersonEnity *)person{
    
    super.person = person;
    
    SFPersonHeadView *headView = [[SFPersonHeadView alloc]initWithPerson:person];
    
    [self.headView removeFromSuperview];
    self.headView = headView;
    [self.headView isShowName:NO];
    
    CGRect contentViewRect = CGRectMake(0, SEPERATOR_WIDTH, self.frame.size.width, HEIGHT_ONLINE_PERSON_TABLE_CELL - SEPERATOR_WIDTH);
    
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 10;
    self.layer.masksToBounds = YES;
    
    self.contentView.frame = contentViewRect;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 5;
    [self.contentView addSubview:headView];

    self.textLabel.text = [NSString stringWithFormat:@"       %@", person.name];
    
    self.detailTextLabel.text = (NSString *)person.chattingContent.lastObject;
}

#pragma mark --- lazy loading

-(UIView *)backGroundView{
    if (_backGroundView==nil) {
        CGRect contentViewRect = CGRectMake(0, SEPERATOR_WIDTH, self.frame.size.width, HEIGHT_ONLINE_PERSON_TABLE_CELL - SEPERATOR_WIDTH);
        _backGroundView = [[UIView alloc]initWithFrame:contentViewRect];
        _backGroundView.backgroundColor = [UIColor whiteColor];
        _backGroundView.layer.cornerRadius = 5;
    }
    return _backGroundView;
}


@end
