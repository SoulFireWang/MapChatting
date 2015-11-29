//
//  SFInputText.h
//  DonkeyMate
//
//  Created by tarena on 15/11/9.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFPersonEnity.h"

/**
 *  聊天输入框
 */
@interface SFInputText : UIView

/**
 *  姓名
 */
@property (nonatomic, retain)UILabel *labelNum;

/**
 *  头像
 */
@property (nonatomic, retain)UIButton *btnHeadImage;

/**
 *  发送消息按钮
 */
@property (nonatomic, retain) UIButton *btnSendMessage;

@property (nonatomic, retain) UIButton *btnChangeVoiceState;

@property (nonatomic, assign) BOOL isAbleToSendTextMessage;

/**
 *  录音按钮
 */
@property (nonatomic, retain) UIButton *btnVoiceRecord;

/**
 *  文本输入按钮
 */
@property (nonatomic, retain) UITextView *TextViewInput;


-(id)initWithPerson:(SFPersonEnity *)person;

@end
