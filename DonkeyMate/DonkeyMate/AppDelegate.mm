//
//  AppDelegate.m
//  BaiduMapSdkSrc
//
//  Created by baidu on 13-3-21.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "SFMapViewController.h"
#import "SFConstants.h"
#import "SFTrackingManager.h"
#import "SFHeartManager.h"
#import "SFApplication.h"
#import "SFCommucationTool.h"

#import "SFTestViewController.h"

//NAMESPACE_BAIDU_FRAMEWORK_USE

BMKMapManager* _mapManager;
@implementation AppDelegate

@synthesize window;

#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //启动地图
    [self startMap];
    
    //连接到聊天服务器
    [self connnectToService];
    
    //界面风格设置
    [self customTabbar];
    
    //测试
    [self test];
    
//    你说的开发
    
    return YES;
}

/**
 *  登陆
 */
-(void)Login{
    
}

-(void)customTabbar{
    [[UITabBar appearance]setTintColor:THEME_COLOR];
    [[UINavigationBar appearance] setBarTintColor:THEME_COLOR];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
}

//连接到聊天服务器
-(void)connnectToService{
    
    //连接到通讯服务器
    [[SFCommucationTool sharedAsyCommunictionSocket]connectToHostWithIpAddress:SERVICE_IP_ADDRESS andPerson:[SFApplication currentUser]];
    
}

-(void)startMap{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"lclfukYXl34OfjlGiNpyrwT0" generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

-(void)test{

    SFTestViewController *vc = [SFTestViewController new];

    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.rootViewController = vc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [BMKMapView willBackGround];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [BMKMapView didForeGround];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

@end
