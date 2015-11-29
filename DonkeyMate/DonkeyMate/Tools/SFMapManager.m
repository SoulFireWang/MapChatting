//
//  SFAnimationViewManager.m
//  DonkeyMate
//
//  Created by tarena on 15/11/5.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "SFMapManager.h"
#import "UIImageView+WebCache.h"
#import "SFPersonHeadView.h"
#import "SFPersonEnity.h"
#import "SFAnnotationView.h"
#import "SFApplication.h"

#define pi 3.14159265358979323846
#define radiansToDegrees(x) (180.0 * x / pi)

@implementation SFMapManager

+(id)annotationViewWithAnnotiation:(SFAnnotationEntity *)annotation andBMKMap:(BMKMapView *)mapView{
    
    NSString *AnnotationViewID = @"renameMark";
    
    //重用获取
    SFAnnotationView *annotationView = (SFAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    //如果没有实力对象，就生成
    if (annotationView == nil) {
        annotationView = [[SFAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    
    annotationView.annotation = annotation;
    
    // 设置颜色
    annotationView.pinColor = BMKPinAnnotationColorPurple;
    
    //4.手动设置属性才可以点中弹出框
    annotationView.canShowCallout = YES;
    annotationView.animatesDrop = NO;
    
    //7.设置任务视图
    [annotationView setPerson:annotation.person];
    
    return annotationView;
}


+(void)adjustRotationWithLeftPerson:(SFPersonEnity *)leftPerson andRightPerson:(SFPersonEnity *)rightPerson andMapView:(BMKMapView *)mapView{
    //计算夹角
    CLLocationDegrees originalLatitudeDistance =  rightPerson.coordinate.latitude - leftPerson.coordinate.latitude;
    CLLocationDegrees originalLongitudeDistance = rightPerson.coordinate.longitude - leftPerson.coordinate.longitude;
    CGFloat rads = atan(originalLatitudeDistance/originalLongitudeDistance);
    int angle = radiansToDegrees(rads);
    
    mapView.rotation = -angle;
    
    NSLog(@"previous rotation: %d, current rotation: %d", mapView.rotation, angle);
}

+(void)adjustRegionNoKeyBoardWithLeftPerson:(SFPersonEnity *)leftPerson andRightPerson:(SFPersonEnity *)rightPerson andMapView:(BMKMapView *)mapView andLocationService:(BMKLocationService *) locService{
    
    //计算维度差值
    CLLocationDegrees latitudeDistance = fabs(leftPerson.coordinate.latitude - rightPerson.coordinate.latitude);
    CLLocationDegrees longitudeDistance = fabs(leftPerson.coordinate.longitude - rightPerson.coordinate.longitude);
    
    BMKCoordinateSpan span;
    span.latitudeDelta = latitudeDistance *5 / 2;
    span.longitudeDelta = longitudeDistance * 5 / 2;
    BMKCoordinateRegion region;
    
    CLLocationCoordinate2D locationCenter = CLLocationCoordinate2DMake((rightPerson.coordinate.latitude + leftPerson.coordinate.latitude)/2, (rightPerson.coordinate.longitude + leftPerson.coordinate.longitude)/2);
    region.center = locationCenter;
    region.span = span;
    
    [locService stopUserLocationService];
    mapView.showsUserLocation = NO;//先关闭显示的定位图层
    mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    mapView.showsUserLocation = YES;//显示定位图层
    [mapView setRegion:region animated:YES];
}

+(void)adjustRegionHaveKeyBoardWithLeftPerson:(SFPersonEnity *)leftPerson andRightPerson:(SFPersonEnity *)rightPerson andMapView:(BMKMapView *)mapView andLocationService:(BMKLocationService *) locService{
    //计算维度差值
    CLLocationDegrees latitudeDistance = fabs(leftPerson.coordinate.latitude - rightPerson.coordinate.latitude);
    CLLocationDegrees longitudeDistance = fabs(leftPerson.coordinate.longitude - rightPerson.coordinate.longitude);
    float distance = sqrt(latitudeDistance * latitudeDistance + longitudeDistance * longitudeDistance );
    
    BMKCoordinateSpan span;

    span.latitudeDelta = latitudeDistance *5 / 2;
    span.longitudeDelta = longitudeDistance * 5 / 2;
    BMKCoordinateRegion region;
    
    CLLocationCoordinate2D locationCenter = CLLocationCoordinate2DMake((rightPerson.coordinate.latitude + leftPerson.coordinate.latitude)/2 - distance, (rightPerson.coordinate.longitude + leftPerson.coordinate.longitude)/2);
    region.center = locationCenter;
    region.span = span;
    
    [locService stopUserLocationService];
    mapView.showsUserLocation = NO;//先关闭显示的定位图层
    mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    mapView.showsUserLocation = YES;//显示定位图层
    [mapView setRegion:region animated:YES];
}

+(void)adjustRegionHaveKeyBoardWithPerson:(SFPersonEnity *)Person andMapView:(BMKMapView *)mapView andLocationService:(BMKLocationService *) locService{
    //计算维度差值

    BMKCoordinateRegion region = mapView.region;
    
    CLLocationCoordinate2D locationCenter = CLLocationCoordinate2DMake(region.center.latitude, region.center.longitude + region.span.longitudeDelta / 5 * 4);
    region.center = locationCenter;
    
    [locService stopUserLocationService];
    mapView.showsUserLocation = NO;//先关闭显示的定位图层
    mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    mapView.showsUserLocation = YES;//显示定位图层
    [mapView setRegion:region animated:YES];
    
    //计算所要移动的距离
    
    
    //屏幕坐标和点之间的转换
    
}

/**
 *  视图调整：有键盘群聊
 *  发言人可见
 *  @param speaker 发言人
 */
+(void)adjustRegionForKeyboardOnAndGourpChattingWithSpeaker:(NSArray *)persons andMapView:(BMKMapView *)mapView andLocationService:(BMKLocationService *) locService{
//    //发言者出现在键盘上方中心位置， 显示的经纬度范围不做改变
//    
//    //计算平移距离
//    CLLocationDegrees moveDistance = MIN(mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta)* 3 / 10;
//    
//    //计算新的中心点位置
//    BMKCoordinateRegion region = mapView.region;
//    CLLocationCoordinate2D center;
//    center.latitude = speaker.coordinate.latitude;
//    center.longitude = speaker.coordinate.longitude;
//    region.center = center;
//    region.center.latitude -= moveDistance;
//    
//    
//    
//    //设置地图显示范围
////    [mapView setRegion:region];
//
    if(persons == nil || persons.count == 0){
        return;
    }
    
    SFPersonEnity *person = (SFPersonEnity*)[persons objectAtIndex:0];
    
    CLLocationDegrees maxLatitude = person.coordinate.latitude;
    CLLocationDegrees minLatitude = person.coordinate.latitude;
    CLLocationDegrees maxLongitude = person.coordinate.longitude;
    CLLocationDegrees minLongitude = person.coordinate.longitude;
    
    for (SFPersonEnity *person in persons) {
        if (maxLatitude < person.coordinate.latitude) {
            maxLatitude = person.coordinate.latitude;
        }
        
        if (minLatitude > person.coordinate.latitude) {
            minLatitude = person.coordinate.latitude;
        }
        
        if (maxLongitude < person.coordinate.longitude) {
            maxLongitude = person.coordinate.longitude;
        }
        
        if (minLongitude > person.coordinate.longitude) {
            minLongitude = person.coordinate.longitude;
        }
    }
    
    //设置中心
    CLLocationCoordinate2D center;
    center.latitude = (maxLatitude + minLatitude) / 2;
    center.longitude = (maxLongitude + minLongitude) / 2;
    
    BMKCoordinateRegion region;
    BMKCoordinateSpan span;
    span.latitudeDelta = (maxLatitude - minLatitude) * 6;
    span.longitudeDelta = (maxLongitude - minLongitude) * 6;
    
    center.latitude -= span.longitudeDelta/3;
    
    region.span = span;
    region.center = center;
    
    [mapView setRegion:region];
}

/**
 *  视图调整：有键盘单聊
 *  发言人可见
 *
 *  @param speaker 发言人
 */
+(void)adjustRegionForKeyboardOnAndSingleChattingWithSpeaker:(SFPersonEnity *)speaker andMapView:(BMKMapView *)mapView andLocationService:(BMKLocationService *) locService{
    
    BMKCoordinateRegion region = mapView.region;
    
    //设置中心
    CLLocationCoordinate2D center;
    center.latitude = speaker.coordinate.latitude;
    center.longitude = speaker.coordinate.longitude;
    
    center.latitude -= region.span.latitudeDelta / 5;
    
    region.center = center;
    
    [mapView setRegion:region];
}

/**
 *  视图调整：没有键盘群聊
 *  视图上所有人可见
 *
 *  @param persons 所有在线人
 */
+(void)adjustRegionForKeyboardOffAndGroupChattingWithSpeaker:(NSArray *)persons andMapView:(BMKMapView *)mapView andLocationService:(BMKLocationService *) locService{

    if(persons == nil || persons.count == 0){
        return;
    }
    
    SFPersonEnity *person = (SFPersonEnity*)[persons objectAtIndex:0];
    
    CLLocationDegrees maxLatitude = person.coordinate.latitude;
    CLLocationDegrees minLatitude = person.coordinate.latitude;
    CLLocationDegrees maxLongitude = person.coordinate.longitude;
    CLLocationDegrees minLongitude = person.coordinate.longitude;
    
    for (SFPersonEnity *person in persons) {
        if (maxLatitude < person.coordinate.latitude) {
            maxLatitude = person.coordinate.latitude;
        }
        
        if (minLatitude > person.coordinate.latitude) {
            minLatitude = person.coordinate.latitude;
        }
        
        if (maxLongitude < person.coordinate.longitude) {
            maxLongitude = person.coordinate.longitude;
        }
        
        if (minLongitude > person.coordinate.longitude) {
            minLongitude = person.coordinate.longitude;
        }
    }
    
    //设置中心
    CLLocationCoordinate2D center;
    center.latitude = (maxLatitude + minLatitude) / 2;
    center.longitude = (maxLongitude + minLongitude) / 2;
    
    BMKCoordinateRegion region;
    BMKCoordinateSpan span;
    span.latitudeDelta = (maxLatitude - minLatitude) * 5 / 2;
    span.longitudeDelta = (maxLongitude - minLongitude) * 5 / 2;
    
    region.span = span;
    region.center = center;
    
    [mapView setRegion:region];
}

/**
 *  视图调整：没有键盘单聊
 *  我可发言人可见
 *
 *  @param speaker 发言人
 */
+(void)adjustRegionForKeyboardOffAndSingleChattingWithSpeaker:(SFPersonEnity *)speaker andMapView:(BMKMapView *)mapView andLocationService:(BMKLocationService *) locService{
#warning TODO TESTING    
    
    //设置中心
    CLLocationCoordinate2D center;
    center.latitude = speaker.coordinate.latitude;
    center.longitude = speaker.coordinate.longitude;
    
    BMKCoordinateRegion region = mapView.region;
    BMKCoordinateSpan span;
    span.latitudeDelta = 0.001;
    span.longitudeDelta = 0.001;
    region.span = span;
    region.center = center;
    [mapView setRegion:region];
    
}

@end

