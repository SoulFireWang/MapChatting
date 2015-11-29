//
//  SFAnnotationEntity.h
//  DonkeyMate
//
//  Created by tarena on 15/10/31.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "SFPersonEnity.h"

#define ANNOTATION_TYPE_SFANNOTATION_ENTITY @"ANNOTATION_TYPE_SFANNOTATION_ENTITY"

@interface SFAnnotationEntity : NSObject<BMKAnnotation>

///标注view中心坐标.
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/**
 *获取annotation标题
 *@return 返回annotation的标题信息
 */
@property (nonatomic, strong) NSString *title;

/**
 *获取annotation副标题
 *@return 返回annotation的副标题信息
 */
@property (nonatomic, strong) NSString *subtitle;

/**
 *  人实例
 */
@property (nonatomic, strong) SFPersonEnity *person;


@end
