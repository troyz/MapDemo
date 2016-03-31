//
//  AppDelegate.h
//  MapDemo
//
//  Created by iss110302000283 on 16/3/1.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, BMKGeneralDelegate, BMKLocationServiceDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

