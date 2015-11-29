//
//  SFDataMetalTool.m
//  DonkeyMate
//
//  Created by tarena on 15/11/11.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFDataMetalTool.h"
#import <UIKit/UIKit.h>
#import <objc/objc-runtime.h>

@implementation SFDataMetalTool

+(NSDictionary *)object2JsonWithObject:(NSObject *)object andClass:(Class) objectClass{

    //获得属性列表
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(objectClass, &outCount);
    NSMutableArray *propertys = [NSMutableArray arrayWithCapacity:outCount];
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [propertys addObject:propertyName];
    }
    
    NSMutableDictionary *jsonDic = [NSMutableDictionary dictionary];
    
    for (NSString *key in propertys) {

        NSObject *value = [object valueForKey:key];
        
        if (value == nil) {
            continue;
        }
        
        [jsonDic setObject:value forKey:key];
    }
    
    return [jsonDic copy];
    
}

@end
