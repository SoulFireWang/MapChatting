//
//  SFPersonHeadView.m
//  DonkeyMate
//
//  Created by tarena on 15/11/9.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFPersonHeadView.h"
#import "SFConstants.h"
#import "UUMessageFrame.h"
#import "UIButton+AFNetworking.h"
#import "UIButton+WebCache.h"

@interface SFPersonHeadView()



@property (nonatomic, strong)UIView *headImageBackView;

/**
 *  头像
 */
@property (nonatomic, retain)UIButton *btnHeadImage;

/**
 *  姓名
 */
@property (nonatomic, retain)UILabel *labelNum;

/**
 *  宽度
 */
@property (nonatomic, assign)NSInteger imageWidth;


@end

@implementation SFPersonHeadView

-(id)initWithPerson:(SFPersonEnity *)person{
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.person = person;
        
        // 1、创建头像
        self.headImageBackView = [[UIView alloc]init];
        self.headImageBackView.layer.cornerRadius = 22;
        self.headImageBackView.layer.masksToBounds = YES;
        self.headImageBackView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        [self addSubview:self.headImageBackView];
        
        self.btnHeadImage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHeadImage.layer.cornerRadius = 20;
        self.btnHeadImage.layer.masksToBounds = YES;
        [self.btnHeadImage addTarget:self action:@selector(btnHeadImageClick:)  forControlEvents:UIControlEventTouchUpInside];
        [self.headImageBackView addSubview:self.btnHeadImage];
        
        self.headImageBackView.frame = CGRectMake(0, 0, ChatIconWH, ChatIconWH);
        self.btnHeadImage.frame = CGRectMake(2, 2, ChatIconWH-4, ChatIconWH-4);
        [self.btnHeadImage setBackgroundImage:[UIImage imageNamed:@"0"] forState:UIControlStateNormal];
//        [self.btnHeadImage setBackgroundImageForState:UIControlStateNormal withURL:self.person.imageURL];
        
        [self.btnHeadImage setBackgroundImage:[UIImage imageNamed:person.imageURL] forState:UIControlStateNormal];
        
        // 3、创建头像下标
        self.labelNum = [[UILabel alloc] init];
        self.labelNum.textColor = [UIColor grayColor];
        self.labelNum.textAlignment = NSTextAlignmentCenter;
        self.labelNum.font = ChatTimeFont;
        [self addSubview:self.labelNum];
        
        self.labelNum.text = self.person.name;
        self.labelNum.frame = CGRectMake(0, ChatIconWH + 3, ChatIconWH, 20);

    }
    return self;
}

-(id)initWithPerson:(SFPersonEnity *)person andWidth:(NSInteger) width{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.person = person;
        
        // 1、创建头像
        self.headImageBackView = [[UIView alloc]init];
        self.headImageBackView.layer.cornerRadius = 22;
        self.headImageBackView.layer.masksToBounds = YES;
        self.headImageBackView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        [self addSubview:self.headImageBackView];
        
        self.btnHeadImage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHeadImage.layer.cornerRadius = 20;
        self.btnHeadImage.layer.masksToBounds = YES;
        [self.btnHeadImage addTarget:self action:@selector(btnHeadImageClick:)  forControlEvents:UIControlEventTouchUpInside];
        [self.headImageBackView addSubview:self.btnHeadImage];
        
        self.headImageBackView.frame = CGRectMake(0, 0, width, width);
        self.btnHeadImage.frame = CGRectMake(2, 2, width-4, width-4);
        [self.btnHeadImage setBackgroundImage:[UIImage imageNamed:@"0"] forState:UIControlStateNormal];
        //        [self.btnHeadImage setBackgroundImageForState:UIControlStateNormal withURL:self.person.imageURL];
        
        [self.btnHeadImage setBackgroundImage:[UIImage imageNamed:person.imageURL] forState:UIControlStateNormal];
        
        // 3、创建头像下标
        self.labelNum = [[UILabel alloc] init];
        self.labelNum.textColor = [UIColor grayColor];
        self.labelNum.textAlignment = NSTextAlignmentCenter;
        self.labelNum.font = ChatTimeFont;
        [self addSubview:self.labelNum];
        
        self.labelNum.text = self.person.name;
        self.labelNum.frame = CGRectMake(0, width + 3, width, 20);
        
    }
    return self;
}

-(id)initWithImage:(NSString *)image andWidth:(NSInteger) width{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        
        // 1、创建头像
        self.headImageBackView = [[UIView alloc]init];
        self.headImageBackView.layer.cornerRadius = width / 2;
        self.headImageBackView.layer.masksToBounds = YES;
        self.headImageBackView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        [self addSubview:self.headImageBackView];
        
        self.btnHeadImage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHeadImage.layer.cornerRadius = (width - 4) / 2;
        self.btnHeadImage.layer.masksToBounds = YES;
        [self.btnHeadImage addTarget:self action:@selector(btnHeadImageClick:)  forControlEvents:UIControlEventTouchUpInside];
        [self.headImageBackView addSubview:self.btnHeadImage];
        
        self.headImageBackView.frame = CGRectMake(0, 0, width, width);
        self.btnHeadImage.frame = CGRectMake(2, 2, width-4, width-4);
        [self.btnHeadImage setBackgroundImage:[UIImage imageNamed:@"0"] forState:UIControlStateNormal];
        //        [self.btnHeadImage setBackgroundImageForState:UIControlStateNormal withURL:self.person.imageURL];
        
        [self.btnHeadImage setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        
//        // 3、创建头像下标
//        self.labelNum = [[UILabel alloc] init];
//        self.labelNum.textColor = [UIColor grayColor];
//        self.labelNum.textAlignment = NSTextAlignmentCenter;
//        self.labelNum.font = ChatTimeFont;
//        [self addSubview:self.labelNum];
//        
//        self.labelNum.text = self.person.name;
//        self.labelNum.frame = CGRectMake(0, width + 3, width, 20);
        
    }
    return self;
}


//头像点击
- (void)btnHeadImageClick:(UIButton *)button{
    if (self.clickHeadBlock != nil) {
        self.clickHeadBlock();
    }
}


-(void)isShowName:(BOOL)isShowName{
    if (isShowName) {
        self.labelNum.text = self.person.name;
    }else{
        self.labelNum.text = @"";
    }
}

-(void)setPerson:(SFPersonEnity *)person{
    _person = person;
    [self.btnHeadImage setBackgroundImage:[UIImage imageNamed:person.imageURL] forState:UIControlStateNormal];
    self.labelNum.text = person.name;
}

@end
