//
//  SFMessageEntity.m
//  DonkeyMate
//
//  Created by tarena on 15/10/29.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFMessageEntity.h"

@implementation SFMessageEntity

+(id)messageWithContent:(NSString *)content{
    SFMessageEntity *message = [SFMessageEntity new];
    message.content = content;
    return message;
}

@end
