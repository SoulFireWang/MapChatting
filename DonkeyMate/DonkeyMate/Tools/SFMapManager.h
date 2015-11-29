//
//  SFAnimationViewManager.h
//  DonkeyMate
//
//  Created by tarena on 15/11/5.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "SFAnnotationEntity.h"

@interface SFMapManager : NSObject

/**
 *  根据annotation对象获取annotationView对象
 *
 *  @param annotation annotation
 *  @param mapView    百度地图
 *
 *  @return annotationView对象
 */
+(id)annotationViewWithAnnotiation:(SFAnnotationEntity *)annotation andBMKMap:(BMKMapView *)mapView;

#pragma mark --- 地图显示区域调整

//地图朝向
+(void)adjustRotationWithLeftPerson:(SFPersonEnity *)leftPerson andRightPerson:(SFPersonEnity *)rightPerson andMapView:(BMKMapView *)mapView;

//没有键盘的显示区域调整
+(void)adjustRegionNoKeyBoardWithLeftPerson:(SFPersonEnity *)leftPerson andRightPerson:(SFPersonEnity *)rightPerson andMapView:(BMKMapView *)mapView andLocationService:(BMKLocationService *) locService;

//键盘弹出时的显示区域调整
+(void)adjustRegionHaveKeyBoardWithLeftPerson:(SFPersonEnity *)leftPerson andRightPerson:(SFPersonEnity *)rightPerson andMapView:(BMKMapView *)mapView andLocationService:(BMKLocationService *) locService;

//键盘弹出时的显示区域调整，发言显示
+(void)adjustRegionHaveKeyBoardWithPerson:(SFPersonEnity *)Person andMapView:(BMKMapView *)mapView andLocationService:(BMKLocationService *) locService;

/**
 *  视图调整：有键盘群聊
 *  发言人可见
 *  @param speaker 发言人
 */
+(void)adjustRegionForKeyboardOnAndGourpChattingWithSpeaker:(NSArray *)persons andMapView:(BMKMapView *)mapView andLocationService:(BMKLocationService *) locService;

/**
 *  视图调整：有键盘单聊
 *  发言人可见
 *
 *  @param speaker 发言人
 */
+(void)adjustRegionForKeyboardOnAndSingleChattingWithSpeaker:(SFPersonEnity *)speaker andMapView:(BMKMapView *)mapView andLocationService:(BMKLocationService *) locService;

/**
 *  视图调整：没有键盘群聊
 *  视图上所有人可见
 *
 *  @param persons 所有在线人
 */
+(void)adjustRegionForKeyboardOffAndGroupChattingWithSpeaker:(NSArray *)persons andMapView:(BMKMapView *)mapView andLocationService:(BMKLocationService *) locService;

/**
 *  视图调整：没有键盘单聊
 *  我可发言人可见
 *
 *  @param speaker 发言人
 */
+(void)adjustRegionForKeyboardOffAndSingleChattingWithSpeaker:(SFPersonEnity *)speaker andMapView:(BMKMapView *)mapView andLocationService:(BMKLocationService *) locService;

@end
