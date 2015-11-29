//
//  SFAnnotationView.m
//  DonkeyMate
//
//  Created by tarena on 15/11/9.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFAnnotationView.h"
#import "SFPersonHeadView.h"
#import "SFAnnotationEntity.h"

@interface SFAnnotationView()

@property (nonatomic, strong) SFPersonHeadView *personHeadView;

@end

@implementation SFAnnotationView


-(void)setPerson:(SFPersonEnity *)person{
    if (_personHeadView == nil) {
        _personHeadView = [[SFPersonHeadView alloc]initWithPerson:person];
        [self addSubview:_personHeadView];
    }
    else{
        [_personHeadView setPerson:person];
    }
}

@end
