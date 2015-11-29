//
//  SFFriendTableViewCell.m
//  DonkeyMate
//
//  Created by tarena on 15/11/13.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFMapFriendTableViewCell.h"
#import "SFPersonHeadView.h"

@interface SFMapFriendTableViewCell()

@property (nonatomic, strong)SFPersonHeadView *headView;

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
    
    self.layer.cornerRadius = 3;
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.headView];
    self.textLabel.text = [NSString stringWithFormat:@"       %@", person.name];
    
    self.detailTextLabel.text = (NSString *)person.chattingContent.lastObject;
}

@end
