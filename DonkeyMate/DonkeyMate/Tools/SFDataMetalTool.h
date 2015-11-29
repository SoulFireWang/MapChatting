//
//  SFDataMetalTool.h
//  DonkeyMate
//
//  Created by tarena on 15/11/11.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  数据工具管理类
 */
@interface SFDataMetalTool : NSObject

/**
 *  将实体类转换成json数据格式
 *
 *  @return
 */
+(NSDictionary *)object2JsonWithObject:(NSObject *)object andClass:(Class) entityClass;

@end
