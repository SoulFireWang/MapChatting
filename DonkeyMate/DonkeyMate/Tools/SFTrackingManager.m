//
//  SFTrackingManager.m
//  DonkeyMate
//
//  Created by tarena on 15/11/10.
//  Copyright (c) 2015年 tarena. All rights reserved.
//
#import "SFTrackingManager.h"
#import "Tracking.h"
#import "SFConstants.h"


@interface SFTrackingManager ()<BMKMapViewDelegate, TrackingDelegate>

@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, strong) Tracking *tracking;

//路径文件路径
@property (nonatomic, strong) NSString *filePath;

@end

@implementation SFTrackingManager


-(id)initWithMapView:(BMKMapView *)mapView{
    if (self = [super init]) {
        self.mapView = mapView;
        self.mapView.delegate = self;
    }
    return self;
}

//开始路径追踪
-(void)startTrackingWithTrackingFile:(NSString *)filePath{
    
    self.filePath = filePath;
    
    if (self.tracking == nil)
    {
        [self setupTracking];
    }
    
    [self.tracking execute];
}

-(void)endTracking{
    
}

#pragma mark - TrackingDelegate

- (void)willBeginTracking:(Tracking *)tracking
{
    NSLog(@"%s", __func__);
}

- (void)didEndTracking:(Tracking *)tracking
{
    NSLog(@"%s", __func__);
}


#pragma mark - MAMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if (annotation == self.tracking.annotation)
    {
        static NSString *trackingReuseIndetifier = @"trackingReuseIndetifier";
        
        BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:trackingReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:trackingReuseIndetifier];
        }
        
        annotationView.canShowCallout = NO;
        annotationView.image = [UIImage imageNamed:@"ball"];
        
        return annotationView;
    }
    
    return nil;
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if (overlay == self.tracking.polyline)
    {
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 4.f;
        polylineView.strokeColor = [UIColor redColor];
        return polylineView;
    }
    
    return nil;
}

#pragma mark - Handle Action

- (void)handleRunAction
{
    if (self.tracking == nil)
    {
        [self setupTracking];
    }
    
    [self.tracking execute];
}

#pragma mark - Setup

/* 构建轨迹回放. */
- (void)setupTracking
{
    
    NSString *trackingFilePath = [NSString stringWithFormat:@"%@.%@", [FILE_PATH_TRACKING stringByAppendingPathComponent:self.filePath], EXTENSION_TRACKING];
    
    NSLog(@"%@", trackingFilePath);
    NSData *trackingData = [NSData dataWithContentsOfFile:trackingFilePath];
    
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D *)malloc(trackingData.length);
    
    /* 提取轨迹原始数据. */
    [trackingData getBytes:coordinates length:trackingData.length];
    
    /* 构建tracking. */
    self.tracking = [[Tracking alloc] initWithCoordinates:coordinates count:trackingData.length / sizeof(CLLocationCoordinate2D)];
    self.tracking.delegate = self;
    self.tracking.mapView  = self.mapView;
    self.tracking.duration = 5.f;
    self.tracking.edgeInsets = UIEdgeInsetsMake(50, 50, 50, 50);
}

+(NSArray *)trackingFiles{
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsAtPath:FILE_PATH_TRACKING];
    NSMutableArray *filesMutableArray = [NSMutableArray array];
    for (NSString *filePath in filePathsArray) {
        NSLog(@"extension is %@", filePath.pathExtension);
        
        if ([filePath.pathExtension  isEqual: EXTENSION_TRACKING]) {
            [filesMutableArray addObject:[filePath stringByDeletingPathExtension]];
        }
    }

    return [filesMutableArray copy];
}


+(BOOL)saveTrackingWithName:(NSString *)fileName andData:(NSData *)data{
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:FILE_PATH_TRACKING]) {
        
        //如果文件不存在
        [[NSFileManager defaultManager]createDirectoryAtPath:FILE_PATH_TRACKING withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error) {
            NSLog(@"创建轨迹路径文件tracking失败%@", error.userInfo);
        }
        return NO;
    }
    NSString *filePath = [[FILE_PATH_TRACKING stringByAppendingPathComponent:fileName] stringByAppendingString:@".tracking"];
    
    [data writeToFile:filePath options:0 error:&error];
    if (error) {
        NSLog(@"创建轨迹路径文件%@失败%@", fileName, error.userInfo);
    }
    

    
    return YES;
}



@end
