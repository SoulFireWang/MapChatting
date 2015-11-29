//
//  SFInputText.m
//  DonkeyMate
//
//  Created by tarena on 15/11/9.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFInputText.h"
#import "UUMessageFrame.h"
#import "UIButton+AFNetworking.h"
#import "ACMacros.h"
#import "SFPersonHeadView.h"

@interface SFInputText()
@property (nonatomic, strong)UIView *headImageBackView;
@property (nonatomic, assign)BOOL isbeginVoiceRecord;
@property (nonatomic, strong) UILabel *placeHold;
@end

@implementation SFInputText

#define LENGTH_HEAD_VIEW 44 //头视图
#define LENGTH_HEAD_SPACE (LENGTH_HEAD_VIEW + 5) //头视图所需要的空间
#define LENGTH_INPUT_LENTGTH (Main_Screen_Width - LENGTH_HEAD_SPACE - 5 - 20) //输入框长度

-(id)initWithPerson:(SFPersonEnity *)person{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        
        //设置头部视图
        SFPersonHeadView *headView = [[SFPersonHeadView alloc]initWithPerson:person];
        [self addSubview:headView];
        
        //添加输入栏视图
        CGRect inputFrame = CGRectMake(LENGTH_HEAD_SPACE, 5, LENGTH_INPUT_LENTGTH, 40);
        UIView *inputView = [[UIView alloc]initWithFrame:inputFrame];
        inputView.backgroundColor = [UIColor whiteColor];
        inputView.layer.cornerRadius = 10;
        [self addSubview:inputView];
        
        //发送消息
        self.btnSendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnSendMessage.frame = CGRectMake(LENGTH_INPUT_LENTGTH-40, 5, 30, 30);
        self.isAbleToSendTextMessage = NO;
        [self.btnSendMessage setTitle:@"" forState:UIControlStateNormal];
        [self.btnSendMessage setBackgroundImage:[UIImage imageNamed:@"Chat_take_picture"] forState:UIControlStateNormal];
        self.btnSendMessage.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnSendMessage addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [inputView addSubview:self.btnSendMessage];
        
        //改变状态（语音、文字）
        self.btnChangeVoiceState = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnChangeVoiceState.frame = CGRectMake(5, 5, 30, 30);
        self.isbeginVoiceRecord = NO;
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_voice_record"] forState:UIControlStateNormal];
        self.btnChangeVoiceState.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnChangeVoiceState addTarget:self action:@selector(voiceRecord:) forControlEvents:UIControlEventTouchUpInside];
        [inputView addSubview:self.btnChangeVoiceState];
        
        //语音录入键
        self.btnVoiceRecord = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnVoiceRecord.frame = CGRectMake(70, 5, LENGTH_INPUT_LENTGTH-70*2, 30);
        self.btnVoiceRecord.hidden = YES;
        [self.btnVoiceRecord setBackgroundImage:[UIImage imageNamed:@"chat_message_back"] forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitleColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [self.btnVoiceRecord setTitle:@"Hold to Talk" forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitle:@"Release to Send" forState:UIControlStateHighlighted];
//        [self.btnVoiceRecord addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
//        [self.btnVoiceRecord addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
//        [self.btnVoiceRecord addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
//        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
//        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [inputView addSubview:self.btnVoiceRecord];
        
        //输入框
        self.TextViewInput = [[UITextView alloc]initWithFrame:CGRectMake(45, 5, LENGTH_INPUT_LENTGTH-2*45, 30)];
        self.TextViewInput.layer.cornerRadius = 4;
        self.TextViewInput.layer.masksToBounds = YES;
        self.TextViewInput.delegate = self;
        self.TextViewInput.layer.borderWidth = 1;
        self.TextViewInput.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        [inputView addSubview:self.TextViewInput];
        
        //输入框的提示语
        self.placeHold = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 30)];
        self.placeHold.text = @"说点啥......";
        self.placeHold.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
        [self.TextViewInput addSubview:self.placeHold];
        
        //分割线
        inputView.layer.borderWidth = 1;
        inputView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
    }
    return self;
}

-(void)btnHeadImageClick:(UIButton *)button{
    NSLog(@"点击头像");
}


@end
