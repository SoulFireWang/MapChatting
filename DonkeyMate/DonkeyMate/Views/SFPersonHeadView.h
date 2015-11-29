//
//  SFPersonHeadView.h
//  DonkeyMate
//
//  Created by tarena on 15/11/9.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFPersonEnity.h"

typedef void(^ClickHeadBlock)(void);

@interface SFPersonHeadView : UIView

@property (nonatomic, strong) ClickHeadBlock clickHeadBlock;

/**
 *  用户对象
 */
@property (nonatomic, strong)SFPersonEnity *person;

-(id)initWithPerson:(SFPersonEnity *)person;

-(id)initWithPerson:(SFPersonEnity *)person andWidth:(NSInteger)width;

-(id)initWithImage:(NSString *)image andWidth:(NSInteger)width;

/**
 *  是否显示姓名
 *
 *  @param isShowName YES显示姓名， NO不现实姓名
 */
-(void)isShowName:(BOOL)isShowName;

- (void)btnHeadImageClick:(UIButton *)button;

@end
