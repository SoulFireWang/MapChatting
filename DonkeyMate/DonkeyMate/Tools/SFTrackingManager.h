//
//  SFTrackingManager.h
//  DonkeyMate
//
//  Created by tarena on 15/11/10.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

/**
 *  轨迹追踪管理器
 */
@interface SFTrackingManager : NSObject

-(id)initWithMapView:(BMKMapView *)mapView;

//开始路径追踪
-(void)startTrackingWithTrackingFile:(NSString *)filePath;

//清空最总路径
-(void)endTracking;

/**
 *  获得路径文件列表
 *
 *  @return 路劲文件列表
 */
+(NSArray *)trackingFiles;

+(BOOL)saveTrackingWithName:(NSString *)fileName andData:(NSData *)data;


@end
