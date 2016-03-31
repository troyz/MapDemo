//
//  MapLocationItemModel.h
//  MapDemo
//
//  Created by iss110302000283 on 16/3/29.
//  Copyright © 2016年 isoftstone. All rights reserved.
//

#import "ISSJSONModel.h"

@protocol MapLocationItemModel <NSObject>
@end

@interface MapLocationItemModel : ISSJSONModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lng;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) ISSLocationType locType;
@end

@interface MapItemModel : ISSJSONModel
@property (nonatomic, copy) NSString *imgName;
// 图片左上角经纬度
@property (nonatomic, assign) CGFloat topLeftLat;
@property (nonatomic, assign) CGFloat topLeftLng;
// 缩放比例，标准平面坐标是在百度地图18级。
@property (nonatomic, assign) CGFloat zoomRate;
// 原始图片尺寸
@property (nonatomic, assign) NSInteger originalImageWidth;
@property (nonatomic, assign) NSInteger originalImageHeight;
@property (nonatomic, strong) NSMutableArray<MapLocationItemModel> *locationList;
// 如果是本地图片的话，返回图片本地全路径，
- (NSString *)localImageFullPath;
@end