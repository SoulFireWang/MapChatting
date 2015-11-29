//
//  SFAnnotationView.h
//  DonkeyMate
//
//  Created by tarena on 15/11/9.
//  Copyright (c) 2015年 tarena. All rights reserved.
//


#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "SFPersonEnity.h"

@interface SFAnnotationView : BMKPinAnnotationView

@property (nonatomic, strong) SFPersonEnity *person;

@end
