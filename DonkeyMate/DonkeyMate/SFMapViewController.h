//
//  ViewController.h
//  DonkeyMate
//
//  Created by tarena on 15/10/28.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface SFMapViewController : UIViewController<BMKMapViewDelegate, BMKLocationServiceDelegate>

@property (strong, nonatomic) IBOutlet BMKMapView *mapView;

@end