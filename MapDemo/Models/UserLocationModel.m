//
//  UserLocationModel.m
//  MapDemo
//
//  Created by xdzhangm on 16/3/31.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "UserLocationModel.h"

#define KEY_LOCATION_INFO           @"location_info_key"

@implementation UserLocationModel
+ (instancetype)sharedInstance
{
    static UserLocationModel *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[UserLocationModel alloc] init];
    });
    return _instance;
}
- (void)save
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[self toDictionary] forKey:KEY_LOCATION_INFO];
    [userDefaults synchronize];
}

- (instancetype)clear
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:KEY_LOCATION_INFO];
    [userDefaults synchronize];
    
    _lat = 0;
    _lng = 0;
    
    return self;
}

- (BOOL)isValidLocation
{
    return _lat > 0 && _lng > 0;
}

+ (instancetype)get
{
    UserLocationModel *info = [self sharedInstance];
    if([info isValidLocation])
    {
        return info;
    }
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* userDic = [userDefaults objectForKey:KEY_LOCATION_INFO];
    if(userDic && userDic.count > 0)
    {
        return [info initWithDictionary:userDic error:nil];
    }
    return info;
}
@end
