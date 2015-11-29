//
//  SFMessageEntity.h
//  DonkeyMate
//
//  Created by tarena on 15/10/29.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFBaseEntity.h"

@interface SFMessageEntity : SFBaseEntity

@property(nonatomic, strong)NSString *content;


+(id)messageWithContent:(NSString *)content;

@end
