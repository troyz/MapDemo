//
//  AppDelegate.m
//  MapDemo
//
//  Created by iss110302000283 on 16/3/1.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface AppDelegate ()
{
    BMKMapManager *mapManager;
    BMKLocationService *locService;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UserLocationModel get] clear];
    
    // 要使用百度地图，请先启动BaiduMapManager
    mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [mapManager start:kBaiduMapKey generalDelegate:self];
    if (!ret)
    {
        NSLog(@"manager start failed!");
    }
    
    locService = [[BMKLocationService alloc] init];
    [self startLocation];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self stopLocation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self startLocation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self stopLocation];
}

#pragma mark BMKGeneralDelegate
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError)
    {
        NSLog(@"联网成功");
    }
    else
    {
        NSLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError)
    {
        NSLog(@"授权成功");
    }
    else
    {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    CLLocationCoordinate2D coor = userLocation.location.coordinate;
    
    UserLocationModel *locModel = [UserLocationModel get];
    if(locModel.lat == coor.latitude && locModel.lng == coor.longitude)
    {
        return;
    }
    else
    {
        locModel.lat = coor.latitude;
        locModel.lng = coor.longitude;
        [locModel save];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOCATION_UPDATED object:nil];
    }
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

- (void)startLocation
{
    [self stopLocation];
    
    locService.delegate = self;
    [locService startUserLocationService];
}

- (void)stopLocation
{
    locService.delegate = nil;
    [locService stopUserLocationService];
}
@end
