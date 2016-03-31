//
//  UserLocationModel.h
//  MapDemo
//
//  Created by xdzhangm on 16/3/31.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "ISSJSONModel.h"

@protocol UserLocationModel <NSObject>
@end

@interface UserLocationModel : ISSJSONModel
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
+ (instancetype)get;
- (void)save;
- (instancetype)clear;
- (BOOL)isValidLocation;
@end
