//
//  SFPersonEnity.m
//  DonkeyMate
//
//  Created by tarena on 15/10/29.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFPersonEnity.h"

@implementation SFPersonEnity
- (NSMutableArray *)chattingContent {
    if(_chattingContent == nil) {
        _chattingContent = [[NSMutableArray alloc] init];
    }
    return _chattingContent;
}
@end
